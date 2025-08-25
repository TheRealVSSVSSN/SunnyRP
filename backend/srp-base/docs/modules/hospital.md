# Hospital Module

## Purpose
Tracks patient admissions at Pillbox hospital.

## Routes
- `GET /v1/hospital/admissions/active` – List active admissions.
- `POST /v1/hospital/admissions` – Admit a character (`characterId`, `reason`, optional `bed`, `notes`).
- `POST /v1/hospital/admissions/{id}/discharge` – Discharge an admission.

## Repository Contracts
- `getActiveAdmissions()` → Array of admissions.
- `createAdmission({ characterId, reason, bed, notes })` → Admission (existing if already admitted).
- `dischargeAdmission(id)` → Admission or `null`.

## Edge Cases
- Admitting a character already admitted returns the existing record.
- Discharging an unknown admission returns a 404.
