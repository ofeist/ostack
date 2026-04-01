# Review Handoff

## Accepted Finding
- Only provider/apply stderr should be routed through the normalization helper.
- Internal failures after a successful apply (for example Terraform output extraction problems) should not be mislabeled as provider-capacity or provider-image errors.

## Integrated Fix
- Added `normalize_stderr` to `TerraformApplyResult`.
- Set `normalize_stderr=True` only when `terraform apply` itself returns non-zero stderr from the provider.
- Kept output extraction failures, timeouts, and local exceptions on a generic provisioning failure message.
- Added focused regression coverage for the internal/output-failure path.

## Verification
- `python3 -m py_compile provisioner/provisioning_errors.py provisioner/worker.py tests/provisioner/test_provisioning_errors.py`
- `pytest -q tests/provisioner/test_provisioning_errors.py`
  - result: `8 passed`
