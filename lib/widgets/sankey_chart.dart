import 'package:flutter/material.dart';

import '../util/money.dart';
import 'common.dart';

/// Where a node sits left to right: income sources, the single income
/// total they feed, then expense categories (plus Savings) it splits into.
class _SankeyNode {
  const _SankeyNode({
    required this.label,
    required this.amountCents,
    required this.color,
    required this.column,
  });

  final String label;
  final int amountCents;
  final Color color;
  final int column;
}

class _SankeyLink {
  const _SankeyLink({
    required this.fromNode,
    required this.toNode,
    required this.amountCents,
    required this.color,
  });

  final int fromNode;
  final int toNode;
  final int amountCents;
  final Color color;
}

/// A three-column income → categories flow chart: what came in on the
/// left, funneling through a single income total, splitting across
/// spending categories (and Savings, for whatever is left) on the right.
class IncomeSankeyChart extends StatelessWidget {
  const IncomeSankeyChart({
    super.key,
    required this.incomeByCategory,
    required this.expenseByCategory,
    required this.leftoverCents,
  });

  final Map<String, int> incomeByCategory;
  final Map<String, int> expenseByCategory;
  final int leftoverCents;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final income = incomeByCategory.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final expense =
        expenseByCategory.entries.where((e) => e.value > 0).toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final totalIncome = income.fold(0, (s, e) => s + e.value);

    if (totalIncome == 0) {
      return const EmptyState(
        icon: Icons.alt_route,
        title: 'No income logged yet',
        message: 'The flow chart needs at least one income entry to work '
            'from.',
      );
    }

    final nodes = <_SankeyNode>[];
    final links = <_SankeyLink>[];

    for (final e in income) {
      final color = categoryColor(context, e.key);
      nodes.add(_SankeyNode(
          label: e.key, amountCents: e.value, color: color, column: 0));
    }
    final incomeNodeIndex = nodes.length;
    nodes.add(_SankeyNode(
        label: 'Income',
        amountCents: totalIncome,
        color: scheme.primary,
        column: 1));
    for (var i = 0; i < income.length; i++) {
      links.add(_SankeyLink(
          fromNode: i,
          toNode: incomeNodeIndex,
          amountCents: income[i].value,
          color: categoryColor(context, income[i].key)));
    }

    for (final e in expense) {
      final color = categoryColor(context, e.key);
      links.add(_SankeyLink(
          fromNode: incomeNodeIndex,
          toNode: nodes.length,
          amountCents: e.value,
          color: color));
      nodes.add(_SankeyNode(
          label: e.key, amountCents: e.value, color: color, column: 2));
    }
    if (leftoverCents > 0) {
      links.add(_SankeyLink(
          fromNode: incomeNodeIndex,
          toNode: nodes.length,
          amountCents: leftoverCents,
          color: scheme.secondary));
      nodes.add(_SankeyNode(
          label: 'Savings',
          amountCents: leftoverCents,
          color: scheme.secondary,
          column: 2));
    }

    return CustomPaint(
      size: Size.infinite,
      painter: _SankeyPainter(
        nodes: nodes,
        links: links,
        textColor: scheme.onSurface,
        mutedColor: scheme.onSurfaceVariant,
      ),
    );
  }
}

class _SankeyPainter extends CustomPainter {
  _SankeyPainter({
    required this.nodes,
    required this.links,
    required this.textColor,
    required this.mutedColor,
  });

  final List<_SankeyNode> nodes;
  final List<_SankeyLink> links;
  final Color textColor;
  final Color mutedColor;

  static const _barWidth = 10.0;
  static const _nodeGap = 10.0;
  static const _minLabelHeight = 16.0;

