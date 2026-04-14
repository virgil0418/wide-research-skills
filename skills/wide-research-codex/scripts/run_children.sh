#!/usr/bin/env bash
# Wide Research — Parallel Child Scheduler
# Extracted from grapeot/codex_wide_research orchestration prompt
#
# Usage:
#   1. Prepare a task manifest (tasks.json or tasks.csv)
#   2. Generate child prompt files in prompts/ directory
#   3. Run this script: bash run_children.sh [CONCURRENCY]
#
# Defaults: CONCURRENCY=8, TIMEOUT=600s (10 min)

set -euo pipefail

CONCURRENCY="${1:-8}"
TIMEOUT="${2:-600}"
RUN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROMPTS_DIR="$RUN_DIR/prompts"
OUTPUT_DIR="$RUN_DIR/child_outputs"
LOGS_DIR="$RUN_DIR/logs"

mkdir -p "$OUTPUT_DIR" "$LOGS_DIR"

# Collect task IDs from prompt files
shopt -s nullglob
PROMPT_FILES=("$PROMPTS_DIR"/*.md)
TOTAL=${#PROMPT_FILES[@]}

if [ "$TOTAL" -eq 0 ]; then
    echo "ERROR: No prompt files found in $PROMPTS_DIR"
    exit 1
fi

echo "=== Wide Research Scheduler ==="
echo "Tasks: $TOTAL | Concurrency: $CONCURRENCY | Timeout: ${TIMEOUT}s"
echo "Run directory: $RUN_DIR"
echo ""

FAILED_IDS=()
COMPLETED=0

run_child() {
    local prompt_file="$1"
    local task_id
    task_id=$(basename "$prompt_file" .md)
    local output_file="$OUTPUT_DIR/${task_id}.md"
    local log_file="$LOGS_DIR/${task_id}.log"

    # Skip if already completed
    if [ -s "$output_file" ]; then
        echo "[SKIP] $task_id — output already exists"
        return 0
    fi

    echo "[START] $task_id at $(date -Iseconds)"
    local start_time
    start_time=$(date +%s)

    local exit_code=0
    timeout "$TIMEOUT" stdbuf -oL -eL codex exec \
        --sandbox workspace-write \
        -c sandbox_workspace_write.network_access=true \
        -c model_reasoning_effort="low" \
        --output-last-message "$output_file" \
        - <"$prompt_file" 2>&1 | tee "$log_file" || exit_code=$?

    local end_time
    end_time=$(date +%s)
    local duration=$(( end_time - start_time ))

    if [ $exit_code -eq 0 ]; then
        echo "[DONE] $task_id — ${duration}s"
        COMPLETED=$((COMPLETED + 1))
    elif [ $exit_code -eq 124 ]; then
        echo "[TIMEOUT] $task_id — exceeded ${TIMEOUT}s"
        FAILED_IDS+=("$task_id")
    else
        echo "[FAIL] $task_id — exit code $exit_code, ${duration}s"
        FAILED_IDS+=("$task_id")
    fi
}

# Run with concurrency control using a job slot approach
echo "Launching parallel execution..."
echo ""

SLOT=0
for prompt_file in "${PROMPT_FILES[@]}"; do
    run_child "$prompt_file" &

    SLOT=$((SLOT + 1))
    if [ "$SLOT" -ge "$CONCURRENCY" ]; then
        wait -n 2>/dev/null || true  # wait for any child to finish (bash 4.3+)
        SLOT=$((SLOT - 1))
    fi
done

# Wait for all remaining children
wait

echo ""
echo "=== Summary ==="
echo "Completed: $COMPLETED/$TOTAL"

if [ ${#FAILED_IDS[@]} -gt 0 ]; then
    echo "Failed tasks:"
    for id in "${FAILED_IDS[@]}"; do
        echo "  - $id (check logs/$id.log)"
    done
    echo ""
    echo "To retry failed tasks only, re-run this script."
    exit 1
fi

echo "All tasks completed successfully."
echo ""
echo "Next steps:"
echo "  1. Aggregate: python3 aggregate.py $OUTPUT_DIR > final_report.md"
echo "  2. Polish section-by-section following the orchestration procedure"
