import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The jigsaw cut of an N×N puzzle: every internal edge gets a tab on one side
/// and the matching blank on the other, chosen at random from [seed].
class JigsawCut {
  JigsawCut(this.gridSize, int seed) {
    final random = math.Random(seed);
    int pick() => random.nextBool() ? 1 : -1;
    _horizontal = List.generate(gridSize - 1, (_) => List.generate(gridSize, (_) => pick()));
    _vertical = List.generate(gridSize, (_) => List.generate(gridSize - 1, (_) => pick()));
  }

  final int gridSize;

  /// How far a tab sticks out, relative to the cell size.
  static const tabRatio = 0.3;

  // _horizontal[r][c]: edge under cell (r, c). +1 = that cell has a tab going down.
  late final List<List<int>> _horizontal;
  // _vertical[r][c]: edge right of cell (r, c). +1 = that cell has a tab going right.
  late final List<List<int>> _vertical;

  /// Edge shapes of cell (row, col): +1 tab, -1 blank, 0 flat border.
  ({int top, int right, int bottom, int left}) edgesOf(int row, int col) => (
        top: row == 0 ? 0 : -_horizontal[row - 1][col],
        right: col == gridSize - 1 ? 0 : _vertical[row][col],
        bottom: row == gridSize - 1 ? 0 : _horizontal[row][col],
        left: col == 0 ? 0 : -_vertical[row][col - 1],
      );

  /// Outline of cell (row, col) in a box of side `cell * (1 + 2 * tabRatio)`,
  /// with the cell itself inset by `cell * tabRatio`.
  Path piecePath(int row, int col, double cell) {
    final m = cell * tabRatio;
    final e = edgesOf(row, col);
    final topLeft = Offset(m, m);
    final topRight = Offset(m + cell, m);
    final bottomRight = Offset(m + cell, m + cell);
    final bottomLeft = Offset(m, m + cell);
    final path = Path()..moveTo(topLeft.dx, topLeft.dy);
    _edge(path, topLeft, topRight, e.top);
    _edge(path, topRight, bottomRight, e.right);
    _edge(path, bottomRight, bottomLeft, e.bottom);
    _edge(path, bottomLeft, topLeft, e.left);
    return path..close();
  }

  /// Outlines of every cell, positioned on a board of `cell * gridSize`.
  Path boardOutline(double cell) {
    final m = cell * tabRatio;
    final path = Path();
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        path.addPath(piecePath(r, c, cell), Offset(c * cell - m, r * cell - m));
      }
    }
    return path;
  }

  // Classic jigsaw knob, in edge-local units: u along the edge (0..1),
  // v outward from the piece. Mirrored inward for a blank.
  static const _knob = <List<double>>[
    [0.40, 0.00, 0.42, 0.08, 0.38, 0.14],
    [0.32, 0.24, 0.40, 0.31, 0.50, 0.31],
    [0.60, 0.31, 0.68, 0.24, 0.62, 0.14],
    [0.58, 0.08, 0.60, 0.00, 0.66, 0.00],
  ];

  static void _edge(Path path, Offset start, Offset end, int shape) {
    if (shape == 0) {
      path.lineTo(end.dx, end.dy);
      return;
    }
    final along = end - start;
    final length = along.distance;
    final dir = along / length;
    // Outward normal for a clockwise outline in screen coordinates.
    final outward = Offset(dir.dy, -dir.dx) * shape.toDouble();
    Offset at(double u, double v) => start + dir * (u * length) + outward * (v * length);

    final neck = at(0.34, 0);
    path.lineTo(neck.dx, neck.dy);
    for (final k in _knob) {
      final a = at(k[0], k[1]), b = at(k[2], k[3]), c = at(k[4], k[5]);
      path.cubicTo(a.dx, a.dy, b.dx, b.dy, c.dx, c.dy);
    }
    path.lineTo(end.dx, end.dy);
  }
}

/// One jigsaw piece: the puzzle picture clipped to the piece's outline, with
/// a white edge and a soft shadow. [cell] is the side of the piece's square
/// part; the widget is `cell * (1 + 2 * tabRatio)` wide to fit the tabs.
class JigsawPiece extends StatelessWidget {
  const JigsawPiece({
    super.key,
    required this.image,
    required this.cut,
    required this.row,
    required this.col,
    required this.cell,
    this.lifted = false,
    this.showShadow = true,
    this.showEdge = true,
  });

  final String image;
  final JigsawCut cut;
  final int row;
  final int col;
  final double cell;
  final bool lifted;
  final bool showShadow;
  final bool showEdge;

  static double boxSize(double cell) => cell * (1 + 2 * JigsawCut.tabRatio);

  @override
  Widget build(BuildContext context) {
    final m = cell * JigsawCut.tabRatio;
    final board = cell * cut.gridSize;
    final path = cut.piecePath(row, col, cell);
    return SizedBox.square(
      dimension: boxSize(cell),
      child: CustomPaint(
        painter: showShadow ? _PieceShadow(path, lifted) : null,
        foregroundPainter: showEdge ? _PieceEdge(path) : null,
        child: ClipPath(
          clipper: _PathClipper(path),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: m - col * cell,
                top: m - row * cell,
                width: board,
                height: board,
                child: Image.asset(image, fit: BoxFit.fill),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Faint outlines of all the pieces, drawn on the empty board as a guide.
class JigsawOutlinePainter extends CustomPainter {
  JigsawOutlinePainter(this.cut);
  final JigsawCut cut;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / cut.gridSize;
    canvas.drawPath(
      cut.boardOutline(cell),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
  }

  @override
  bool shouldRepaint(JigsawOutlinePainter old) => old.cut != cut;
}

class _PathClipper extends CustomClipper<Path> {
  _PathClipper(this.path);
  final Path path;

  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(_PathClipper old) => old.path != path;
}

class _PieceEdge extends CustomPainter {
  _PieceEdge(this.path);
  final Path path;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_PieceEdge old) => old.path != path;
}

class _PieceShadow extends CustomPainter {
  _PieceShadow(this.path, this.lifted);
  final Path path;
  final bool lifted;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawShadow(path, Colors.black, lifted ? 10 : 4, false);
  }

  @override
  bool shouldRepaint(_PieceShadow old) => old.path != path || old.lifted != lifted;
}
