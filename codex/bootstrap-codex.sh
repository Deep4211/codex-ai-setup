#!/usr/bin/env bash
#
# Install the Codex-native Vyapar AI setup.
#
# Default: install the repo-local plugin and its bundled skills/MCP servers.
# Use --skills-only for standalone skills (including Codex IDE extension use).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$SETUP_ROOT/.." && pwd)"
PLUGIN_NAME="vyapar-ai-toolkit"
GLOBAL_INSTALL=false
SKILLS_ONLY=false
STAGE_ONLY=false
CHECK_ONLY=false
REPLACE_LINKS=false

usage() {
  cat <<'USAGE'
Usage:
  bash _ai-setup/codex/bootstrap-codex.sh [options]

Options:
  --global          Install for the current user instead of this repository.
  --skills-only     Install the 36 standalone skills; do not install the plugin.
                    Use this mode for the Codex IDE extension.
  --stage-only      Copy the plugin and marketplace without running Codex CLI.
  --check           Validate the isolated Codex source tree without installing.
  --replace-links   Replace destination symlinks that would violate isolation.
  --help            Show this help.

Examples:
  bash _ai-setup/codex/bootstrap-codex.sh
  bash _ai-setup/codex/bootstrap-codex.sh --skills-only
  bash _ai-setup/codex/bootstrap-codex.sh --global
  bash _ai-setup/codex/bootstrap-codex.sh --check
USAGE
}

fail() {
  echo "Error: $*" >&2
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global)        GLOBAL_INSTALL=true ;;
    --skills-only)  SKILLS_ONLY=true ;;
    --stage-only)   STAGE_ONLY=true ;;
    --check)        CHECK_ONLY=true ;;
    --replace-links) REPLACE_LINKS=true ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      fail "unknown argument '$1'. Run with --help for usage."
      ;;
  esac
  shift
done

if $SKILLS_ONLY && $STAGE_ONLY; then
  fail "--skills-only and --stage-only cannot be combined."
fi

INVENTORY_FILE="$SCRIPT_DIR/inventory.json"
PLUGIN_SOURCE="$SCRIPT_DIR/plugins/$PLUGIN_NAME"
MARKETPLACE_SOURCE="$SCRIPT_DIR/.agents/plugins/marketplace.json"
AGENTS_TEMPLATE="$SCRIPT_DIR/AGENTS.template.md"

