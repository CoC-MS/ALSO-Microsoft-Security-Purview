# Security Policy

## Scope

The ALSO Microsoft Purview Best Practice Deployment Toolkit provides reusable PowerShell scripts, configuration files, policies, automation, and documentation intended to accelerate Microsoft Purview security and compliance deployments.

The toolkit covers tenant settings, sensitivity labels, label publishing, Data Loss Prevention (DLP), sensitive information type policies, optional Exchange retention, AI governance controls, and deployment reporting.

## Implementing Partner Responsibilities

The implementing partner is responsible for:

- Reviewing all scripts, configuration values, policy definitions, and proposed changes before deployment.
- Confirming product licensing, administrator permissions, technical prerequisites, and dependencies.
- Assessing compatibility with the customer's existing tenant configuration and integrations.
- Confirming that labels, policy assignments, DLP rules, retention settings, and AI controls meet customer requirements.
- Testing the toolkit in a dedicated test or pilot environment.
- Running the toolkit with `-WhatIf` and reviewing the complete output before every deployment or rerun.
- Planning an appropriate staged rollout and obtaining the required customer approvals.
- Monitoring deployment results and validating the configuration and intended behavior in Microsoft Purview.
- Maintaining a documented rollback or recovery plan appropriate to the changes being deployed.

## Deployment Precautions

### DLP Policies

Keep DLP policies in simulation until alerts, user impact, and possible false positives have been reviewed.

Do not assume that a successful deployment means blocking is active or that the policies provide complete protection against data loss.

### Retention

Retention is optional and requires `-ApplyRetention`.

Before enabling retention, confirm the retention duration and subsequent deletion behavior with the customer's responsible legal, compliance, and business stakeholders.

Do not assume that retention or deletion effects can be reversed by removing the policy.

### Existing Tenant Configuration

Review existing policies, rules, labels, assignments, and settings before deployment.

Before using `-AdoptExisting`, confirm that the matching objects are intended to be managed by this toolkit. Do not assume that existing objects belong to the toolkit.

### Validation and Reporting

Review the complete console output and generated HTML report.

A stage marked `OK` indicates completion without a terminating error. It does not guarantee that the configuration is appropriate, that policy propagation has completed, or that enforcement works as intended.

Validate the resulting configuration and perform functional tests in the customer environment.

## Credentials and Customer Information

- Never commit passwords, secrets, certificates, private keys, or access tokens to the repository.
- Do not publish customer-specific configuration, deployment reports, or tenant information.
- Use least-privileged administrative access appropriate to the selected workloads.
- Protect locally stored configuration files, logs, and reports.
- Remove sensitive information before sharing diagnostic output or screenshots.

## Important Usage Notice

This toolkit provides a reusable baseline, not a complete or universally applicable security or compliance solution.

Every customer environment is different. Licensing, existing configurations, integrations, supported platforms, regulatory requirements, and changes to Microsoft products or services may affect deployment behavior and policy enforcement.

The materials must be reviewed and tested for the intended customer environment before production use.

ALSO does not guarantee that the toolkit is suitable for every customer environment or that it will operate without errors, interruptions, conflicts, or unintended effects.

Use of the toolkit does not, by itself, establish compliance with any legal, regulatory, contractual, or industry requirement.

## Reporting Security Concerns

Do not disclose vulnerabilities, credentials, customer data, or sensitive tenant information in public issues or pull requests.

Report security concerns privately through an established ALSO or implementing-partner contact.

Provide only the information necessary to investigate the concern, with sensitive details removed.

## Disclaimer and Limitation of Liability

The materials in this repository, including scripts, configuration files, policies, automation, documentation, and examples, are provided on an "as is" and "as available" basis.

To the extent permitted by applicable law, ALSO makes no warranties or guarantees that the materials are error-free, suitable for a particular purpose, compatible with every customer environment, or capable of producing a specific security, compliance, or operational outcome.

Customer environments may contain variables outside ALSO's knowledge or control, including existing configurations, third-party products, licensing limitations, unsupported platforms, service dependencies, regulatory requirements, and changes to Microsoft products or services.

The implementing partner remains responsible for evaluating the materials, confirming prerequisites, testing in a non-production environment, obtaining customer approvals, conducting a controlled rollout, and maintaining appropriate rollback and recovery procedures.

To the extent permitted by applicable law, and subject to the applicable license terms, ALSO shall not be liable for loss or damage arising from the use of, inability to use, or deployment of the materials in this repository.

Nothing in this notice excludes or limits liability that cannot lawfully be excluded or limited.

## License

This security and usage notice supplements the Apache License 2.0 applicable to this repository.

It does not replace, amend, or override the terms contained in the `LICENSE` file. In the event of a conflict, the applicable license terms prevail.
