# security-reviewer: skills

Copied unmodified from upstream. Each folder keeps its own license files.

| Skill | Source | Pinned commit | License | Loaded when |
|---|---|---|---|---|
| `security-audit` | [cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill/tree/c1c8a8c147/skills/security-audit) | `c1c8a8c147` | MIT | PRIMARY (Cloudflare). Any security audit, vulnerability hunt, pen-test style review, or security question; use its guidance mode by default and its full six-phase audit only when the user explicitly asks to audit or wants report artifacts |
| `security-review` | [getsentry/skills](https://github.com/getsentry/skills/tree/d12f250460/skills/security-review) | `d12f250460` | Apache-2.0 | a code security review for injection, authz, crypto, secrets, and framework-specific flaws |
| `security-and-hardening` | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills/tree/aeac41d4d0/skills/security-and-hardening) | `aeac41d4d0` | MIT | hardening handlers, input validation, auth, and secrets |
| `differential-review` | [trailofbits/skills](https://github.com/trailofbits/skills/tree/196a9073ab/plugins/differential-review/skills/differential-review) | `196a9073ab` | CC-BY-SA-4.0 | reviewing a change set for security impact and regressions |
| `sharp-edges` | [trailofbits/skills](https://github.com/trailofbits/skills/tree/196a9073ab/plugins/sharp-edges/skills/sharp-edges) | `196a9073ab` | CC-BY-SA-4.0 | evaluating dangerous APIs, configs, and defaults that invite misuse |
| `semgrep` | [trailofbits/skills](https://github.com/trailofbits/skills/tree/196a9073ab/plugins/static-analysis/skills/semgrep) | `196a9073ab` | CC-BY-SA-4.0 | running a rule-based static scan across the codebase |
| `variant-analysis` | [trailofbits/skills](https://github.com/trailofbits/skills/tree/196a9073ab/plugins/variant-analysis/skills/variant-analysis) | `196a9073ab` | CC-BY-SA-4.0 | a vulnerability was found and every variant must be located |
| `supply-chain-risk-auditor` | [trailofbits/skills](https://github.com/trailofbits/skills/tree/196a9073ab/plugins/supply-chain-risk-auditor/skills/supply-chain-risk-auditor) | `196a9073ab` | CC-BY-SA-4.0 | auditing dependencies for advisories, abandonment, and install-script risk |
| `gha-security-review` | [getsentry/skills](https://github.com/getsentry/skills/tree/d12f250460/skills/gha-security-review) | `d12f250460` | Apache-2.0 | reviewing GitHub Actions workflows for injection and privilege problems |
| `agentic-actions-auditor` | [trailofbits/skills](https://github.com/trailofbits/skills/tree/196a9073ab/plugins/agentic-actions-auditor/skills/agentic-actions-auditor) | `196a9073ab` | CC-BY-SA-4.0 | workflows invoke AI agents with untrusted input |
| `secret-serialization` | [getsentry/skills](https://github.com/getsentry/skills/tree/d12f250460/skills/secret-serialization) | `d12f250460` | Apache-2.0 | checking whether secrets can leak via serializers, logs, or API responses |
| `stride-analysis-patterns` | [wshobson/agents](https://github.com/wshobson/agents/tree/0874a27b17/plugins/security-scanning/skills/stride-analysis-patterns) | `0874a27b17` | MIT | threat-modeling a new feature or system |
| `attack-tree-construction` | [wshobson/agents](https://github.com/wshobson/agents/tree/0874a27b17/plugins/security-scanning/skills/attack-tree-construction) | `0874a27b17` | MIT | mapping attack paths to a critical asset |
| `threat-mitigation-mapping` | [wshobson/agents](https://github.com/wshobson/agents/tree/0874a27b17/plugins/security-scanning/skills/threat-mitigation-mapping) | `0874a27b17` | MIT | mapping each threat to a control and prioritizing |
| `sast-configuration` | [wshobson/agents](https://github.com/wshobson/agents/tree/0874a27b17/plugins/security-scanning/skills/sast-configuration) | `0874a27b17` | MIT | setting up or tuning SAST in CI |
| `secrets-management` | [wshobson/agents](https://github.com/wshobson/agents/tree/0874a27b17/plugins/cicd-automation/skills/secrets-management) | `0874a27b17` | MIT | reviewing how secrets are stored, rotated, and injected |
| `auth-implementation-patterns` | [wshobson/agents](https://github.com/wshobson/agents/tree/0874a27b17/plugins/developer-essentials/skills/auth-implementation-patterns) | `0874a27b17` | MIT | reviewing authentication and authorization design |
| `k8s-security-policies` | [wshobson/agents](https://github.com/wshobson/agents/tree/0874a27b17/plugins/kubernetes-operations/skills/k8s-security-policies) | `0874a27b17` | MIT | reviewing Kubernetes manifests and policies |
