;; Pipeline Integrity Monitor Contract
;; Monitor pipeline conditions, detect corrosion, identify leaks, schedule inspections, and ensure regulatory compliance

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-unauthorized (err u102))
(define-constant err-invalid-input (err u103))
(define-constant err-already-exists (err u104))

;; Pipeline status
(define-constant status-operational u1)
(define-constant status-maintenance u2)
(define-constant status-failed u3)
(define-constant status-decommissioned u4)

;; Leak severity
(define-constant severity-minor u1)
(define-constant severity-moderate u2)
(define-constant severity-major u3)
(define-constant severity-critical u4)

;; Data Variables
(define-data-var next-segment-id uint u1)
(define-data-var next-inspection-id uint u1)
(define-data-var next-leak-id uint u1)
(define-data-var next-corrosion-id uint u1)
(define-data-var total-segments uint u0)
(define-data-var total-inspections uint u0)
(define-data-var total-leaks uint u0)

;; Data Maps
(define-map pipeline-segments
  { segment-id: uint }
  {
    location: (string-ascii 200),
    diameter: uint,
    length: uint,
    material: (string-ascii 50),
    installation-date: uint,
    operating-pressure: uint,
    status: uint,
    risk-score: uint,
    last-inspection: uint,
    operator: principal
  }
)

(define-map inspections
  { inspection-id: uint }
  {
    segment-id: uint,
    inspection-type: (string-ascii 100),
    inspection-date: uint,
    inspector: principal,
    findings: (string-ascii 500),
    compliance-status: bool,
    next-inspection-due: uint,
    defects-found: uint
  }
)

(define-map leak-reports
  { leak-id: uint }
  {
    segment-id: uint,
    detected-date: uint,
    severity: uint,
    location-details: (string-ascii 200),
    estimated-volume: uint,
    repair-status: bool,
    repair-date: (optional uint),
    reported-by: principal
  }
)

(define-map corrosion-data
  { corrosion-id: uint }
  {
    segment-id: uint,
    survey-date: uint,
    cathodic-protection-reading: int,
    coating-condition: uint,
    corrosion-rate: uint,
    remediation-required: bool,
    surveyor: principal
  }
)

(define-map compliance-records
  { segment-id: uint }
  {
    phmsa-compliant: bool,
    last-audit-date: uint,
    violations: uint,
    next-audit-due: uint,
    regulatory-status: (string-ascii 100)
  }
)

;; Public Functions

;; Register pipeline segment
(define-public (register-pipeline-segment
    (location (string-ascii 200))
    (diameter uint)
    (length uint)
    (material (string-ascii 50))
    (operating-pressure uint))
  (let
    (
      (segment-id (var-get next-segment-id))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> diameter u0) err-invalid-input)
    (asserts! (> length u0) err-invalid-input)
    
    (map-set pipeline-segments
      { segment-id: segment-id }
      {
        location: location,
        diameter: diameter,
        length: length,
        material: material,
        installation-date: block-height,
        operating-pressure: operating-pressure,
        status: status-operational,
        risk-score: u50,
        last-inspection: block-height,
        operator: tx-sender
      }
    )
    
    (map-set compliance-records
      { segment-id: segment-id }
      {
        phmsa-compliant: true,
        last-audit-date: block-height,
        violations: u0,
        next-audit-due: (+ block-height u52560),
        regulatory-status: "compliant"
      }
    )
    
    (var-set next-segment-id (+ segment-id u1))
    (var-set total-segments (+ (var-get total-segments) u1))
    (ok segment-id)
  )
)

