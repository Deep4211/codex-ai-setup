# Codex AI Setup

Standalone, Codex-native AI

This repository is intentionally independent from Claude configuration. It contains its own Codex plugin, marketplace, skills, MCP definitions, installer, inventory, and `AGENTS.md` template.

## Add to another repository

Add this repository as `_ai-setup`, then run the installer:

```bash
git submodule add <github-repository-url> _ai-setup
git submodule update --init
bash _ai-setup/codex/bootstrap-codex.sh
```

For standalone skills used by the Codex IDE extension:

```bash
bash _ai-setup/codex/bootstrap-codex.sh --skills-only
```

Validate without installing:

```bash
bash _ai-setup/codex/bootstrap-codex.sh --check
```

See [`codex/README.md`](codex/README.md) for installation modes, included skills, optional MCP servers, and the isolation contract.
