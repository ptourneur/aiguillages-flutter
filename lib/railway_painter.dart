import 'package:aiguillages/model/railway.dart';
import 'package:aiguillages/model/switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchable/touchable.dart';

class RailwayPainter extends CustomPainter {
  RailwayPainter(this.context) : railway = Provider.of<Railway>(context);

  final Railway railway;
  final BuildContext context;

  final Paint tapZonePaint = Paint()
    ..color = Colors.transparent
    ..style = PaintingStyle.fill;

  final Paint linkedPaint = Paint()
    ..color = Colors.green[800]
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8;

  final Paint unlinkedPaint = Paint()
    ..color = Colors.grey[800]
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final TouchyCanvas touchyCanvas = TouchyCanvas(context, canvas);

    for (final TrainSwitch trainSwitch in railway.switchList) {
      _drawSwitch(trainSwitch, touchyCanvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void _drawSwitch(TrainSwitch trainSwitch, TouchyCanvas canvas, Size size) {
    final Matrix4 scaleMatrix = Matrix4.identity();
    scaleMatrix.scale(size.width, size.height);

    final Path tapZonePath =
        trainSwitch.getTapZonePath().transform(scaleMatrix.storage);
    final Path curvePath =
        trainSwitch.getCurvePath().transform(scaleMatrix.storage);
    final Path straightPath =
        trainSwitch.getStraightPath().transform(scaleMatrix.storage);

    if (trainSwitch.isLinkedToCurveBranch) {
      canvas.drawPath(straightPath, unlinkedPaint);
      canvas.drawPath(curvePath, linkedPaint);
    } else {
      canvas.drawPath(curvePath, unlinkedPaint);
      canvas.drawPath(straightPath, linkedPaint);
    }
    canvas.drawPath(tapZonePath, tapZonePaint,
        onTapDown: (TapDownDetails tapDetails) =>
            railway.steerSwitch(trainSwitch.id));
  }
}