validate_source() {
  command -v node >/dev/null 2>&1 || fail "Node.js is required to validate manifests."

  [[ -f "$INVENTORY_FILE" ]] || fail "missing inventory: $INVENTORY_FILE"
  [[ -f "$PLUGIN_SOURCE/.codex-plugin/plugin.json" ]] || fail "missing plugin manifest"
  [[ -f "$PLUGIN_SOURCE/.mcp.json" ]] || fail "missing plugin MCP manifest"
  [[ -f "$MARKETPLACE_SOURCE" ]] || fail "missing marketplace manifest"
  [[ -f "$AGENTS_TEMPLATE" ]] || fail "missing AGENTS template"

  local linked_path
  linked_path="$(find "$SCRIPT_DIR" -type l -print -quit)"
  [[ -z "$linked_path" ]] || fail "Codex source must not contain symlinks: $linked_path"

  if command -v rg >/dev/null 2>&1; then
    if rg -n '\.claude/|CLAUDE\.md|~/.claude|\$HOME/.claude|common/\.claude' \
      "$PLUGIN_SOURCE" "$AGENTS_TEMPLATE" >/dev/null; then
      fail "Codex source contains a Claude filesystem/config reference."
    fi
  fi

  node - "$INVENTORY_FILE" "$PLUGIN_SOURCE" "$MARKETPLACE_SOURCE" <<'NODE'
const fs = require("fs");
const path = require("path");

const [inventoryPath, pluginRoot, marketplacePath] = process.argv.slice(2);
const inventory = JSON.parse(fs.readFileSync(inventoryPath, "utf8"));
const plugin = JSON.parse(
  fs.readFileSync(path.join(pluginRoot, ".codex-plugin", "plugin.json"), "utf8")
);
const mcpDocument = JSON.parse(
  fs.readFileSync(path.join(pluginRoot, ".mcp.json"), "utf8")
);
const marketplace = JSON.parse(fs.readFileSync(marketplacePath, "utf8"));

if (plugin.name !== inventory.plugin) {
  throw new Error(`plugin name mismatch: ${plugin.name} != ${inventory.plugin}`);
}
if (plugin.skills !== "./skills/" || plugin.mcpServers !== "./.mcp.json") {
  throw new Error("plugin manifest must point at ./skills/ and ./.mcp.json");
}

const skillRoot = path.join(pluginRoot, "skills");
const actualSkills = fs.readdirSync(skillRoot)
  .filter((name) => fs.statSync(path.join(skillRoot, name)).isDirectory())
  .sort();
const expectedSkills = [...inventory.skills].sort();
if (JSON.stringify(actualSkills) !== JSON.stringify(expectedSkills)) {
  throw new Error("skill inventory differs from the plugin skills directory");
}

for (const name of actualSkills) {
  const skillPath = path.join(skillRoot, name, "SKILL.md");
  if (!fs.existsSync(skillPath)) {
    throw new Error(`missing SKILL.md for ${name}`);
  }
  const text = fs.readFileSync(skillPath, "utf8");
  const frontmatter = text.match(/^---\s*\n([\s\S]*?)\n---\s*\n/);
  if (!frontmatter) {
    throw new Error(`invalid frontmatter for ${name}`);
  }
  const declaredName = frontmatter[1].match(/^name:\s*["']?([^"'\n]+)["']?\s*$/m);
  const description = frontmatter[1].match(/^description:\s*(.+)$/m);
  if (!declaredName || declaredName[1].trim() !== name) {
    throw new Error(`skill name must match its directory: ${name}`);
  }
  if (!description || !description[1].trim()) {
    throw new Error(`missing skill description: ${name}`);
  }
}

const mcpServers = mcpDocument.mcp_servers || mcpDocument.mcpServers || mcpDocument;
const actualServers = Object.keys(mcpServers).sort();
const expectedServers = [...inventory.mcpServers].sort();
if (JSON.stringify(actualServers) !== JSON.stringify(expectedServers)) {
  throw new Error("MCP inventory differs from .mcp.json");
}

const entry = marketplace.plugins.find((item) => item.name === inventory.plugin);
if (!entry || entry.source?.path !== `./plugins/${inventory.plugin}`) {
  throw new Error("marketplace does not point at the bundled plugin");
}
NODE

  echo "✓ Codex source validated: 1 plugin, 36 skills, 4 MCP servers, 0 symlinks"
}

prepare_directory() {
  local destination="$1"
  if [[ -L "$destination" ]]; then
    if ! $REPLACE_LINKS; then
      fail "destination is a symlink: $destination (rerun with --replace-links)"
    fi
    unlink "$destination"
  elif [[ -e "$destination" && ! -d "$destination" ]]; then
    fail "destination exists and is not a directory: $destination"
  fi
  mkdir -p "$destination"
}

copy_tree() {
  local source="$1"
  local destination="$2"
  prepare_directory "$destination"
  cp -R "$source/." "$destination/"
}

merge_marketplace() {
  local source="$1"
  local destination="$2"
  prepare_directory "$(dirname "$destination")"
  if [[ -L "$destination" ]]; then
    if ! $REPLACE_LINKS; then
      fail "marketplace is a symlink: $destination (rerun with --replace-links)"
    fi
    unlink "$destination"
  fi

  node - "$source" "$destination" <<'NODE'
const fs = require("fs");
const path = require("path");
const [sourcePath, destinationPath] = process.argv.slice(2);
const incoming = JSON.parse(fs.readFileSync(sourcePath, "utf8"));
let output = incoming;

if (fs.existsSync(destinationPath)) {
  output = JSON.parse(fs.readFileSync(destinationPath, "utf8"));
  output.plugins = Array.isArray(output.plugins) ? output.plugins : [];
  const incomingEntry = incoming.plugins[0];
  const index = output.plugins.findIndex((item) => item.name === incomingEntry.name);
  if (index >= 0) output.plugins[index] = incomingEntry;
  else output.plugins.push(incomingEntry);
  output.interface = output.interface || incoming.interface;
}

fs.mkdirSync(path.dirname(destinationPath), { recursive: true });
fs.writeFileSync(destinationPath, JSON.stringify(output, null, 2) + "\n");
process.stdout.write(output.name);
NODE
}

