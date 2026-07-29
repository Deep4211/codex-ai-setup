# Vyapar AI Setup for Codex

This is a Codex-native installation kept independent from the Claude setup in the same repository.

The Codex tree contains its own plugin manifest, skill copies, MCP configuration, marketplace, installer, inventory, and `AGENTS.md` template. Installation never symlinks or reads Claude configuration.

## Install

From a consumer repository:

```bash
# Recommended: install the repo-local Codex plugin
bash _ai-setup/codex/bootstrap-codex.sh

# Standalone skills for the Codex IDE extension
bash _ai-setup/codex/bootstrap-codex.sh --skills-only

# Install for the current user
bash _ai-setup/codex/bootstrap-codex.sh --global
```

The default installation:

1. Validates the isolated Codex source.
2. Seeds `AGENTS.md` only when it does not exist.
3. Copies the plugin into `plugins/vyapar-ai-toolkit/`.
4. Merges its entry into `.agents/plugins/marketplace.json`.
5. Registers the repo marketplace with Codex.
6. Installs and enables `vyapar-ai-toolkit`.

Start a new Codex session after installation.

Do not combine the normal plugin installation with `--skills-only` in the same scope. Both contain the same workflows and Codex would show duplicate skill names.

## Other modes

```bash
# Validate manifests, inventory, metadata, isolation, and symlinks
bash _ai-setup/codex/bootstrap-codex.sh --check

# Copy the plugin and marketplace without changing installed plugin state
bash _ai-setup/codex/bootstrap-codex.sh --stage-only

# Replace a destination symlink instead of stopping
bash _ai-setup/codex/bootstrap-codex.sh --replace-links
```

The installer is idempotent. Existing `AGENTS.md` content is preserved. Existing marketplace entries are preserved, while the `vyapar-ai-toolkit` entry is updated.

## Included capabilities

The `vyapar-ai-toolkit` plugin contains:

- 36 Codex skills covering codebase exploration, debugging, reviews, refactoring, GitHub/GitLab workflows, AgentDB, Ruflo, SPARC, releases, pair programming, and verification.
- Ruflo MCP, enabled by default.
- MySQL, MongoDB, and AWS MCP definitions, disabled by default.

The authoritative list is [`inventory.json`](inventory.json). The installer fails validation if the plugin no longer matches it.

## Enable optional MCP servers

Configure credentials in the local environment first:

- MySQL: `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASS`, `MYSQL_DB`
- MongoDB: `MDB_MCP_CONNECTION_STRING`
- AWS: configured AWS CLI credentials; region defaults to `ap-south-1`

Then enable only the required server in Codex config:

```toml
[plugins."vyapar-ai-toolkit@vyapar-ai-setup".mcp_servers.mysql]
enabled = true

[plugins."vyapar-ai-toolkit@vyapar-ai-setup".mcp_servers.mongodb]
enabled = true

[plugins."vyapar-ai-toolkit@vyapar-ai-setup".mcp_servers.aws-mcp]
enabled = true
```

Keep credentials out of `config.toml`, plugin files, and the repository.

## Isolation contract

Codex installation uses only:

- `AGENTS.md`
- `.agents/skills/`
- `.agents/plugins/marketplace.json`
- `plugins/vyapar-ai-toolkit/`
- Codex’s own user state and plugin cache

It does not read, write, import, or symlink:

- Claude settings, commands, agents, helpers, skills, or hooks
- Claude instruction or memory files
- Claude MCP configuration or caches

References to Ruflo’s historical Claude Flow product name can remain inside workflow documentation because they identify the upstream package or project. They are not installation paths or shared state.

## Maintain the Codex setup

Treat `codex/` as an independent source tree. Do not symlink its skills back to another client’s directories and do not generate them during installation from another client’s files.

When adding or removing a Codex skill:

1. Update `plugins/vyapar-ai-toolkit/skills/<skill-name>/SKILL.md`.
2. Update `inventory.json`.
3. Run `bash _ai-setup/codex/bootstrap-codex.sh --check`.
4. Run the Codex skill and plugin validators.
5. Reinstall the plugin and test from a new Codex session.
