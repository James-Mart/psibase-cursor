#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <package-name>" >&2
  exit 1
fi

package_name="$1"
archive_path="./build/psidk/share/psibase/packages/${package_name}.psi"

if [[ ! -f "$archive_path" ]]; then
  echo "Package archive not found: $archive_path" >&2
  exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
  echo "unzip is required but not found in PATH" >&2
  exit 1
fi

extract_dir="$(mktemp -d -t "psi-${package_name}-XXXXXX")"

archive_size_bytes="$(wc -c < "$archive_path" | tr -d '[:space:]')"

echo "$archive_path"
echo "Size (bytes): $archive_size_bytes"

unzip -q "$archive_path" -d "$extract_dir"

echo "Extracted files with sizes (bytes):"
(
  cd "$extract_dir"
  find . -type f -print0 | sort -z | while IFS= read -r -d '' file; do
    size="$(wc -c < "$file" | tr -d '[:space:]')"
    echo "${file}: ${size}"
  done
)

echo
echo "meta.json:"
meta_json_path="$extract_dir/meta.json"
if [[ -f "$meta_json_path" ]]; then
  if command -v jq >/dev/null 2>&1; then
    jq '.' "$meta_json_path"
  elif command -v python3 >/dev/null 2>&1; then
    python3 -m json.tool "$meta_json_path"
  else
    cat "$meta_json_path"
  fi
else
  echo "meta.json not found at expected path: $meta_json_path" >&2
  exit 1
fi

echo

echo "Extraction directory:"
echo "$extract_dir"
echo