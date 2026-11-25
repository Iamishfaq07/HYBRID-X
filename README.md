# HYBRID-X v0.12 — Targeted backlog implementation

**Single-model local AI workspace.** Target: Qwen3.8-27B GGUF, Windows 11 / RX 9070 XT / Ryzen 9950X / 64 GB RAM / 2 TB SSD; optional Apple Silicon Mac. This is a source release, not a signed native installer. It runs the upstream llama.cpp inference runtime, not a replacement tensor engine.

## New in v0.12

- Review Plans: cross-module Python relationship navigation and durable sequential human-reviewed stages.
- Installable unsigned VS Code package in `dist/` with source location navigation.
- First-party MCP resource listing/read, in addition to notes search.
- Opt-in same-model semantic context compaction; original history retained.
- Experimental SQLCipher private database mode: `PRIVATE-WINDOWS.cmd` / `PRIVATE-MAC.command` (optional binding, not runtime-tested here).
- Inno Setup installer source and signing build recipe; no signed executable included.
- Independent synthetic CPU transformer reference, optional HIP matvec integration (not Qwen inference).
- Guided hardware validation: `VALIDATE-WINDOWS.cmd` / `VALIDATE-MAC.command`.

Read [release details](docs/RELEASE-0.12.md), [private mode and installer](docs/PRIVATE-AND-INSTALLER.md), and [native runtime and validation](docs/REFERENCE-RUNTIME.md). The full Qwen runtime is still llama.cpp. Existing model files and data are retained by normal setup; back up data before upgrading.

## Start here

1. Extract the whole ZIP into its own folder. Keep the files together.
2. Windows: double-click `START-WINDOWS.cmd`. If Python is missing, the launcher can offer an official Python install via winget. Reopen after installation. Mac: run `bash START-MAC.command` in Terminal (requires Python 3.10+).
3. On the first launch, select an official backend download (Vulkan is the simplest starting point on Windows) or an existing trusted llama-server executable. Select the 9070 XT, then reuse your local GGUF or explicitly approve downloading the pinned ~17 GB checkpoint. Set the initial context to 8192. Downloads require internet; normal inference does not.
4. Studio opens automatically in the default browser at an ephemeral 127.0.0.1 port. Select an absolute **project folder** (not your whole home directory), then click **Start session**. Wait for Ready; enter a question and Send. Enable read-only tools only if needed. Each proposed file access has a separate Allow/Deny prompt.
5. Click Stop model to release memory, or Ctrl+C in the launcher terminal to close Studio and stop the backend. Closing a browser tab alone does not stop the model.

Existing v0.3–v0.10 installs are reused via `~/HYBRID-X-data` (or `HYBRIDX_HOME`). No automatic overwrite of installed model, profile, or session database. To change a backend/model, troubleshoot setup, run auto-tuning or compare MTP, open `ADVANCED-WINDOWS.cmd` or `bash ADVANCED-MAC.command`. Option 7 opens the original Tkinter Studio; option 12 opens the new browser Studio. Option 3 measures baseline configurations; only measured results are saved. Start at 8K and increase context after verifying memory headroom. Do not run two launchers against the same data directory simultaneously.

## New in v0.11

- **Review plans:** open the new Review plans page after choosing a project. Record a goal and acceptance criteria, attach existing source evidence, and explicitly accept an in-review plan only when every attached source hash matches its current file. Acceptance records human judgment; it is not a security guarantee. Reopen to draft to clear stale attachments and capture new evidence.
- **Reusable review recipes:** prepare a review brief for manual use in chat (design, secure code, remediation, supply-chain and AI security reviews). No tools run automatically.
- **Incremental metadata index:** explicitly refresh the project index, then search file names and symbols. Unchanged SHA-256 hashes reuse parsing results. Deleted files are removed on refresh. Up to 500 files / 16 MiB, up to 200 declarations per file, 100 displayed matches. Only paths, hashes and symbols are retained; no full source text is added by this index. Python AST; JS/TS/Go/Rust/Java lexical hints only. Results can become stale; refresh before review. Clear the index when no longer needed.
- **Backend privacy:** disable upstream RAM prompt-cache and idle-slot saving if the backend advertises those flags. Single-slot same-session prompt caching may still operate. This changes the runtime configuration; retune performance profiles. Persistent disk KV files are not enabled.
- **Developer release checks:** `python scripts/verify-release.py` checks listed files against bundled hashes. `python scripts/dependency-inventory.py` reports direct optional dependency versions installed locally. Neither is a signed release or a complete SBOM.

See `docs/RELEASE-0.11.md`, `docs/RESEARCH-0.11.md`, `docs/BACKLOG-0.11.md` and `docs/TEST-REPORT.md`. Backup your existing data before upgrading. Model-free review works through the existing REVIEW launchers.

## New in v0.10

