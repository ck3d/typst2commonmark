#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PASS=0
FAIL=0

REPO_ROOT="$(cd .. && pwd)"

for FIXTURE in fixtures/*.typ; do
  name=$(basename "$FIXTURE" .typ)

  if ! typst compile --root "$REPO_ROOT" "$FIXTURE" "$name.pdf" 2>/dev/null; then
    echo "COMPILE ERROR: $name"
    FAIL=$((FAIL + 1))
    continue
  fi

  results=$(typst query --root "$REPO_ROOT" "$FIXTURE" '<test>' 2>/dev/null || echo '[]')

  while IFS= read -r line; do
    [ -z "$line" ] && continue
    case "$line" in
      '"pass"')
        PASS=$((PASS + 1))
        ;;
      '["fail"'*)
        FAIL=$((FAIL + 1))
        printf 'FAIL: %s\n  expected: %s\n  actual  : %s\n' \
          "$(printf '%s' "$line" | jq -r '.[1]')" \
          "$(printf '%s' "$line" | jq '.[2]')" \
          "$(printf '%s' "$line" | jq '.[3]')"
        ;;
      *)
        FAIL=$((FAIL + 1))
        echo "FAIL: unexpected value: $line"
        ;;
    esac
  done < <(echo "$results" | jq -c '.[].value')

  rm -f "$name.pdf"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  PASS: $PASS  FAIL: $FAIL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━"

[ "$FAIL" = "0" ]
