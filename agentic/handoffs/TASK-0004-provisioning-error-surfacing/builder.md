# Builder Handoff

## Task
- `TASK-0004` Provisioning Error Surfacing

## What Changed
- Added `provisioner/provisioning_errors.py` with a fixed normalized reason-code set and canonical user-safe messages.
- Changed `provisioner/worker.py` so `run_terraform_apply` returns structured failure detail instead of bare `None`.
- Normalized Terraform apply failures before writing `deployment.error_message`.
- Kept raw provider stderr in provisioner logs; only the normalized user-safe message is stored on the deployment.
- Left UI/API contract unchanged because existing pages already render `deployment.error_message`.

## Normalized Reason Codes
- `CAPACITY_UNAVAILABLE`
- `QUOTA_EXCEEDED`
- `IMAGE_UNAVAILABLE`
- `BOOT_FAILED`
- `UNKNOWN`

## Scope Notes
- `BOOT_FAILED` is limited to provider/apply-time `expected state running but found stopped`-style failures.
- Post-apply health check timeout remains unchanged and out of scope for this slice.
- No retry, zone fallback, or multi-provider behavior changes were made.

## Verification Run
- `python3 -m py_compile provisioner/provisioning_errors.py provisioner/worker.py tests/provisioner/test_provisioning_errors.py`
- `pytest -q tests/provisioner/test_provisioning_errors.py`
  - result: `8 passed`

## Known Gaps
- No live staging replay/smoke yet.
- Existing local `tests/provisioner/test_workspace.py` imports still require `huggingface_hub` to be installed in the host environment; that is separate from this slice.


## Review-integrated Changes
- Distinguish provider/apply stderr from internal post-apply failures using `normalize_stderr` on `TerraformApplyResult`.
- Keep internal/output-extraction failures on a generic provisioning failure message instead of provider-specific normalized copy.
- Added regression coverage for the non-provider internal failure path.