- **Code graph:** Review Center can inspect approved Python source and display conservative function-call hints with locations. Not full runtime resolution.
- **Advisory ranges:** offline npm/Cargo SEMVER event-range comparison alongside exact-version matching. Results remain candidates.
- **MCP notes connection:** test the bundled local notes MCP service from Studio or `python -m hybridx notes-mcp --index PATH QUERY`.
- **VS Code:** optional source-only review bridge in `vscode-extension/`; opens running Studio and copies a user-confirmed selected code excerpt. No automatic uploads.
- **Hardware validation:** advanced menu option 19, or `python -m hybridx validate-install --home PATH --output NEW_REPORT.json --measure`. Omit `--measure` for diagnostics only. Close other inference servers first. This report is local and may contain private installation paths. Do not share it without reviewing.

See `docs/RELEASE-0.10.md`, `docs/BACKLOG-0.10.md` and `docs/TEST-REPORT.md` for current implementation and validation limits. Existing data and model downloads can be reused. Actual AMD acceleration remains unverified.

## New in v0.9

- **Model-free review:** run `REVIEW-WINDOWS.cmd` or `bash REVIEW-MAC.command` to open Studio without initial model or backend installation. Use Assessments and Review center. Chat still requires normal setup.
- **Workflows:** Review center → Workflows. Create design, code-review, remediation, supply-chain or AI security checklists. Each step has a durable status and reviewer note. This is human-operated, not autonomous agent execution.
- **Search:** Review center → Search. Project-scoped literal search across finding metadata, tasks, architecture, notes, components and workflows; not cross-project or source-code search.
- **Supply chain:** import SPDX 2.2/2.3 JSON as well as CycloneDX. Compare approved local OSV JSON records against exact package URLs and explicitly listed versions. Ranges and inconsistent PURLs are not interpreted. A match is a review candidate; no match is not evidence of safety. No internet requests are made.
- **Restore:** advanced menu 16 restores trusted local backup databases into a *new* directory. Existing data is not overwritten. Original workspace paths remain unchanged. Configuration and model files are not included. To adopt the recovered database directory, stop all Studio processes, preserve the original and review paths; configure inference separately.
- **Optional privacy:** from the extracted source directory run `python -m pip install ".[privacy]"` (Windows may use `py -3` instead of `python`). Advanced menu 17/18 creates and restores password-protected `.hxb` backups. AES-256-GCM with random salt and nonce, scrypt key derivation; passwords are prompted, not command-line arguments. Minimum 12 characters. Encrypted backup size limit 128 MiB compressed. Live databases, temporary staging files and normal reports are plaintext; use OS encryption. Only restore your own trusted backup, even if authenticated. No secure erasure guarantee.
- **Optional PDF/DOCX:** `python -m pip install ".[reports]"`, then Review center → Risk & exports. PDF needs a supported system TrueType font (DejaVu Sans or Arial); DOCX supports more document-editing flexibility. Exports are plaintext and bounded. Report content preserves candidate/review states; no automatic verification claim.
- **Evaluation:** 20 synthetic defensive classification fixtures (10 vulnerable, 10 non-vulnerable); actual Qwen results remain unmeasured. Existing quality test is available through advanced option 11.

For both optional extras: `python -m pip install ".[privacy,reports]"`. The base launcher remains dependency-free. Optional installation requires internet or cached packages. Do not expose Studio outside loopback.

See `docs/RELEASE-0.9.md` and `docs/BACKLOG-0.9.md` for historical v0.9 status.

## Retained from v0.8

- Open **Review center** in the navigation. Select an existing assessment to record threat/design/retest/confidence notes, save checkpoints, compare finding lifecycle and coverage, view architecture relationship cards, import a sanitized CycloneDX JSON inventory, compare captured evidence with current source, calculate a manually selected CVSS v3.1 base vector, and export CSV or SARIF. SARIF retains review state; imports do not establish vulnerabilities. SBOMs are cumulative component declarations, not a resolved dependency graph or current CVE analysis. Up to 5000 input component records, 500 displayed at a time. CSV rejects a possibly truncated snapshot. Retest diffs compare the original line range, which may have shifted.
- In **Assessments > Code intelligence**, choose Repository structure & dependencies for Python AST symbols and imports, clearly labeled lexical declaration hints for JS/TS/Go/Rust/Java, and selected npm/requirements declarations. No language execution, full Tree-sitter parser, call graph or dependency resolver.
- Chat-only SSE streaming is enabled by the **Stream chat** checkbox. Disable if a backend lacks compatible SSE. Draft text is not saved until a completed response; file-tool turns use the previous non-streaming path. Stop model cancels by terminating the owned inference process, not a pause/resume mechanism.
- Optional extractive history experiment: set `HYBRIDX_EXTRACTIVE_CONTEXT=1` before launching Studio (`$env:HYBRIDX_EXTRACTIVE_CONTEXT='1'` in PowerShell or `export HYBRIDX_EXTRACTIVE_CONTEXT=1` in a shell). Only short historical user/assistant text excerpts are retained, never old tool outputs or calls. They are marked untrusted and only inserted if the template-aware budget allows it. It is not semantic summarization or evidence verification and is off by default.

See `docs/RELEASE-0.8.md`, `docs/RESEARCH-0.8.md`, and `docs/BACKLOG-0.8.md` for exact scope and limitations.

## Retained from v0.7

