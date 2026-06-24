---
name: enhancing-performance
description: Use when making performance, latency, throughput, scalability, memory, CPU, database, caching, allocation, concurrency, load-test, benchmark, or optimization changes where Codex must prove before-and-after impact, collect evidence for the cause, and watch for regressions in non-target metrics.
---

# Enhancing Performance

## Overview

Treat performance work as an experiment, not a guess. Capture the baseline first, collect evidence for the bottleneck, make the smallest patch that targets it, rerun the same benchmark, and explain the result from measured evidence.

## Required Inputs

Before changing code, require these from the user or discover them from an existing checked-in plan:

- Benchmark command: exact command to run before and after the patch.
- Target under test: endpoint, function, query, job, flow, or workload being optimized.
- Primary metric: the metric that defines success, including direction and threshold when available.

If any required input is missing, stop and ask. Do not infer a benchmark command or success metric silently.

## Workflow

1. State assumptions and success criteria.
   Include the target, benchmark command, primary metric, expected direction, and guardrail metrics.

2. Check the worktree and environment.
   Record branch, dirty files, relevant config, and whether the benchmark needs services, fixtures, warmup, cache state, or stable data. Do not overwrite unrelated user changes.

3. Create an artifact location before running tests.
   Use a repo-local ignored path when one exists; otherwise use a timestamped path under `/tmp`. Store every benchmark and verification run as a file with the phase, command, timestamp, exit code, raw output, extracted primary metric, and guardrail metrics.

4. Run the baseline benchmark before editing.
   Save metrics and test results to an artifact file. If the benchmark fails, save the failure artifact and debug the benchmark setup before optimizing code.

5. Collect diagnostic evidence before patching.
   Capture evidence that explains why performance is bad: query execution plans, execution path, profiler samples, traces, logs, allocation data, lock waits, cache stats, network calls, or benchmark breakdowns. Save each evidence item to a file. If evidence is unavailable, state what was attempted and why the rationale remains a hypothesis.

6. Identify the likely bottleneck from evidence.
   Tie the bottleneck claim to the collected evidence. Do not claim root cause from the benchmark number alone.

7. Make the smallest patch aimed at the bottleneck.
   Avoid broad refactors, speculative caching, config knobs, or unrelated cleanup. Add or update correctness tests when behavior can change.

8. Rerun the same benchmark after the patch.
   Use the same command and comparable environment. Save metrics and test results to a new artifact file. If you intentionally change setup, explain why the comparison is still valid.

9. Collect post-patch diagnostic evidence.
   Capture comparable evidence when possible, such as the new query plan, changed execution path, profiler sample, trace, log excerpt, allocation data, or cache stat. Save it to files and use it to explain why performance improved or why the result is inconclusive.

10. Compare target and guardrail metrics.
   Report baseline, after, absolute delta, percentage delta, and whether the primary metric met the stated threshold. Call out regressions even when the primary metric improved.

11. Run normal verification.
   Run relevant correctness tests, lint, or build checks after the performance run. Save each run's result to an artifact file. Performance improvement is not enough if correctness regresses.

## Artifact Files

Every benchmark, diagnostic evidence capture, load test, correctness test, lint run, or build verification must produce a file. Prefer plain text, Markdown, JSON, CSV, or the benchmark tool's native result format.

Each artifact must include or be paired with:

- Phase: `baseline`, `diagnosis`, `after`, or `verification`.
- Target under test.
- Command and working directory.
- Timestamp and environment notes that affect comparability.
- Exit code and pass/fail status.
- Raw output or path to raw output.
- Extracted primary metric.
- Extracted guardrail metrics, even when they did not change.
- Diagnostic evidence, such as query execution plan, execution path, profiler sample, trace, log excerpt, allocation data, lock wait, cache stat, or reason it could not be collected.
- Notes about noise, warmup, cache state, data shape, or failed collection.

If a tool already writes a result file, keep it and create a short companion summary file when needed so the final report can point to exact evidence.

## Guardrail Metrics

Track non-target metrics that could degrade. Choose what the benchmark or platform exposes, and prefer stable measured values over guesses.

| Area | Examples |
| --- | --- |
| Latency | p50, p95, p99, max, timeout count |
| Throughput | requests/sec, jobs/sec, rows/sec |
| Resources | CPU, memory, allocation rate, GC count/time, thread count |
| Storage | query count, query time, rows scanned, index usage, lock wait, connection pool pressure |
| Caching | hit rate, miss rate, eviction count, stale-read risk |
| Reliability | error rate, retry count, dropped work, backpressure, queue depth |
| Correctness | result parity, ordering, idempotency, race-sensitive behavior |

## Comparison Format

After the job is done, give the user this report:

1. What was the problem
   State the bottleneck or hypothesis, the target under test, and the primary metric that defined success.

2. What has been done
   Summarize the patch, tests/benchmarks run, and artifact files created.

3. Before / after comparison
   Include baseline and after values, absolute delta, percentage delta, guardrail metrics, verification results, artifact file paths, and residual risks such as benchmark noise, missing production-like data, or unmeasured metrics.

4. Rationale
   Explain why performance was bad and why it improved using collected evidence. Reference the specific artifact files, such as before/after query execution plans, execution paths, traces, profiler samples, logs, or other diagnostics. If the evidence is incomplete, say what is proven, what is inferred, and what remains uncertain.

## Stop Conditions

Stop and ask before patching when:

- The user has not provided the benchmark command, target, or primary metric.
- The benchmark cannot run in the current environment and no comparable substitute is agreed.
- Test metrics or test results cannot be stored as files.
- Diagnostic evidence cannot be collected and the user has not agreed to proceed with a hypothesis-only rationale.
- The benchmark is too noisy to compare and needs repeated runs or a more stable setup.
- The likely patch would trade correctness, consistency, security, or maintainability for speed.
