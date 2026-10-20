# ✅ Before Deployment

Complete the following checks before running the toolkit:

1. Use PowerShell 7.0 or later.
2. Download or clone the complete repository.
3. Keep the original folder structure unchanged.
4. Review `Purview/Config/PurviewConfig.psd1`.
5. Confirm the sensitivity labels, DLP rules, retention settings, and AI controls match the customer requirements.
6. Use an account with the required permissions for the selected Purview workloads.
7. Test in a pilot tenant before deploying to production.
8. Run `-WhatIf` before the real deployment.

> [!IMPORTANT]
> Always review every proposed change before running a real deployment in a production tenant.

> [!WARNING]
> Keep DLP in simulation until alerts and possible false positives have been reviewed. Retention is optional and must not be enabled without confirming the customer's legal, regulatory, and business requirements.

## Next step

Follow the [deployment guide](how-to-run.md).

---

[← Back to the main README](../../README.md)