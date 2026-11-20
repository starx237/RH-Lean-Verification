# Lean verification of Levent Alpöge's Riemann Hypothesis formalization

This repository contains the replay script, axiom checks, and build records for an independent verification of the Lean formalization accompanying [Levent Alpöge's note](https://alpo.ge/remark.pdf). The axiom audit targets five declarations in `lean/src/Main.lean`. The proof source is available from the author's [archive](https://alpo.ge/lean.tar.gz.part01) in parts 01–14.

| Input | Version or digest |
| --- | --- |
| Concatenated source archive SHA-256 | `9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc` |
| Lean | `leanprover/lean4:v4.33.1` |
| Mathlib | `0df444a360eaa60ab8c11dca51a86af692955474` |

## Replay

On Linux with Bash, Elan, Git, curl and tar, run:

```sh
bash verify.sh ./replay
```

The script checks the archive digest, uses the toolchain and dependency pins from the archive, builds the `Main` target with Lake, and runs [the axiom audit](Audit.lean). Each replay writes its logs to a fresh subdirectory of the supplied working directory. A previously downloaded archive can be supplied as `replay/lean.tar.gz`.

The recorded verification compiles the modules in the dependency closure of `Main` in import order using the pinned Lean compiler and the archived Lake options. The script above provides a standalone Lake replay of the same target.

## Build status

The build completed for `Main`. The axiom audit reports `propext`, `Classical.choice`, and `Quot.sound` for each of the five declarations.

- [Build record](verification/build.txt)
- [Axiom audit output](verification/axioms.txt)
- [Build progress snapshot](verification/build-progress.txt)
