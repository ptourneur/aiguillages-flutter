import 'package:flutter/material.dart';

abstract class TrainSwitch {
  TrainSwitch(this.id, this.origin, this.straightBranch, this.curveBranch,
      {Offset startCurve, Offset endCurve})
      : endCurve = endCurve ?? curveBranch,
        startCurve = startCurve ?? origin,
        isLinkedToCurveBranch = false;

  int id;
  bool isLinkedToCurveBranch;
  Offset origin;
  Offset straightBranch;
  Offset curveBranch;
  Offset startCurve;
  Offset endCurve;

  Path getCurvePath() {
    final Path curvePath = Path();
    curvePath.moveTo(origin.dx, origin.dy);
    curvePath.lineTo(startCurve.dx, startCurve.dy);
    curvePath.cubicTo(
        startCurve.dx + (endCurve.dx - startCurve.dx) / 2,
        startCurve.dy + (endCurve.dy - startCurve.dy) * 0.20,
        startCurve.dx + (endCurve.dx - startCurve.dx) / 2,
        endCurve.dy - (endCurve.dy - startCurve.dy) * 0.20,
        endCurve.dx,
        endCurve.dy);
    curvePath.lineTo(curveBranch.dx, curveBranch.dy);
    return curvePath;
  }

  Path getStraightPath() {
    final Path straightPath = Path();
    straightPath.moveTo(origin.dx, origin.dy);
    straightPath.lineTo(straightBranch.dx, straightBranch.dy);
    return straightPath;
  }

  Path getTapZonePath() {
    final Path circle = Path();
    final Offset tapZoneCenter = Offset(
        (startCurve.dx + endCurve.dx) / 2, (startCurve.dy + endCurve.dy) / 2);
    circle.addOval(Rect.fromCircle(center: tapZoneCenter, radius: 0.11));
    return circle;
  }
}
