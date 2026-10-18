#!/usr/bin/env bash
# Fails when a Cursor, GitHub, or upstream-model name reappears in estack's agent-facing text.
# Run from the repository root: scripts/check-cursor-names.sh
set -u
cd "$(dirname "$0")/.."

terms='`Task`|\bTask (tool|subagent|call|spawn)|`AskQuestion`|generalPurpose|run_in_background|readonly: (true|false)|environment: "(cloud|local)"|cloud_base_branch|\.cursor/|\.cursor-plugin|agent-transcripts|todolist|is_background'
terms="$terms"'|estack-models\.mdc|pstack-models|claude-opus-5|\bgrok\b|inherit-parent|`auto`|xhigh-fast|fast or standard speed'
terms="$terms"'|\bCursor\b|\bcursor\b|cursor-team-kit|control-(ui|cli)|create-skill|Custom Mode|[Cc]loud ([Ss]ub)?[Aa]gent|/in-cloud|[Bb]ugbot'
terms="$terms"'|\bgh\b|\bOrigin\b|origin pr|Graphite|watch-pr|GitHub|#1234'

# Lines that may name these on purpose: attribution, generic tracker examples, the text cursor.
allow='github\.com/cursor/plugins|GitHub Issues|cursor location|ported from cursor|copyright Cursor|at Cursor,'

hits=$(grep -rnIE --exclude-dir=.git -- "$terms" skills agents docs README.md | grep -vE -- "$allow")
if [ -n "$hits" ]; then
	echo "$hits"
	echo
	echo "Cursor or upstream names found. Fold them into Claude Code and GitLab terms, or add the line to the allow list in $0."
	exit 1
fi
echo "ok: no Cursor, GitHub, or upstream-model names in skills, agents, docs, or README"
