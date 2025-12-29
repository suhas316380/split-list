#!/bin/bash

FILE="$1"

if [ -z "$FILE" ]; then
    echo "Usage: $0 <blocklist-file>"
    exit 1
fi

if [ ! -f "$FILE" ]; then
    echo "Error: File '$FILE' not found!"
    exit 1
fi

echo "=== Auditing Blocklist: $FILE ==="
echo ""

echo "📊 Statistics:"
echo "Total lines: $(wc -l < "$FILE")"
echo "Non-comment lines: $(grep -v '^#' "$FILE" | grep -v '^$' | wc -l)"
echo "Blank lines: $(grep -c '^[[:space:]]*$' "$FILE")"
echo "Comment lines: $(grep -c '^#' "$FILE")"
echo ""

echo "⚠️  Potentially Dangerous Entries:"
echo "TLD-only entries (e.g., .com):"
grep -E '^\.[a-z]+$' "$FILE" | head -5
echo ""

echo "Wildcard entries:"
grep '\*' "$FILE" | head -5
echo ""

echo "Very short entries (< 5 chars):"
awk 'length($0) < 5 && $0 !~ /^#/ && $0 != ""' "$FILE" | head -5
echo ""

echo "Entries without dots (invalid domains):"
grep -v '\.' "$FILE" | grep -v '^#' | grep -v '^$' | head -5
echo ""

echo "🔍 Format Issues:"
echo "Lines with spaces:"
grep ' ' "$FILE" | head -5
echo ""

echo "Lines with trailing whitespace: $(grep -c '[[:space:]]$' "$FILE")"
echo ""

echo "🎯 Major Sites Check (should be empty):"
grep -E '^(google\.com|facebook\.com|youtube\.com|amazon\.com|apple\.com|microsoft\.com|twitter\.com|reddit\.com|linkedin\.com|netflix\.com)$' "$FILE"
echo ""

echo "♻️  Duplicates found: $(sort "$FILE" | uniq -d | wc -l)"
if [ "$(sort "$FILE" | uniq -d | wc -l)" -gt 0 ]; then
    echo "First 5 duplicates:"
    sort "$FILE" | uniq -d | head -5
fi
echo ""

echo "✅ Audit complete!"