Open **Assessments & evidence** from Studio. No model is required for the assessment ledger itself once Studio is running. Create an assessment with an authorized local folder and scope notes; add candidate findings manually or import sanitized SARIF 2.1.0 (up to 500 results per file, 1.8 MB browser limit). Capture local source excerpts with SHA-256 file hashes and explicit confirmation. Human review and current source evidence are required before marking a candidate confirmed. Integrity checks verify the captured file, not the existence of a vulnerability. Track coverage across ten review domains, tasks, and component relationships. Code intelligence provides bounded file metadata and Python AST symbols/imports; OpenAPI/Swagger JSON inspection records declared security only, not runtime behavior. Copy a candidate review brief to the chat workspace for read-only assistance. Export JSON, Markdown or escaped HTML. Assessment records are included in local database backups. All data remains unencrypted: use OS disk encryption and approved repositories, and inspect exports before sharing.

The assessment UI is separately navigable; chat and the assessment database are not automatically synchronized. No scanner execution, remote access, or automatic finding confirmation. See `docs/RELEASE-0.7.md` and `docs/BACKLOG-0.7.md`.

## Retained from v0.6

- Studio health check, light/dark theme, per-message copy and user-initiated JSON conversation export (committed user/assistant messages only).
- Offline GGUF header inspector: architecture, context, blocks and selected metadata. This is not model integrity or MTP compatibility verification.
- Advanced menu option 13: health check; 14: local database backup; 15: repeated-prompt cache experiment (requires a successful tuning profile). Backup files are unencrypted; store privately. Use the new restore command to validate and extract known database files into a fresh directory.
- `DEV-CHECK-WINDOWS.cmd` or `bash DEV-CHECK-MAC.command` runs local regression tests and optional CMake checks. GitHub Actions workflow provided; not executed on GitHub here.
- `python -m hybridx inspect /path/to/model.gguf`, `python -m hybridx preflight --home /path/to/HYBRID-X-data`, `python -m hybridx backup --home /path/to/HYBRID-X-data --output /path/to/new-backup.zip`.

## Browser Studio

Three-column responsive layout: recent sessions and review templates; conversation and approvals; OS resource monitor and explicitly imported references. Ctrl/Cmd+Enter sends a message. The workspace is locally scoped and individual tools are approval-gated. The browser receives no llama-server API key. The web server binds to loopback, checks Host/Origin and a random per-launch token, sends a restrictive CSP, and renders model output as text, not HTML. The local user and any software running as the same account are trusted; this is not a multi-user security boundary. Session databases are unencrypted. Stop the model before running benchmarks from another launcher. No remote shell, exploit runner or active network scanning tools are provided.

## Reference library and MCP

Enter an approved folder of text/Markdown documentation; explicitly confirm import. Search and review excerpts before attaching them. For optional use from an MCP host, run `python -m hybridx.mcp_notes --index /absolute/path/to/knowledge.db` using an explicit, trusted local stdio configuration. The minimal 2025-11-25 MCP server exposes **search_notes** only, on a pre-imported index; no arbitrary client-side MCP tools or remote transport. It is not certified against all MCP clients. Do not share confidential notes with an untrusted host.

## Native experiments (not production inference kernels)

With CMake and a C++ compiler installed, `cmake -S native -B build-native`, `cmake --build build-native --config Release`, then `ctest --test-dir build-native -C Release --output-on-failure`. `hybridx-dot-probe` checks signed int8 dot-product results against scalar reference, using runtime AVX-512BW dispatch on supported GCC/Clang x86 systems; MSVC/ARM use the scalar fallback. This is a standalone experiment, not GGUF quantization or an integrated speedup. Optional `scripts/build-hip-probe.ps1` uses an installed HIP SDK/hipcc for a correctness-checked GPU vector-add kernel test targeted at gfx1201; not compiled or tested here. See native/README.md.

## Validation and known limitations

* See `docs/TEST-REPORT.md` for actual regression results. No real model weights were loaded.
* Native CPU dot-product CTest passed; JS syntax checked with Node. Chromium launched but local URL navigation was blocked by environment policy; visual/browser interaction QA remains unverified. Optional browser smoke script: install Playwright and its browser or set `HYBRIDX_CHROMIUM` to an installed Chromium executable; run `python scripts/browser-smoke.py`.
* Windows WMI GPU process memory and maximum individual engine utilization are best-effort. Missing readings are shown as unavailable; not validated on actual RX 9070 XT. Temperature and GPU power are not reported.
* No independent native inference runtime or integrated custom RDNA/Zen 5 GGUF kernels. No measured speedup claims. SSD uses mapped files, not dense tensor streaming. MTP is an opt-in experiment using upstream flags. No general-purpose MCP client, multi-agent autonomous execution, semantic compression or disk KV checkpoints. Extractive history is optional and not semantic.
* Backend asset names/digests and model architecture support must be confirmed on the target OS. Installation download not exercised here. Keep the previous release until the new release works on your machine.

Read `docs/RELEASE-0.10.md` for current status, `docs/TEST-REPORT.md` for validation, and `docs/V04-GUIDE.md` for the previous advanced CLI commands.
