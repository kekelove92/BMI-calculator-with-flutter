import 'package:bmi_calculator_app/util/ulti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class WeightSlider extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final double width;
  final int value;
  final ValueChanged<int> onChanged;
  final ScrollController scrollController;

  WeightSlider(
      {Key key,
      @required this.minValue,
      @required this.maxValue,
      @required this.width,
      this.value,
      this.onChanged})
      : scrollController = new ScrollController(
            initialScrollOffset: (value - minValue) * width / 3),
        super(key: key);

  double get itemExtent => width / 3;

  int _indexToValue(int index) => minValue + (index - 1);

  @override
  Widget build(BuildContext context) {
    int itemCount = (maxValue - minValue) + 3;
    int _offsetToMiddleIndex(double offset) =>
        (offset + width / 2) ~/ itemExtent;

    int _offsetToMiddleValue(double offset) {
      int indexOfMiddleElement = _offsetToMiddleIndex(offset);
      int middleValue = _indexToValue(indexOfMiddleElement);
      middleValue = math.max(minValue, math.min(maxValue, middleValue));
      return middleValue;
    }


    bool _onNotification(Notification notification) {
      if (notification is ScrollNotification) {
        int middleValue = _offsetToMiddleValue(notification.metrics.pixels);

        if (_userStoppedScrolling(notification)) {
          _animateTo(middleValue);
        }
        if (middleValue != value) {
          onChanged(middleValue);
        }
      }
      return true;
    }

    return NotificationListener(
      onNotification: _onNotification,
      child: new ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemExtent: itemExtent,
          itemCount: itemCount,
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final int value = _indexToValue(index);
            bool isExtra = index == 0 || index == itemCount - 1;
            return isExtra
                ? new Container() // item first and last element
                : GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => -_animateTo(value, durationMillis: 50),
                    child: FittedBox(
                      child: new Text(
                        value.toString(),
                        style: _getTextStyle(value),
                      ),
                      fit: BoxFit.scaleDown,
                    ),
                  );
          }),
    );
  }

  // check user is stop scrolling or not
  bool _userStoppedScrolling(Notification notification) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  // animate to value selected or will select
  _animateTo(int valueToSelect, {int durationMillis = 200}) {
    double targetExtent = (valueToSelect - minValue) * itemExtent;
    scrollController.animateTo(targetExtent,
        duration: new Duration(milliseconds: durationMillis),
        curve: Curves.decelerate);
  }

  TextStyle _getTextStyle(int itemValue) {
    return itemValue == value
        ? _getHighLightTextStyle()
        : _getDefaultTextStyle();
  }

  TextStyle _getDefaultTextStyle() {
    return new TextStyle(color: defaultColor, fontSize: 14);
  }

  TextStyle _getHighLightTextStyle() {
    return new TextStyle(color: highlightColor, fontSize: 28);
  }
}
