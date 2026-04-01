# Task: Provisioning Error Surfacing

## ID
TASK-0004

## State
ready

## Branch
`feature/provisioning-error-surfacing`

## Roadmap Reference
- `ops/TODO.md` -> `Immediate Follow-Up (Provisioning Error Surfacing)`

## Goal
Replace the generic deployment error `Terraform apply failed` with a user-safe, actionable provisioning error message derived from the underlying provider failure, while preserving provider-specific detail for operator debugging.

## Blast Radius
small

## Rollout Class
staging

## Context
Today the provisioner stores a generic deployment error when Terraform apply fails, even when the provider returned a precise cause such as `out of stock` or `quota exceeded`. That leaves the web UI unhelpful for users and slows down operator debugging.

The current provisioning path is provider-specific at execution time, but the user-facing error contract should not be locked to Scaleway wording because other providers may be added later.

Today `run_terraform_apply` captures Terraform stderr internally, logs it, and returns `None` on failure. The caller only sees a generic apply failure and cannot normalize the underlying provider error. This slice must change that flow so the caller receives failure detail to parse before storing the user-facing deployment error.

## Scope
- Introduce a small provider-agnostic provisioning error reason model for deployment failures.
- Use a fixed initial reason-code set:
  - `CAPACITY_UNAVAILABLE`
  - `QUOTA_EXCEEDED`
  - `IMAGE_UNAVAILABLE`
  - `BOOT_FAILED`
  - `UNKNOWN`
- Add first-pass parsing/mapping for common Scaleway provisioning failures, including:
  - capacity / out-of-stock
  - quota exceeded
  - image not found / image unavailable
  - instance created but not running / boot failed
- Preserve the generic fallback path for unknown failures.
- Persist a user-safe normalized provisioning message on `deployment.error_message` in place of the current generic `Terraform apply failed`.
- Preserve provider-specific raw detail in provisioner logs for operator debugging.
- Update the UI/API path as needed so the user sees the normalized message already stored on the deployment.
- Add focused tests for normalization/mapping behavior.

Canonical user-safe messages for this slice:
- `CAPACITY_UNAVAILABLE` -> `Selected GPU is temporarily unavailable in the provider zone. Please retry later or choose another GPU type.`
- `QUOTA_EXCEEDED` -> `Provisioning failed because the provider quota is exhausted for this account or zone. Please try another GPU type or contact support.`
- `IMAGE_UNAVAILABLE` -> `Provisioning failed because the required machine image is unavailable for the selected configuration. Please retry later or contact support.`
- `BOOT_FAILED` -> `Provisioning failed because the provider instance did not reach a running state. Please retry later.`
- `UNKNOWN` -> `Provisioning failed due to a provider error. Please retry later or contact support if the problem persists.`

## Out of Scope
- Zone failover or retry logic.
- Multi-zone capacity discovery.
- Automatic reprovision / retry on another GPU type or provider.
- Broad provisioning workflow redesign.
- Provider abstraction work beyond the minimal normalized reason model.
- Full operator observability/dashboard work.

## Future Follow-Ups
- Add zone fallback / retry planning and implementation once error surfacing is in place.
- Extend provider-specific mappings for additional providers such as AWS.
- Decide whether deployment records should store both normalized reason code and raw provider detail separately.

## Dependencies / Prerequisites
- Existing provisioner worker remains the source of Terraform stderr.
- Existing deployment error UI already surfaces `deployment.error_message`.
- The current provisioning path remains Terraform-based for Scaleway.

## Constraints
- Keep the slice small and backend-first.
- Use a provider-agnostic normalized reason shape even though only Scaleway mappings are added in this slice.
- Implement the normalized reason model as a fixed set of string reason codes, each mapped to one user-safe message string, in one dedicated module/helper.
- Replace `deployment.error_message` in place for this slice; do not add a new DB/API field yet.
- Do not expose raw Terraform/provider stderr directly to end users.
- Do not change provisioning retry behavior in this slice.
- Preserve existing unknown-error behavior when no mapping matches.
- Change `run_terraform_apply` so failure detail is propagated to the caller instead of being reduced to bare `None`.
- `BOOT_FAILED` in this slice covers only provider-reported boot/startup errors surfaced during Terraform apply; it does not include post-apply health check timeouts.
- UI/API changes are only needed if current rendering suppresses or overrides `deployment.error_message`; no frontend or API contract changes are expected by default.

## Risks
- Overfitting the normalization logic to Scaleway wording could make later providers harder to support.
- Exposing too much raw provider detail could leak operator-only information into the UI.
- If the normalized messages are too vague, the slice will not improve user experience materially.
- If the normalized messages are too specific, they may become brittle against provider wording changes.

## Artifacts to Update
- likely `provisioner/worker.py`
- likely a new small helper module under `provisioner/` or `api/app/`
- possibly deployment schemas / API docs only if response shape changes
- frontend/UI files only if current rendering suppresses or overrides `deployment.error_message`
- tests covering provisioning error normalization and UI/API display behavior
- task-local handoff files under `agentic/handoffs/TASK-0004-provisioning-error-surfacing/`

## Verification Plan
- Add focused tests for normalization of common Scaleway provisioning failures:
  - out of stock -> user-safe capacity message
  - quota exceeded -> user-safe quota message
  - image unavailable -> user-safe image/configuration message
  - instance stopped instead of running during apply -> user-safe boot/startup message
  - unknown stderr -> generic fallback message
- Confirm the deployment record stores the normalized user-facing message after a simulated Terraform apply failure.
- Confirm the existing UI/API path surfaces that stored message without requiring a contract break.
- Record which provider-specific details remain logs-only.
- Staging smoke: preferably provoke one known failure and verify the UI no longer shows the generic Terraform message.
- If a live failure is impractical to trigger on demand, use a replay/assertion path against captured Terraform stderr and record that as the staging substitute.

## Done When
- Common Scaleway provisioning failures are mapped to the fixed normalized reason-code set.
- Deployment error state stores a user-safe message more specific than `Terraform apply failed`.
- Unknown provisioning failures still fall back safely.
- Raw provider stderr remains available in logs for operators.
- Focused tests cover the normalization behavior.
- Staging confirms the user sees the improved message for at least one failure (live or replayed from captured stderr).
