import 'package:bmi_calculator_app/gender/gender_arrow.dart';
import 'package:bmi_calculator_app/gender/gender_icon.dart';
import 'package:bmi_calculator_app/widget_ultis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'card/card_title.dart';
import 'gender.dart';

double _circleSize(BuildContext context) => screenAwareSize(80, context);

class GenderCard extends StatefulWidget {
  final Gender initialGender;

  const GenderCard({Key key, this.initialGender}) : super(key: key);

  @override
  _GenderCardState createState() => _GenderCardState();
}

class _GenderCardState extends State<GenderCard>
    with SingleTickerProviderStateMixin {
  AnimationController _arrowAnimationController;
  Gender selectedGender;

  @override
  void initState() {
    selectedGender = widget.initialGender ?? Gender.other;
    _arrowAnimationController = new AnimationController(
        vsync: this,
        lowerBound: -defaultGenderAngle,
        upperBound: defaultGenderAngle,
        value: genderAngles[selectedGender]);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _arrowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: screenAwareSize(8, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CardTitle("GENDER"),
              Padding(
                padding: EdgeInsets.only(top: screenAwareSize(16, context)),
                child: _drawMainStack(),
              )
            ],
          ),
        ),
      ),
    );
  }

  _drawGestureDetector() {
    return Positioned.fill(
      child: Stack(children: [
        TapHandler(onGenderTapped: _setSelectedGender),
      ]),
    );
  }

  Widget _drawCircleIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        GenderCircle(),
        GenderArrow(listenable: _arrowAnimationController)
      ],
    );
  }

  Widget _drawMainStack() {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _drawCircleIndicator(),
          GenderIconTranslated(
            gender: Gender.female,
            isSelected: true,
          ),
          GenderIconTranslated(
            gender: Gender.male,
            isSelected: true,
          ),
          GenderIconTranslated(
            gender: Gender.other,
            isSelected: true,
          ),
          _drawGestureDetector() // handler tap
        ],
      ),
    );
  }

  _setSelectedGender(Gender gender) {
    setState(() {
      selectedGender = gender;
    });
    _arrowAnimationController.animateTo(genderAngles[gender],
        duration: Duration(milliseconds: 150));
  }
}

class GenderCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: _circleSize(context),
      height: _circleSize(context),
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Color.fromRGBO(244, 244, 244, 1.0)),
    );
  }
}

class TapHandler extends StatelessWidget {
  final Function(Gender) onGenderTapped;

  const TapHandler({Key key, this.onGenderTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: GestureDetector(
          onTap: () => onGenderTapped(Gender.female),
        )),
        Expanded(
            child: GestureDetector(
          onTap: () => onGenderTapped(Gender.other),
        )),
        Expanded(
            child: GestureDetector(
          onTap: () => onGenderTapped(Gender.male),
        )),
      ],
    );
  }
}
