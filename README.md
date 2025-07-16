 Proof of Reputation Smart Contract

 Overview
The **Proof of Reputation** smart contract is designed to enable decentralized reputation tracking on the Stacks blockchain. It allows users to submit reputation proofs verified by third parties and store these records immutably on-chain. This facilitates trustless evaluation of users' credibility for applications like decentralized finance (DeFi), marketplaces, governance, and professional networks.

---

 Features
-  Submit reputation proofs with a score and verifier.
-  On-chain storage of immutable reputation records.
-  Read-only access to retrieve reputation details of any user.
-  Transparent and auditable reputation tracking.

---

 Functions

 1. `submit-reputation-proof`
- **Description**: Records a user's reputation score and the verifier of that score.
- **Parameters**:
  - `user (principal)`: The user's principal address.
  - `verifier (principal)`: The address of the verifying entity.
  - `score (uint)`: The reputation score being recorded.
- **Returns**: `(ok true)` on success.

 2. `get-reputation-proof`
- **Description**: Fetches the reputation proof associated with a user.
- **Parameters**:
  - `user (principal)`: The principal address to query.
- **Returns**: A tuple containing:
  - `verifier`: The verifier's principal.
  - `score`: The reputation score.

---

 Example Usage
```clarity
;; Submit a reputation proof
(contract-call? .proof-of-reputation submit-reputation-proof user-verifier user-address u85)

;; Retrieve a user's reputation proof
(contract-call? .proof-of-reputation get-reputation-proof user-address)