;; Record inspection
(define-public (record-inspection
    (segment-id uint)
    (inspection-type (string-ascii 100))
    (findings (string-ascii 500))
    (compliance-status bool)
    (defects-found uint))
  (let
    (
      (inspection-id (var-get next-inspection-id))
      (segment (unwrap! (map-get? pipeline-segments { segment-id: segment-id }) err-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    
    (map-set inspections
      { inspection-id: inspection-id }
      {
        segment-id: segment-id,
        inspection-type: inspection-type,
        inspection-date: block-height,
        inspector: tx-sender,
        findings: findings,
        compliance-status: compliance-status,
        next-inspection-due: (+ block-height u26280),
        defects-found: defects-found
      }
    )
    
    (map-set pipeline-segments
      { segment-id: segment-id }
      (merge segment { last-inspection: block-height })
    )
    
    (var-set next-inspection-id (+ inspection-id u1))
    (var-set total-inspections (+ (var-get total-inspections) u1))
    (ok inspection-id)
  )
)

;; Report leak
(define-public (report-leak
    (segment-id uint)
    (severity uint)
    (location-details (string-ascii 200))
    (estimated-volume uint))
  (let
    (
      (leak-id (var-get next-leak-id))
      (segment (unwrap! (map-get? pipeline-segments { segment-id: segment-id }) err-not-found))
    )
    (asserts! (<= severity severity-critical) err-invalid-input)
    
    (map-set leak-reports
      { leak-id: leak-id }
      {
        segment-id: segment-id,
        detected-date: block-height,
        severity: severity,
        location-details: location-details,
        estimated-volume: estimated-volume,
        repair-status: false,
        repair-date: none,
        reported-by: tx-sender
      }
    )
    
    (map-set pipeline-segments
      { segment-id: segment-id }
      (merge segment { status: status-maintenance })
    )
    
    (var-set next-leak-id (+ leak-id u1))
    (var-set total-leaks (+ (var-get total-leaks) u1))
    (ok leak-id)
  )
)

;; Complete leak repair
(define-public (complete-leak-repair (leak-id uint))
  (let
    (
      (leak (unwrap! (map-get? leak-reports { leak-id: leak-id }) err-not-found))
      (segment-id (get segment-id leak))
      (segment (unwrap! (map-get? pipeline-segments { segment-id: segment-id }) err-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    
    (map-set leak-reports
      { leak-id: leak-id }
      (merge leak {
        repair-status: true,
        repair-date: (some block-height)
      })
    )
    
    (map-set pipeline-segments
      { segment-id: segment-id }
      (merge segment { status: status-operational })
    )
    (ok true)
  )
)

;; Record corrosion survey
(define-public (record-corrosion-survey
    (segment-id uint)
    (cathodic-protection-reading int)
    (coating-condition uint)
    (corrosion-rate uint)
    (remediation-required bool))
  (let
    (
      (corrosion-id (var-get next-corrosion-id))
      (segment (unwrap! (map-get? pipeline-segments { segment-id: segment-id }) err-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (<= coating-condition u100) err-invalid-input)
    
    (map-set corrosion-data
      { corrosion-id: corrosion-id }
      {
        segment-id: segment-id,
        survey-date: block-height,
        cathodic-protection-reading: cathodic-protection-reading,
        coating-condition: coating-condition,
        corrosion-rate: corrosion-rate,
        remediation-required: remediation-required,
        surveyor: tx-sender
      }
    )
    
    (var-set next-corrosion-id (+ corrosion-id u1))
    (ok corrosion-id)
  )
)

;; Update compliance status
(define-public (update-compliance-status
    (segment-id uint)
    (phmsa-compliant bool)
    (violations uint))
  (let
    (
      (compliance (unwrap! (map-get? compliance-records { segment-id: segment-id }) err-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    
    (map-set compliance-records
      { segment-id: segment-id }
      (merge compliance {
        phmsa-compliant: phmsa-compliant,
        last-audit-date: block-height,
        violations: violations,
        regulatory-status: (if phmsa-compliant "compliant" "non-compliant")
      })
    )
    (ok true)
  )
)

;; Update pipeline status
(define-public (update-pipeline-status
    (segment-id uint)
    (new-status uint))
  (let
    (
      (segment (unwrap! (map-get? pipeline-segments { segment-id: segment-id }) err-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (<= new-status status-decommissioned) err-invalid-input)
    
    (map-set pipeline-segments
      { segment-id: segment-id }
      (merge segment { status: new-status })
    )
    (ok true)
  )
)

;; Calculate risk score
(define-public (calculate-risk-score
    (segment-id uint)
    (age-factor uint)
    (corrosion-factor uint)
    (pressure-factor uint))
  (let
    (
      (segment (unwrap! (map-get? pipeline-segments { segment-id: segment-id }) err-not-found))
      (risk-score (/ (+ age-factor corrosion-factor pressure-factor) u3))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (<= risk-score u100) err-invalid-input)
    
    (map-set pipeline-segments
      { segment-id: segment-id }
      (merge segment { risk-score: risk-score })
    )
    (ok risk-score)
  )
)

;; Read-Only Functions

(define-read-only (get-pipeline-info (segment-id uint))
  (map-get? pipeline-segments { segment-id: segment-id })
)

(define-read-only (get-inspection-record (inspection-id uint))
  (map-get? inspections { inspection-id: inspection-id })
)

(define-read-only (get-leak-report (leak-id uint))
  (map-get? leak-reports { leak-id: leak-id })
)

(define-read-only (get-corrosion-data (corrosion-id uint))
  (map-get? corrosion-data { corrosion-id: corrosion-id })
)

(define-read-only (get-compliance-status (segment-id uint))
  (map-get? compliance-records { segment-id: segment-id })
)

(define-read-only (get-total-segments)
  (ok (var-get total-segments))
)

(define-read-only (get-total-inspections)
  (ok (var-get total-inspections))
)

(define-read-only (get-total-leaks)
  (ok (var-get total-leaks))
)

(define-read-only (is-segment-compliant (segment-id uint))
  (match (map-get? compliance-records { segment-id: segment-id })
    compliance (ok (get phmsa-compliant compliance))
    err-not-found
  )
)

