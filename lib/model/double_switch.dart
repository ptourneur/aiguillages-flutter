import 'package:aiguillages/model/switch.dart';
import 'package:flutter/material.dart';

class DoubleSwitch extends TrainSwitch {
  DoubleSwitch(int id, Offset origin, Offset straightBranch,
      this.straightBranch2, Offset curveBranch,
      {Offset startCurve, Offset endCurve})
      : super(id, origin, straightBranch, curveBranch,
            startCurve: startCurve, endCurve: endCurve);

  Offset straightBranch2;

  @override
  Path getStraightPath() {
    final Path straightPath = super.getStraightPath();
    straightPath.moveTo(straightBranch2.dx, straightBranch2.dy);
    straightPath.lineTo(curveBranch.dx, curveBranch.dy);
    return straightPath;
  }

  @override
  Path getTapZonePath() {
    final Path circle = Path();
    final Offset tapZoneCenter = Offset(
        (startCurve.dx + endCurve.dx) / 2, (startCurve.dy + endCurve.dy) / 2);
    circle.addOval(Rect.fromCircle(center: tapZoneCenter, radius: 0.13));
    return circle;
  }
}
