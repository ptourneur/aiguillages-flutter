import 'package:aiguillages/model/double_switch.dart';
import 'package:aiguillages/model/single_switch.dart';
import 'package:aiguillages/model/switch.dart';
import 'package:aiguillages/service/bluetooth.dart';
import 'package:flutter/material.dart';

class Railway extends ChangeNotifier {
  Railway() {
    switchList = _initializeSwitch();
    bluetooth.connectArduino((String id) => updateSwitch(id));
  }

  Bluetooth bluetooth = Bluetooth();
  List<TrainSwitch> switchList = <TrainSwitch>[];

  void steerSwitch(int id) {
    final TrainSwitch trainSwitch = switchList
        .firstWhere((TrainSwitch trainSwitch1) => trainSwitch1.id == id);
    bluetooth.sendCommand('1$id${trainSwitch.isLinkedToCurveBranch ? 0 : 1}');
  }

  void updateSwitch(String dataReceived) {
      if (dataReceived.length == 3) {
        final int id = int.parse(dataReceived[1]);
        final bool isLinkedToCurveBranch =
            int.parse(dataReceived[2]) == 1;

        switchList
            .firstWhere((TrainSwitch trainSwitch) => trainSwitch.id == id)
            .isLinkedToCurveBranch = isLinkedToCurveBranch;
      }
    notifyListeners();
  }

  static const double BOTTOM_HEIGHT = 0.65;
  static const double MIDDLE_HEIGHT = 0.50;
  static const double TOP_HEIGHT = 0.375;

  static List<TrainSwitch> _initializeSwitch() {
    final List<TrainSwitch> switchList = <TrainSwitch>[];

    // First switch
    const Offset origin = Offset(0.05, BOTTOM_HEIGHT);
    const Offset endCurveFirstSwitch = Offset(0.20, MIDDLE_HEIGHT);
    const Offset firstMiddlePoint = Offset(0.30, MIDDLE_HEIGHT);
    const Offset firstBottomPoint = Offset(0.20, BOTTOM_HEIGHT);

    final TrainSwitch firstSwitch = SingleSwitch(
        1, origin, firstBottomPoint, firstMiddlePoint,
        endCurve: endCurveFirstSwitch);
    switchList.add(firstSwitch);

    // Second switch
    const Offset startCurveSecondSwitch = Offset(0.30, BOTTOM_HEIGHT);
    const Offset secondBottomPoint = Offset(0.50, BOTTOM_HEIGHT);
    const Offset endCurveSecondSwitch = Offset(0.45, MIDDLE_HEIGHT);
    const Offset secondMiddlePoint = Offset(0.575, MIDDLE_HEIGHT);

    final TrainSwitch secondSwitch = DoubleSwitch(2, firstBottomPoint,
        secondBottomPoint, firstMiddlePoint, secondMiddlePoint,
        startCurve: startCurveSecondSwitch, endCurve: endCurveSecondSwitch);
    switchList.add(secondSwitch);

    // Third switch
    const Offset endCurveFourthSwitch = Offset(0.725, TOP_HEIGHT);
    const Offset topPoint = Offset(0.7625, TOP_HEIGHT);
    const Offset fourthMiddlePoint = Offset(0.7625, MIDDLE_HEIGHT);
    final TrainSwitch thirdSwitch = SingleSwitch(
        3, secondMiddlePoint, fourthMiddlePoint, topPoint,
        endCurve: endCurveFourthSwitch);
    switchList.add(thirdSwitch);

    // Fourth switch
    const Offset endCurveFifthSwitch = Offset(0.80, TOP_HEIGHT);
    const Offset fifthMiddlePoint = Offset(0.95, MIDDLE_HEIGHT);
    final TrainSwitch fourthSwitch = SingleSwitch(
        4, fifthMiddlePoint, fourthMiddlePoint, topPoint,
        endCurve: endCurveFifthSwitch);
    switchList.add(fourthSwitch);

    return switchList;
  }
}
