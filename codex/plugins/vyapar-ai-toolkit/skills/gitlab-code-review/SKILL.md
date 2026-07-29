---
name: gitlab-code-review
description: Comprehensive GitLab code review with AI-powered swarm coordination
---

# GitLab Code Review Skill

> **AI-Powered Code Review**: Deploy specialized review agents to perform comprehensive, intelligent code reviews that go beyond traditional static analysis.

## 🎯 Quick Start

### Simple Review
```bash
# Initialize review swarm for MR
glab mr view 123 --json | npx ruv-swarm gitlab review-init --mr 123

# Post review status
glab mr note 123 --message "🔍 Multi-agent code review initiated"
```

### Complete Review Workflow
```bash
# Get MR context with glab CLI
MR_DATA=$(glab mr view 123 --json)
MR_DIFF=$(glab mr diff 123)

# Initialize comprehensive review
npx ruv-swarm gitlab review-init \
  --mr 123 \
  --mr-data "$MR_DATA" \
  --diff "$MR_DIFF" \
  --agents "security,performance,style,architecture,accessibility" \
  --depth comprehensive
```

---

## 📚 Table of Contents

<details>
<summary><strong>Core Features</strong></summary>

- [Multi-Agent Review System](#multi-agent-review-system)
- [Specialized Review Agents](#specialized-review-agents)
- [MR-Based Swarm Management](#mr-based-swarm-management)
- [Automated Workflows](#automated-workflows)
- [Quality Gates & Checks](#quality-gates--checks)

</details>

<details>
<summary><strong>Review Agents</strong></summary>

- [Security Review Agent](#security-review-agent)
- [Performance Review Agent](#performance-review-agent)
- [Architecture Review Agent](#architecture-review-agent)
- [Style & Convention Agent](#style--convention-agent)
- [Accessibility Agent](#accessibility-agent)

</details>

<details>
<summary><strong>Advanced Features</strong></summary>

- [Context-Aware Reviews](#context-aware-reviews)
- [Learning from History](#learning-from-history)
- [Cross-MR Analysis](#cross-mr-analysis)
- [Custom Review Agents](#custom-review-agents)

</details>

<details>
<summary><strong>Integration & Automation</strong></summary>

- [CI/CD Integration](#cicd-integration)
- [Webhook Handlers](#webhook-handlers)
- [MR Comment Commands](#mr-comment-commands)
- [Automated Fixes](#automated-fixes)

</details>

---

## 🚀 Core Features

### Multi-Agent Review System

Deploy specialized AI agents for comprehensive code review:

```bash
# Initialize review swarm with GitLab CLI integration
MR_DATA=$(glab mr view 123 --json)
MR_DIFF=$(glab mr diff 123)

# Start multi-agent review
npx ruv-swarm gitlab review-init \
  --mr 123 \
  --mr-data "$MR_DATA" \
  --diff "$MR_DIFF" \
  --agents "security,performance,style,architecture,accessibility" \
  --depth comprehensive

# Post initial review status
glab mr note 123 --message "🔍 Multi-agent code review initiated"
```

**Benefits:**
- ✅ Parallel review by specialized agents
- ✅ Comprehensive coverage across multiple domains
- ✅ Faster review cycles with coordinated analysis
- ✅ Consistent quality standards enforcement

---

## 🤖 Specialized Review Agents

### Security Review Agent

**Focus:** Identify security vulnerabilities and suggest fixes

```bash
# Get changed files from MR
CHANGED_FILES=$(glab mr view 123 --json | jq -r '.changes[].new_path')

# Run security-focused review
SECURITY_RESULTS=$(npx ruv-swarm gitlab review-security \
  --mr 123 \
  --files "$CHANGED_FILES" \
  --check "owasp,cve,secrets,permissions" \
  --suggest-fixes)

# Post findings based on severity
if echo "$SECURITY_RESULTS" | grep -q "critical"; then
  # Request changes for critical issues (mark MR as WIP/Draft)
  glab mr update 123 --wip
  glab mr note 123 --message "$SECURITY_RESULTS"
  glab mr update 123 --label "security-review-required"
else
  # Post as comment for non-critical issues
  glab mr note 123 --message "$SECURITY_RESULTS"
fi
```

<details>
<summary><strong>Security Checks Performed</strong></summary>

```javascript
{
  "checks": [
    "SQL injection vulnerabilities",
    "XSS attack vectors",
    "Authentication bypasses",
    "Authorization flaws",
    "Cryptographic weaknesses",
    "Dependency vulnerabilities",
    "Secret exposure",
    "CORS misconfigurations"
  ],
  "actions": [
    "Block MR on critical issues",
    "Suggest secure alternatives",
    "Add security test cases",
    "Update security documentation"
  ]
}
```

</details>

<details>
<summary><strong>Comment Template: Security Issue</strong></summary>

```markdown
🔒 **Security Issue: [Type]**

**Severity**: 🔴 Critical / 🟡 High / 🟢 Low

**Description**:
[Clear explanation of the security issue]

**Impact**:
[Potential consequences if not addressed]

**Suggested Fix**:
```language
[Code example of the fix]
```

**References**:
- [OWASP Guide](link)
- [Security Best Practices](link)
```

</details>

---

### Performance Review Agent

**Focus:** Analyze performance impact and optimization opportunities

```bash
# Run performance analysis
npx ruv-swarm gitlab review-performance \
  --mr 123 \
  --profile "cpu,memory,io" \
  --benchmark-against main \
  --suggest-optimizations
```

<details>
<summary><strong>Performance Metrics Analyzed</strong></summary>

```javascript
{
  "metrics": [
    "Algorithm complexity (Big O analysis)",
    "Database query efficiency",
    "Memory allocation patterns",
    "Cache utilization",
    "Network request optimization",
    "Bundle size impact",
    "Render performance"
  ],
  "benchmarks": [
    "Compare with baseline",
    "Load test simulations",
    "Memory leak detection",
    "Bottleneck identification"
  ]
}
```

</details>

---

### Architecture Review Agent

**Focus:** Evaluate design patterns and architectural decisions

```bash
# Architecture review
npx ruv-swarm gitlab review-architecture \
  --mr 123 \
  --check "patterns,coupling,cohesion,solid" \
  --visualize-impact \
  --suggest-refactoring
```

<details>
<summary><strong>Architecture Analysis</strong></summary>

```javascript
{
  "patterns": [
    "Design pattern adherence",
    "SOLID principles",
    "DRY violations",
    "Separation of concerns",
    "Dependency injection",
    "Layer violations",
    "Circular dependencies"
  ],
  "metrics": [
    "Coupling metrics",
    "Cohesion scores",
    "Complexity measures",
    "Maintainability index"
  ]
}
```

</details>

---

### Style & Convention Agent

**Focus:** Enforce coding standards and best practices

```bash
# Style enforcement with auto-fix
npx ruv-swarm gitlab review-style \
  --mr 123 \
  --check "formatting,naming,docs,tests" \
  --auto-fix "formatting,imports,whitespace"
```

<details>
<summary><strong>Style Checks</strong></summary>

```javascript
{
  "checks": [
    "Code formatting",
    "Naming conventions",
    "Documentation standards",
    "Comment quality",
    "Test coverage",
    "Error handling patterns",
    "Logging standards"
  ],
  "auto-fix": [
    "Formatting issues",
    "Import organization",
    "Trailing whitespace",
    "Simple naming issues"
  ]
}
```

</details>

---

## 🔄 MR-Based Swarm Management

### Create Swarm from MR

```bash
# Create swarm from MR description using glab CLI
glab mr view 123 --json | npx ruv-swarm swarm create-from-mr

# Auto-spawn agents based on MR labels
glab mr view 123 --json | npx ruv-swarm swarm auto-spawn

# Create swarm with full MR context
glab mr view 123 --json | \
  npx ruv-swarm swarm init --from-mr-data
```

### Label-Based Agent Assignment

Map MR labels to specialized agents:

```json
{
  "label-mapping": {
    "bug": ["debugger", "tester"],
    "feature": ["architect", "coder", "tester"],
    "refactor": ["analyst", "coder"],
    "docs": ["researcher", "writer"],
    "performance": ["analyst", "optimizer"],
    "security": ["security", "authentication", "audit"]
  }
}
```

### Topology Selection by MR Size

```bash
# Automatic topology selection based on MR complexity
# Small MR (< 100 lines): ring topology
# Medium MR (100-500 lines): mesh topology
# Large MR (> 500 lines): hierarchical topology
npx ruv-swarm gitlab mr-topology --mr 123
```

---

## 🎬 MR Comment Commands

Execute swarm commands directly from MR comments:

```markdown
<!-- In MR comment -->
/swarm init mesh 6
/swarm spawn coder "Implement authentication"
/swarm spawn tester "Write unit tests"
/swarm status
/swarm review --agents security,performance
```

<details>
<summary><strong>Webhook Handler for Comment Commands</strong></summary>

```javascript
// webhook-handler.js
const { createServer } = require('http');
const { execSync } = require('child_process');

createServer((req, res) => {
  if (req.url === '/gitlab-webhook') {
    const event = JSON.parse(body);

    // MR opened event
    if (event.object_kind === 'merge_request' && event.object_attributes.action === 'open') {
      execSync(`npx ruv-swarm gitlab mr-init ${event.object_attributes.iid}`);
    }

    // Note (comment) event
    if (event.object_kind === 'note' && event.object_attributes.note.startsWith('/swarm')) {
      const command = event.object_attributes.note;
      const mrIid = event.merge_request.iid;
      execSync(`npx ruv-swarm gitlab handle-comment --mr ${mrIid} --command "${command}"`);
    }

    res.writeHead(200);
    res.end('OK');
  }
}).listen(3000);
```

</details>

---

## ⚙️ Review Configuration

### Configuration File

```yaml
# .gitlab/review-swarm.yml
version: 1
review:
  auto-trigger: true
  required-agents:
    - security
    - performance
    - style
  optional-agents:
    - architecture
    - accessibility
    - i18n

  thresholds:
    security: block      # Block merge on security issues
    performance: warn    # Warn on performance issues
    style: suggest       # Suggest style improvements

  rules:
    security:
      - no-eval
      - no-hardcoded-secrets
      - proper-auth-checks
      - validate-input
    performance:
      - no-n-plus-one
      - efficient-queries
      - proper-caching
      - optimize-loops
    architecture:
      - max-coupling: 5
      - min-cohesion: 0.7
      - follow-patterns
      - avoid-circular-deps
```

### Custom Review Triggers

```javascript
{
  "triggers": {
    "high-risk-files": {
      "paths": ["**/auth/**", "**/payment/**", "**/admin/**"],
      "agents": ["security", "architecture"],
      "depth": "comprehensive",
      "require-approval": true
    },
    "performance-critical": {
      "paths": ["**/api/**", "**/database/**", "**/cache/**"],
      "agents": ["performance", "database"],
      "benchmarks": true,
      "regression-threshold": "5%"
    },
    "ui-changes": {
      "paths": ["**/components/**", "**/styles/**", "**/pages/**"],
      "agents": ["accessibility", "style", "i18n"],
      "visual-tests": true,
      "responsive-check": true
    }
  }
}
```

---

## 🤖 Automated Workflows

### Auto-Review on MR Creation

```yaml
# .gitlab-ci.yml
stages:
  - review

swarm-review:
  stage: review
  image: node:20
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
  script:
    - npm install -g @gitlab/cli ruv-swarm
    - |
      MR_IID=$CI_MERGE_REQUEST_IID
      MR_DATA=$(glab mr view $MR_IID --json)
      MR_DIFF=$(glab mr diff $MR_IID)

      # Run swarm review
      REVIEW_OUTPUT=$(npx ruv-swarm gitlab review-all \
        --mr $MR_IID \
        --mr-data "$MR_DATA" \
        --diff "$MR_DIFF" \
        --agents "security,performance,style,architecture")

      # Post review results as MR note
      glab mr note $MR_IID --message "$REVIEW_OUTPUT"

      # Approve or mark WIP based on results
      if echo "$REVIEW_OUTPUT" | grep -q "approved"; then
        glab mr approve $MR_IID
      elif echo "$REVIEW_OUTPUT" | grep -q "changes-requested"; then
        glab mr update $MR_IID --wip
        glab mr note $MR_IID --message "Changes requested — see review comments above"
      fi

update-labels:
  stage: review
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
  script:
    - |
      # Add labels based on review results
      if echo "$REVIEW_OUTPUT" | grep -q "security"; then
        glab mr update $CI_MERGE_REQUEST_IID --label "security-review"
      fi
      if echo "$REVIEW_OUTPUT" | grep -q "performance"; then
        glab mr update $CI_MERGE_REQUEST_IID --label "performance-review"
      fi
```

---

## 💬 Intelligent Comment Generation

### Generate Contextual Review Comments

```bash
# Get MR diff with context
MR_DIFF=$(glab mr diff 123)
MR_DATA=$(glab mr view 123 --json)

# Generate review comments
COMMENTS=$(npx ruv-swarm gitlab review-comment \
  --mr 123 \
  --diff "$MR_DIFF" \
  --mr-data "$MR_DATA" \
  --style "constructive" \
  --include-examples \
  --suggest-fixes)

# Post inline diff comments via GitLab REST API
PROJECT_ID="your-namespace%2Fyour-project"
MR_IID=123
HEAD_SHA=$(glab mr view 123 --json | jq -r '.sha')

echo "$COMMENTS" | jq -c '.[]' | while read -r comment; do
  FILE=$(echo "$comment" | jq -r '.path')
  LINE=$(echo "$comment" | jq -r '.line')
  BODY=$(echo "$comment" | jq -r '.body')

  # Create inline discussion on MR diff
  curl --request POST \
    --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
    --header "Content-Type: application/json" \
    --data "{
      \"body\": \"$BODY\",
      \"position\": {
        \"position_type\": \"text\",
        \"base_sha\": \"$HEAD_SHA\",
        \"head_sha\": \"$HEAD_SHA\",
        \"start_sha\": \"$HEAD_SHA\",
        \"new_path\": \"$FILE\",
        \"new_line\": $LINE
      }
    }" \
    "https://gitlab.com/api/v4/projects/${PROJECT_ID}/merge_requests/${MR_IID}/discussions"
done
```

### Batch Comment Management

```bash
# Manage review comments efficiently
npx ruv-swarm gitlab review-comments \
  --mr 123 \
  --group-by "agent,severity" \
  --summarize \
  --resolve-outdated
```

---

## 🚪 Quality Gates & Checks

### MR Approval Rules

```yaml
# GitLab project-level approval rules (set via UI or API)
# Equivalent of GitHub's required_status_checks — enforced via merge request approval rules:
# - review-swarm/security: 1 required approval
# - review-swarm/performance: 1 required approval
# - review-swarm/architecture: 1 required approval
# - review-swarm/tests: 1 required approval

# Configure via GitLab API:
curl --request POST \
  --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  --data "name=review-swarm/security&approvals_required=1" \
  "https://gitlab.com/api/v4/projects/${PROJECT_ID}/approval_rules"
```

### Define Quality Gates

```bash
# Set quality gate thresholds
npx ruv-swarm gitlab quality-gates \
  --define '{
    "security": {"threshold": "no-critical"},
    "performance": {"regression": "<5%"},
    "coverage": {"minimum": "80%"},
    "architecture": {"complexity": "<10"},
    "duplication": {"maximum": "5%"}
  }'
```

### Track Review Metrics

```bash
# Monitor review effectiveness
npx ruv-swarm gitlab review-metrics \
  --period 30d \
  --metrics "issues-found,false-positives,fix-rate,time-to-review" \
  --export-dashboard \
  --format json
```

---

## 🎓 Advanced Features

### Context-Aware Reviews

Analyze MRs with full project context:

```bash
# Review with comprehensive context
npx ruv-swarm gitlab review-context \
  --mr 123 \
  --load-related-mrs \
  --analyze-impact \
  --check-breaking-changes \
  --dependency-analysis
```

### Learning from History

Train review agents on your codebase patterns:

```bash
# Learn from past reviews
npx ruv-swarm gitlab review-learn \
  --analyze-past-reviews \
  --identify-patterns \
  --improve-suggestions \
  --reduce-false-positives

# Train on your codebase
npx ruv-swarm gitlab review-train \
  --learn-patterns \
  --adapt-to-style \
  --improve-accuracy
```

### Cross-MR Analysis

Coordinate reviews across related merge requests:

```bash
# Analyze related MRs together
npx ruv-swarm gitlab review-batch \
  --mrs "123,124,125" \
  --check-consistency \
  --verify-integration \
  --combined-impact
```

### Multi-MR Swarm Coordination

```bash
# Coordinate swarms across related MRs
npx ruv-swarm gitlab multi-mr \
  --mrs "123,124,125" \
  --strategy "parallel" \
  --share-memory
```

---

## 🛠️ Custom Review Agents

### Create Custom Agent

```javascript
// custom-review-agent.js
class CustomReviewAgent {
  constructor(config) {
    this.config = config;
    this.rules = config.rules || [];
  }

  async review(mr) {
    const issues = [];

    // Custom logic: Check for TODO comments in production code
    if (await this.checkTodoComments(mr)) {
      issues.push({
        severity: 'warning',
        file: mr.file,
        line: mr.line,
        message: 'TODO comment found in production code',
        suggestion: 'Resolve TODO or create issue to track it'
      });
    }

    // Custom logic: Verify API versioning
    if (await this.checkApiVersioning(mr)) {
      issues.push({
        severity: 'error',
        file: mr.file,
        line: mr.line,
        message: 'API endpoint missing versioning',
        suggestion: 'Add /v1/, /v2/ prefix to API routes'
      });
    }

    return issues;
  }

  async checkTodoComments(mr) {
    const todoRegex = /\/\/\s*TODO|\/\*\s*TODO/gi;
    return todoRegex.test(mr.diff);
  }

  async checkApiVersioning(mr) {
    const apiRegex = /app\.(get|post|put|delete)\(['"]\/api\/(?!v\d+)/;
    return apiRegex.test(mr.diff);
  }
}

module.exports = CustomReviewAgent;
```

### Register Custom Agent

```bash
# Register custom review agent
npx ruv-swarm gitlab register-agent \
  --name "custom-reviewer" \
  --file "./custom-review-agent.js" \
  --category "standards"
```

---

## 🔧 CI/CD Integration

### Integration with Build Pipeline

```yaml
# .gitlab-ci.yml
stages:
  - build
  - test
  - review

build-and-test:
  stage: build
  script:
    - npm install
    - npm test
    - npm run build

swarm-review:
  stage: review
  needs: [build-and-test]
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
  script:
    - npx ruv-swarm gitlab review-all \
        --mr $CI_MERGE_REQUEST_IID \
        --include-build-results
```

### Automated MR Fixes

```bash
# Auto-fix common issues
npx ruv-swarm gitlab mr-fix 123 \
  --issues "lint,test-failures,formatting" \
  --commit-fixes \
  --push-changes
```

### Progress Updates to MR

```bash
# Post swarm progress to MR using glab CLI
PROGRESS=$(npx ruv-swarm gitlab mr-progress 123 --format markdown)

glab mr note 123 --message "$PROGRESS"

# Update MR labels based on progress
if [[ $(echo "$PROGRESS" | grep -o '[0-9]\+%' | sed 's/%//') -gt 90 ]]; then
  glab mr update 123 --label "ready-for-review"
fi
```

---

## 📋 Complete Workflow Examples

### Example 1: Security-Critical MR

```bash
# Review authentication system changes
npx ruv-swarm gitlab review-init \
  --mr 456 \
  --agents "security,authentication,audit" \
  --depth "maximum" \
  --require-security-approval \
  --penetration-test
```

### Example 2: Performance-Sensitive MR

```bash
# Review database optimization
npx ruv-swarm gitlab review-init \
  --mr 789 \
  --agents "performance,database,caching" \
  --benchmark \
  --profile \
  --load-test
```

### Example 3: UI Component MR

```bash
# Review new component library
npx ruv-swarm gitlab review-init \
  --mr 321 \
  --agents "accessibility,style,i18n,docs" \
  --visual-regression \
  --component-tests \
  --responsive-check
```

### Example 4: Feature Development MR

```bash
# Review new feature implementation
glab mr view 456 --json | \
  npx ruv-swarm gitlab mr-init 456 \
    --topology hierarchical \
    --agents "architect,coder,tester,security" \
    --auto-assign-tasks
```

### Example 5: Bug Fix MR

```bash
# Review bug fix with debugging focus
npx ruv-swarm gitlab mr-init 789 \
  --topology mesh \
  --agents "debugger,analyst,tester" \
  --priority high \
  --regression-test
```

---

## 📊 Monitoring & Analytics

### Review Dashboard

```bash
# Launch real-time review dashboard
npx ruv-swarm gitlab review-dashboard \
  --real-time \
  --show "agent-activity,issue-trends,fix-rates,coverage"
```

### Generate Review Reports

```bash
# Create comprehensive review report
npx ruv-swarm gitlab review-report \
  --format "markdown" \
  --include "summary,details,trends,recommendations" \
  --email-stakeholders \
  --export-pdf
```

### MR Swarm Analytics

```bash
# Generate MR-specific analytics
npx ruv-swarm gitlab mr-report 123 \
  --metrics "completion-time,agent-efficiency,token-usage,issue-density" \
  --format markdown \
  --compare-baseline
```

### Export to GitLab Insights

```bash
# Export metrics to GitLab Insights
npx ruv-swarm gitlab export-metrics \
  --mr 123 \
  --to-insights \
  --dashboard-url
```

---

## 🔐 Security Considerations

### Best Practices

1. **Token Permissions**: Ensure GitLab tokens have minimal required scopes (`api`, `read_repository`)
2. **Command Validation**: Validate all MR comments before execution
3. **Rate Limiting**: Implement rate limits for MR operations
4. **Audit Trail**: Log all swarm operations for compliance
5. **Secret Management**: Never expose API keys in MR comments or logs

### Security Checklist

- [ ] GitLab token scoped to project only
- [ ] Webhook secret token verified (`X-Gitlab-Token` header)
- [ ] Command injection protection enabled
- [ ] Rate limiting configured
- [ ] Audit logging enabled
- [ ] Secrets scanning active (GitLab Secret Detection enabled)
- [ ] Protected branch merge request approval rules enforced

---

## 📚 Best Practices

### 1. Review Configuration
- ✅ Define clear review criteria upfront
- ✅ Set appropriate severity thresholds
- ✅ Configure agent specializations for your stack
- ✅ Establish override procedures for emergencies

### 2. Comment Quality
- ✅ Provide actionable, specific feedback
- ✅ Include code examples with suggestions
- ✅ Reference documentation and best practices
- ✅ Maintain respectful, constructive tone

### 3. Performance Optimization
- ✅ Cache analysis results to avoid redundant work
- ✅ Use incremental reviews for large MRs
- ✅ Enable parallel agent execution
- ✅ Batch comment operations efficiently

### 4. MR Templates

```markdown
<!-- .gitlab/merge_request_templates/default.md -->
## Swarm Configuration
- Topology: [mesh/hierarchical/ring/star]
- Max Agents: [number]
- Auto-spawn: [yes/no]
- Priority: [high/medium/low]

## Tasks for Swarm
- [ ] Task 1 description
- [ ] Task 2 description
- [ ] Task 3 description

## Review Focus Areas
- [ ] Security review
- [ ] Performance analysis
- [ ] Architecture validation
- [ ] Accessibility check
```

### 5. Auto-Merge When Ready

```bash
# Auto-merge when swarm completes and passes checks
SWARM_STATUS=$(npx ruv-swarm gitlab mr-status 123)

if [[ "$SWARM_STATUS" == "complete" ]]; then
  # Check approval requirements
  APPROVALS=$(glab mr view 123 --json | jq '.approvals_left')

  if [[ $APPROVALS -eq 0 ]]; then
    # Merge with squash
    glab mr merge 123 --squash
  fi
fi
```

---

## 🔗 Integration with Codex

### Workflow Pattern

1. **Codex** reads MR diff and context
2. **Swarm** coordinates review approach based on MR type
3. **Agents** work in parallel on different review aspects
4. **Progress** updates posted to MR automatically
5. **Final review** performed before marking ready

### Example: Complete MR Management

```javascript
[Single Message - Parallel Execution]:
  // Initialize coordination
  mcp__ruflo__swarm_init { topology: "hierarchical", maxAgents: 5 }
  mcp__ruflo__agent_spawn { type: "reviewer", name: "Senior Reviewer" }
  mcp__ruflo__agent_spawn { type: "tester", name: "QA Engineer" }
  mcp__ruflo__agent_spawn { type: "coordinator", name: "Merge Coordinator" }

  // Create and manage MR using glab CLI
  Bash("glab mr create --title 'Feature: Add authentication' --target-branch main")
  Bash("glab mr view 54 --json")
  Bash("glab mr approve 54")
  Bash("glab mr note 54 --message 'LGTM after automated review'")

  // Execute tests and validation
  Bash("npm test")
  Bash("npm run lint")
  Bash("npm run build")

  // Track progress
  TodoWrite { todos: [
    { content: "Complete code review", status: "completed", activeForm: "Completing code review" },
    { content: "Run test suite", status: "completed", activeForm: "Running test suite" },
    { content: "Validate security", status: "completed", activeForm: "Validating security" },
    { content: "Merge when ready", status: "pending", activeForm: "Merging when ready" }
  ]}
```

---

## 🆘 Troubleshooting

### Common Issues

<details>
<summary><strong>Issue: Review agents not spawning</strong></summary>

**Solution:**
```bash
# Check swarm status
npx ruv-swarm swarm-status

# Verify GitLab CLI authentication
glab auth status

# Re-initialize swarm
npx ruv-swarm gitlab review-init --mr 123 --force
```

</details>

<details>
<summary><strong>Issue: Comments not posting to MR</strong></summary>

**Solution:**
```bash
# Verify GitLab token permissions
glab auth status

# Check API rate limit (inspect response headers)
curl -I --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "https://gitlab.com/api/v4/projects/${PROJECT_ID}/merge_requests/123"
# Look for: RateLimit-Remaining, RateLimit-Reset headers

# Use batch comment posting
npx ruv-swarm gitlab review-comments --mr 123 --batch
```

</details>

<details>
<summary><strong>Issue: Review taking too long</strong></summary>

**Solution:**
```bash
# Use incremental review for large MRs
npx ruv-swarm gitlab review-init --mr 123 --incremental

# Reduce agent count
npx ruv-swarm gitlab review-init --mr 123 --agents "security,style" --max-agents 3

# Enable parallel processing
npx ruv-swarm gitlab review-init --mr 123 --parallel --cache-results
```

</details>

---

## 📖 Additional Resources

### Related Skills
- `gitlab-mr-manager` - Comprehensive MR lifecycle management
- `gitlab-workflow-automation` - Automate GitLab CI/CD workflows
- `swarm-coordination` - Advanced swarm orchestration

### Documentation
- [GitLab CLI Documentation](https://gitlab.com/gitlab-org/cli)
- [GitLab REST API](https://docs.gitlab.com/ee/api/rest/)
- [RUV Swarm Guide](https://github.com/ruvnet/ruv-swarm)
- [Claude Flow Integration](https://github.com/ruvnet/claude-flow)

### Support
- GitLab Issues: Report bugs and request features
- Community: Join discussions and share experiences
- Examples: Browse example configurations and workflows

---

## 📄 License

This skill is part of the Codex Flow project and is licensed under the MIT License.

---

**Last Updated:** 2026-03-16
**Version:** 1.0.0
**Maintainer:** Codex Flow Team
