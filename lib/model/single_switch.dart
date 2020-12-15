import 'package:aiguillages/model/switch.dart';
import 'package:flutter/material.dart';

class SingleSwitch extends TrainSwitch {
  SingleSwitch(int id, Offset origin, Offset straightBranch, Offset curveBranch,
      {Offset startCurve, Offset endCurve})
      : super(id, origin, straightBranch, curveBranch,
            startCurve: startCurve, endCurve: endCurve);
}