seed_agents_file() {
  local destination="$1"
  prepare_directory "$(dirname "$destination")"
  if [[ -L "$destination" ]]; then
    if ! $REPLACE_LINKS; then
      fail "AGENTS file is a symlink: $destination (rerun with --replace-links)"
    fi
    unlink "$destination"
  fi
  if [[ ! -e "$destination" ]]; then
    cp "$AGENTS_TEMPLATE" "$destination"
    echo "→ Created $destination"
  else
    echo "  ($destination already exists — preserved)"
  fi
}

install_standalone_skills() {
  local target_root="$1"
  prepare_directory "$target_root"
  local source_dir skill_name
  for source_dir in "$PLUGIN_SOURCE"/skills/*; do
    [[ -d "$source_dir" ]] || continue
    skill_name="$(basename "$source_dir")"
    copy_tree "$source_dir" "$target_root/$skill_name"
  done
  echo "→ Installed 36 standalone skills into $target_root"
}

validate_source
if $CHECK_ONLY; then
  exit 0
fi

if $GLOBAL_INSTALL; then
  INSTALL_ROOT="$HOME"
  CODEX_STATE_ROOT="${CODEX_HOME:-$HOME/.codex}"
  TARGET_SKILLS_ROOT="$HOME/.agents/skills"
  TARGET_PLUGIN_ROOT="$HOME/plugins/$PLUGIN_NAME"
  TARGET_MARKETPLACE="$HOME/.agents/plugins/marketplace.json"
  TARGET_AGENTS="$CODEX_STATE_ROOT/AGENTS.md"
  SCOPE_LABEL="global"
else
  INSTALL_ROOT="$REPO_ROOT"
  TARGET_SKILLS_ROOT="$REPO_ROOT/.agents/skills"
  TARGET_PLUGIN_ROOT="$REPO_ROOT/plugins/$PLUGIN_NAME"
  TARGET_MARKETPLACE="$REPO_ROOT/.agents/plugins/marketplace.json"
  TARGET_AGENTS="$REPO_ROOT/AGENTS.md"
  SCOPE_LABEL="repo-local"
fi

echo ""
echo "Vyapar Codex Setup"
echo "  Scope : $SCOPE_LABEL"
echo "  Source: $SCRIPT_DIR"
echo ""

seed_agents_file "$TARGET_AGENTS"

if $SKILLS_ONLY; then
  install_standalone_skills "$TARGET_SKILLS_ROOT"
  echo ""
  echo "✓ Codex standalone-skill installation complete."
  echo "  Restart Codex if the skills do not appear immediately."
  exit 0
fi

copy_tree "$PLUGIN_SOURCE" "$TARGET_PLUGIN_ROOT"
MARKETPLACE_NAME="$(merge_marketplace "$MARKETPLACE_SOURCE" "$TARGET_MARKETPLACE")"
echo "→ Copied plugin to $TARGET_PLUGIN_ROOT"
echo "→ Updated marketplace at $TARGET_MARKETPLACE"

if $STAGE_ONLY; then
  echo ""
  echo "✓ Codex plugin staged without changing installed plugin state."
  exit 0
fi

command -v codex >/dev/null 2>&1 || \
  fail "Codex CLI is not available. Rerun with --stage-only or install Codex CLI."

if ! $GLOBAL_INSTALL; then
  echo "→ Registering repo marketplace root $INSTALL_ROOT"
  codex plugin marketplace add "$INSTALL_ROOT" --json
fi

echo "→ Installing $PLUGIN_NAME from marketplace $MARKETPLACE_NAME"
(
  cd "$INSTALL_ROOT"
  codex plugin add "$PLUGIN_NAME@$MARKETPLACE_NAME" --json
)

echo ""
echo "✓ Codex plugin installation complete."
echo "  Start a new Codex session to load the bundled skills and MCP tools."
echo "  Ruflo is enabled; MySQL, MongoDB, and AWS MCP remain disabled by default."
