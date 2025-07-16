;; ProofOfReputation - On-Chain Peer Reputation System

;; Store contract owner
(define-data-var contract-owner principal tx-sender)

;; Map to store user reputation scores
(define-map reputations 
  principal 
  {score: uint})

;; Map to track endorsements between users
(define-map endorsements 
  {from: principal, to: principal} 
  {voted: bool})

;; Optional: DAO-admin whitelisting
(define-map allowed-voters 
  principal 
  {allowed: bool})

;; Admin function to whitelist voters (optional feature)
(define-public (add-voter (voter principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err u100))
    (map-set allowed-voters voter {allowed: true})
    (ok true)))

;; Public function to endorse another user
(define-public (endorse (recipient principal))
  (let (
    (already-voted (default-to {voted: false} 
                               (map-get? endorsements {from: tx-sender, to: recipient})))
    (allowed (default-to {allowed: true} 
                        (map-get? allowed-voters tx-sender)))
    (prev-score (default-to {score: u0} 
                           (map-get? reputations recipient))))
    (begin
      ;; No self-voting
      (asserts! (not (is-eq tx-sender recipient)) (err u103))
      ;; One vote per user pair
      (asserts! (not (get voted already-voted)) (err u101))
      ;; Optional: Must be allowed to vote
      (asserts! (get allowed allowed) (err u102))
      ;; Increase reputation score
      (map-set reputations recipient {score: (+ (get score prev-score) u1)})
      ;; Mark endorsement as completed
      (map-set endorsements {from: tx-sender, to: recipient} {voted: true})
      ;; Return new score
      (ok (+ (get score prev-score) u1)))))

;; Read-only: Get reputation score
(define-read-only (get-score (user principal))
  (ok (get score (default-to {score: u0} (map-get? reputations user)))))

;; Read-only: Check if user has already endorsed another user
(define-read-only (has-endorsed (from principal) (to principal))
  (ok (get voted (default-to {voted: false} 
                            (map-get? endorsements {from: from, to: to})))))

;; Read-only: Check if voter is allowed (for DAO functionality)
(define-read-only (is-allowed-voter (voter principal))
  (ok (get allowed (default-to {allowed: true} 
                              (map-get? allowed-voters voter)))))

;; Read-only: Get contract owner
(define-read-only (get-contract-owner)
  (ok (var-get contract-owner)))
