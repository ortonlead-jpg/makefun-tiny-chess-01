# tiny-chess-01 entry

A chess engine in under 4096 bytes for the make.fun tiny-chess-01 competition:
bitboard move generation, alpha-beta search with null-move pruning, late move
reductions, quiescence search and a transposition table, with search depth
bounded by a node-count budget (no wall-clock timing) for deterministic replay.
`main.py` is packed with `makefun compress` (LZMA) to fit the 4096-byte size cap.

MIT licensed, see LICENSE.
