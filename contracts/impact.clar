;; Scholarly Impact Network Smart Contract
;; This contract allows scholars to:
;; 1. Register scholarly publications
;; 2. Record references between publications
;; 3. Track impact metrics
;; 4. Verify publication ownership
;; 5. Implement scholarly recognition rewards

(define-constant CONTRACT_ADMIN tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_DUPLICATE_ENTRY (err u101))
(define-constant ERR_NOT_FOUND (err u102))
(define-constant ERR_SELF_REFERENCE (err u103))
(define-constant ERR_INVALID_PARAMS (err u104))
(define-constant ERR_BAD_INPUT (err u105))

;; Data Structures

;; Scholarly publication information
(define-map publications
  { publication-id: (string-ascii 64) }
  {
    title: (string-ascii 256),
    scholar: principal,
    timestamp: uint,
    discipline: (string-ascii 64),
    summary: (string-utf8 1024),
    validated: bool
  }
)

;; Reference data
(define-map reference-records
  {
    referencing-pub: (string-ascii 64),
    referenced-pub: (string-ascii 64)
  }
  {
    timestamp: uint,
    note: (optional (string-utf8 256)),
    significance: uint
  }
)

;; Reference count per publication
(define-map reference-counts
  { publication-id: (string-ascii 64) }
  { count: uint }
)

;; Scholar profile tracking
(define-map scholar-profiles
  { scholar: principal }
  {
    total-publications: uint,
    total-references-received: uint,
    impact-score: uint
  }
)

;; Discipline-specific impact metrics
(define-map discipline-metrics
  { discipline: (string-ascii 64) }
  {
    total-publications: uint,
    total-references: uint
  }
)

;; Recognition points for references
(define-map scholarly-recognition
  { scholar: principal }
  { recognition-points: uint }
)

;; Approved validators
(define-map approved-validators
  { validator: principal }
  { active: bool }
)

;; Validation functions

;; Validate string-ascii is not empty
(define-private (validate-string-ascii (input (string-ascii 256)))
  (> (len input) u0)
)

;; Validate string-utf8 is not empty (if present)
(define-private (validate-optional-string-utf8 (input (optional (string-utf8 256))))
  (match input
    some-val (> (len some-val) u0)
    true
  )
)

;; Validate publication-id
(define-private (validate-publication-id (publication-id (string-ascii 64)))
  (and
    (> (len publication-id) u0)
    (<= (len publication-id) u64)
  )
)

;; Validate principal is not null
(define-private (validate-principal (user principal))
  (not (is-eq user 'SPNWZ5V2TPWGQGVDR6T7B6RQ4XMGZ4PXTEE0VQ0S))  ;; Check against zero/null address
)

;; Initialize functions

;; Initialize reference count for a publication
(define-private (initialize-reference-count (publication-id (string-ascii 64)))
  (map-set reference-counts
    { publication-id: publication-id }
    { count: u0 }
  )
)

;; Initialize scholar profile for a new scholar
(define-private (initialize-scholar-profile (scholar principal))
  (let ((scholar-data (map-get? scholar-profiles { scholar: scholar })))
    (if (is-some scholar-data)
      true
      (map-set scholar-profiles
        { scholar: scholar }
        {
          total-publications: u0,
          total-references-received: u0,
          impact-score: u100
        }
      )
    )
  )
)

;; Initialize discipline metrics
(define-private (initialize-discipline-metrics (discipline (string-ascii 64)))
  (let ((discipline-data (map-get? discipline-metrics { discipline: discipline })))
    (if (is-some discipline-data)
      true
      (map-set discipline-metrics
        { discipline: discipline }
        {
          total-publications: u0,
          total-references: u0
        }
      )
    )
  )
)

;; Initialize scholarly recognition
(define-private (initialize-scholarly-recognition (scholar principal))
  (let ((recognition-data (map-get? scholarly-recognition { scholar: scholar })))
    (if (is-some recognition-data)
      true
      (map-set scholarly-recognition
        { scholar: scholar }
        { recognition-points: u0 }
      )
    )
  )
)

;; Core Functions

;; Register a new scholarly publication
(define-public (register-publication
                (publication-id (string-ascii 64))
                (title (string-ascii 256))
                (discipline (string-ascii 64))
                (summary (string-utf8 1024)))
  (let
    ((scholar tx-sender)
     (existing-publication (map-get? publications { publication-id: publication-id })))
    (begin
      ;; Validate inputs
      (asserts! (validate-publication-id publication-id) ERR_BAD_INPUT)
      (asserts! (validate-string-ascii title) ERR_BAD_INPUT)
      (asserts! (validate-string-ascii discipline) ERR_BAD_INPUT)
      (asserts! (> (len summary) u0) ERR_BAD_INPUT)
      
      (asserts! (is-none existing-publication) ERR_DUPLICATE_ENTRY)
      
      ;; Initialize or update scholar profile
      (initialize-scholar-profile scholar)
      (map-set scholar-profiles
        { scholar: scholar }
        (merge
          (default-to
            { total-publications: u0, total-references-received: u0, impact-score: u100 }
            (map-get? scholar-profiles { scholar: scholar })
          )
          { total-publications: (+ (get total-publications (default-to
                               { total-publications: u0, total-references-received: u0, impact-score: u100 }
                               (map-get? scholar-profiles { scholar: scholar })))
                            u1) }
        )
      )
      
      ;; Initialize discipline metrics
      (initialize-discipline-metrics discipline)
      (map-set discipline-metrics
        { discipline: discipline }
        (merge
          (default-to
            { total-publications: u0, total-references: u0 }
            (map-get? discipline-metrics { discipline: discipline })
          )
          { total-publications: (+ (get total-publications (default-to
                               { total-publications: u0, total-references: u0 }
                               (map-get? discipline-metrics { discipline: discipline })))
                            u1) }
        )
      )
      
      ;; Create publication record
      (map-set publications
        { publication-id: publication-id }
        {
          title: title,
          scholar: scholar,
          timestamp: block-height,
          discipline: discipline,
          summary: summary,
          validated: false
        }
      )
      
      ;; Initialize reference count
      (initialize-reference-count publication-id)
      
      ;; Initialize scholarly recognition
      (initialize-scholarly-recognition scholar)
      
      (ok true)
    )
  )
)
