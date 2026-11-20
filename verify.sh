#!/usr/bin/env bash
set -euo pipefail

here="$(cd -- "$(dirname -- "$0")" && pwd -P)"
work="${1:-replay}"
digest=9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc

mkdir -p -- "$work"
work="$(cd -- "$work" && pwd -P)"
archive="$work/lean.tar.gz"

verify_archive() {
    printf '%s  %s\n' "$digest" "$1" | sha256sum --check
}

if [[ ! -f "$archive" ]]; then
    mkdir -p -- "$work/parts"
    for part in {01..14}; do
        path="$work/parts/part$part"
        curl --fail --location --retry 3 \
            "https://alpo.ge/lean.tar.gz.part$part" -o "$path.partial"
        mv -- "$path.partial" "$path"
    done
    cat -- "$work"/parts/part{01..14} > "$archive.partial"
    verify_archive "$archive.partial"
    mv -- "$archive.partial" "$archive"
else
    verify_archive "$archive"
fi

run="$(mktemp -d "$work/run.XXXXXXXX")"
tar -xzf "$archive" -C "$run"
cd -- "$run/lean"
toolchain="$(tr -d '\r\n' < lean-toolchain)"
elan toolchain install "$toolchain"

{
    elan run "$toolchain" lake --no-ansi env lean --version
    elan run "$toolchain" lake --no-ansi exe cache get Mathlib
    elan run "$toolchain" lake --no-ansi build Main
} 2>&1 | tee "$run/build.log"

elan run "$toolchain" lake --no-ansi env lean --root="$here" "$here/Audit.lean" \
    2>&1 | tee "$run/axioms.log"