  @override
  void paint(Canvas canvas, Size size) {
    final byColumn = <int, List<int>>{};
    for (var i = 0; i < nodes.length; i++) {
      byColumn.putIfAbsent(nodes[i].column, () => []).add(i);
    }

    // Each node's percentage is of its own column's total, not of income —
    // column 0 is "share of income sources", column 2 is "share of where
    // it actually went". If spending exceeds income, column 2's shares
    // still correctly sum to 100%, rather than each being computed against
    // income and the total silently exceeding it.
    final columnTotals = <int, int>{
      for (final entry in byColumn.entries)
        entry.key: entry.value.fold<int>(0, (s, i) => s + nodes[i].amountCents),
    };

    // One shared scale (pixels per cent) so a link's thickness always
    // matches the node it meets on either end — the tightest-packed column
    // (the most nodes, so the most gaps eating into the height) decides it.
    var scale = double.infinity;
    for (final indices in byColumn.values) {
      final total = indices.fold<int>(0, (s, i) => s + nodes[i].amountCents);
      if (total <= 0) continue;
      final usable = size.height - _nodeGap * (indices.length - 1);
      if (usable <= 0) continue;
      final s = usable / total;
      if (s < scale) scale = s;
    }
    if (!scale.isFinite || scale <= 0) return;

    final columnX = {
      0: 0.0,
      1: (size.width - _barWidth) / 2,
      2: size.width - _barWidth,
    };

    final rects = List<Rect>.filled(nodes.length, Rect.zero);
    for (final entry in byColumn.entries) {
      var y = 0.0;
      final x = columnX[entry.key]!;
      for (final i in entry.value) {
        final h = nodes[i].amountCents * scale;
        rects[i] = Rect.fromLTWH(x, y, _barWidth, h);
        y += h + _nodeGap;
      }
    }

    final outCursor = List<double>.filled(nodes.length, 0);
    final inCursor = List<double>.filled(nodes.length, 0);
    for (final link in links) {
      final srcRect = rects[link.fromNode];
      final dstRect = rects[link.toNode];
      final h = link.amountCents * scale;
      final srcTop = srcRect.top + outCursor[link.fromNode];
      final dstTop = dstRect.top + inCursor[link.toNode];
      outCursor[link.fromNode] += h;
      inCursor[link.toNode] += h;
      if (h <= 0) continue;

      final x0 = srcRect.right;
      final x1 = dstRect.left;
      final midX = (x0 + x1) / 2;
      final path = Path()
        ..moveTo(x0, srcTop)
        ..cubicTo(midX, srcTop, midX, dstTop, x1, dstTop)
        ..lineTo(x1, dstTop + h)
        ..cubicTo(midX, dstTop + h, midX, srcTop + h, x0, srcTop + h)
        ..close();
      canvas.drawPath(path, Paint()..color = link.color.withValues(alpha: 0.32));
    }

    for (var i = 0; i < nodes.length; i++) {
      final n = nodes[i];
      final rect = rects[i];
      if (rect.height <= 0) continue;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        Paint()..color = n.color,
      );
      if (rect.height < _minLabelHeight) continue;

      final columnTotal = columnTotals[n.column] ?? 0;
      final pct = columnTotal == 0 ? 0.0 : n.amountCents / columnTotal * 100;
      final label = TextPainter(
        text: TextSpan(children: [
          TextSpan(
            text: n.label,
            style: TextStyle(
                color: textColor, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: '\n${fmtCents(n.amountCents)} (${pct.toStringAsFixed(0)}%)',
            style: TextStyle(color: mutedColor, fontSize: 11),
          ),
        ]),
        textDirection: TextDirection.ltr,
        maxLines: 2,
      )..layout(maxWidth: size.width / 2 - 20);

      final labelY =
          (rect.top + rect.height / 2 - label.height / 2).clamp(0.0, size.height - label.height);
      if (n.column == 2) {
        label.paint(canvas, Offset(rect.left - 8 - label.width, labelY));
      } else {
        label.paint(canvas, Offset(rect.right + 8, labelY));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SankeyPainter oldDelegate) =>
      oldDelegate.nodes != nodes || oldDelegate.links != links;
}
