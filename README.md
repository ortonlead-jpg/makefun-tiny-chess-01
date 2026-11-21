# tiny-chess-01 entry

A chess engine in under 4096 bytes for the make.fun tiny-chess-01 competition:
bitboard move generation, alpha-beta search with null-move pruning, late move
reductions, quiescence search and a transposition table, with search depth
bounded by a node-count budget (no wall-clock timing) for deterministic replay.
The source is minified and self-decompressing (LZMA) to fit the size cap.

MIT licensed, see LICENSE.
