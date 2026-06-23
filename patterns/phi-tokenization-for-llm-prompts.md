# PHI Tokenization for LLM Prompts

When building healthcare AI systems, developers often utilize external Large Language Models (LLMs) (e.g., OpenAI, Anthropic, or regional cloud API endpoints). Sending raw Protected Health Information (PHI) directly to external APIs may violate HIPAA unless a strict Business Associate Agreement (BAA) is signed, and even with a BAA, minimizing external PHI exposure is a security best practice.

This pattern describes an architecture to redact/tokenize PHI before it leaves the secure environment and detokenize the response inline.

---

## 1. Sequence & Data Flow

```text
+-------------+         +-------------+         +---------------+         +-------------+
| Application |         | Tokenizer   |         | Ephemeral DB  |         | External    |
| Logic       |         | Proxy       |         | (Redis / KMS) |         | LLM API     |
+-------------+         +-------------+         +---------------+         +-------------+
       |                       |                        |                        |
       |-- 1. Prompt with PHI ->|                        |                        |
       |   ("Summarize note    |                        |                        |
       |   for John Doe...")   |-- 2. Scan & Tokenize ->|                        |
       |                       |      John Doe -> UUID1 |                        |
       |                       |-- 3. Save Map in DB -->|                        |
       |                       |                        |                        |
       |                       |-- 4. Send Tokenized Prompt -------------------->|
       |                       |      ("Summarize note for [PATIENT_1]...")      |
       |                       |                                                 |
       |                       |<-- 5. Receive Response -------------------------|
       |                       |      ("Patient [PATIENT_1] was diagnosed...")   |
       |                       |                                                 |
       |                       |-- 6. Retrieve Map ---->|                        |
       |                       |<-- 7. Returns Map -----|                        |
       |                       |                                                 |
       |                       |-- 8. Replace Tokens -->|                        |
       |                       |      [PATIENT_1] -> John Doe                    |
       |                       |                        |                        |
       |<-- 9. Detokenized ----|                        |                        |
       |   Response            |                        |                        |
```

---

## 2. Implementation Walkthrough

### Step A: Inline Scanning & Detection
The tokenization proxy intercepts all outbound LLM payloads. It runs a local Named Entity Recognition (NER) pipeline (such as **Microsoft Presidio Analyzer**, local SpaCy pipelines, or high-performance regex filters) to detect PHI classes:
- Patient/Doctor names
- Phone numbers, emails, home addresses
- Dates (birth dates, admission dates)
- Medical record numbers (MRNs)

### Step B: Tokenization & Vaulting
Detected PHI values are replaced with placeholders, and a key-value mapping is saved to a secure database inside the private network:
```json
// Prompt Sent to LLM
"The patient, [PATIENT_1], presented with fever starting on [DATE_1]. The primary care physician, [DOCTOR_1], recommended rest."

// Saved in Ephemeral Secure Store (e.g., encrypted Redis)
{
  "token_map": {
    "[PATIENT_1]": "John Doe",
    "[DATE_1]": "June 12th, 2026",
    "[DOCTOR_1]": "Dr. Sarah Jenkins"
  },
  "ttl": 300 // Ephemeral: auto-purges after 5 minutes
}
```

### Step C: Detokenization
Once the LLM yields the text response, the proxy replaces all matching placeholder strings with the original values stored in the map.

---

## 3. Implementation Code Example (Python)

```python
import uuid
import re
from typing import Dict, Tuple

class PHITokenizer:
    def __init__(self):
        # Basic demonstration regex. In production, use Microsoft Presidio or custom NER model.
        self.phone_regex = re.compile(r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b')
        self.mrn_regex = re.compile(r'\bMRN-\d{6,8}\b')

    def tokenize(self, text: str) -> Tuple[str, Dict[str, str]]:
        token_map = {}
        processed_text = text

        # Tokenize MRNs
        for match in self.mrn_regex.findall(text):
            token = f"[MRN_{uuid.uuid4().hex[:6].upper()}]"
            token_map[token] = match
            processed_text = processed_text.replace(match, token)

        # Tokenize Phones
        for match in self.phone_regex.findall(processed_text):
            token = f"[PHONE_{uuid.uuid4().hex[:6].upper()}]"
            token_map[token] = match
            processed_text = processed_text.replace(match, token)

        return processed_text, token_map

    def detokenize(self, text: str, token_map: Dict[str, str]) -> str:
        detokenized_text = text
        for token, original_val in token_map.items():
            detokenized_text = detokenized_text.replace(token, original_val)
        return detokenized_text
```

---

## 4. Key Security Controls

1. **Short Time-to-Live (TTL)**:
   - Token mapping databases must use strict TTL. Maps should automatically delete after a few minutes, reducing the storage footprint of active PHI.
2. **KMS Encrypted Storage**:
   - The token map database must be encrypted at rest utilizing customer-managed keys.
3. **No Outer Exposure**:
   - If an extraction fails, or the detokenization contains orphan placeholders, raise a hard exception to prevent returning malformed placeholders or raw maps to the end user interface.
