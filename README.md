# tiny-chess-01 entry

[![make.fun · tiny-chess-01](https://make.fun/badge/tiny-chess-01.svg)](https://make.fun/bounty/tiny-chess-01?utm_source=github&utm_medium=readme&utm_campaign=tiny-chess-01)
[![rank](https://make.fun/badge/tiny-chess-01/ortonlead-jpg/makefun-tiny-chess-01/rank.svg)](https://make.fun/bounty/tiny-chess-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=tiny-chess-01)
[![reward](https://make.fun/badge/tiny-chess-01/ortonlead-jpg/makefun-tiny-chess-01/reward.svg)](https://make.fun/bounty/tiny-chess-01?utm_source=github&utm_medium=readme&utm_campaign=tiny-chess-01)

A chess engine in under 4096 bytes for the make.fun tiny-chess-01 competition:
bitboard move generation, alpha-beta search with null-move pruning, late move
reductions, quiescence search and a transposition table, with search depth
bounded by a node-count budget (no wall-clock timing) for deterministic replay.
`main.py` is built from the readable source `engine.py` with `makefun compress`
(LZMA payload plus unpacker) to fit the 4096-byte size cap. `engine.py` is not
committed (the repository is capped at 8192 bytes). To rebuild, from the kit:

    node cli/makefun.mjs compress ../engine.py --out ../main.py

MIT licensed, see LICENSE.
