import 'package:bmi_calculator_app/card/card_title.dart';
import 'package:bmi_calculator_app/weight/weight_slider.dart';
import 'package:bmi_calculator_app/widget_ultis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeightCard extends StatefulWidget {
  @override
  _WeightCardState createState() => _WeightCardState();
}

class _WeightCardState extends State<WeightCard> {
  int weight;

  @override
  void initState() {
    super.initState();
    weight = 70;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(top: screenAwareSize(32.0, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CardTitle(
              "WEIGHT",
              subtitle: "(KG)",
            ),
            Expanded(
                child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _drawSlider(),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _drawSlider() {
    return WeightBackground(
      child: LayoutBuilder(builder: (context, constraints) {
        return constraints.isTight
            ? Container()
            : WeightSlider(
                minValue: 30,
                maxValue: 110,
                width: constraints.maxWidth,
                value: weight,
                onChanged: (val) => setState(() => weight = val),
              );
      }),
    );
  }
}

class WeightBackground extends StatelessWidget {
  final Widget child;

  const WeightBackground({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: screenAwareSize(100, context),
          decoration: BoxDecoration(
              color: Color.fromRGBO(244, 244, 244, 1),
              borderRadius:
                  new BorderRadius.circular(screenAwareSize(50, context))),
          child: child,
        ),
        SvgPicture.asset(
          "images/weight_arrow.svg",
          height: screenAwareSize(12, context),
          width: screenAwareSize(18, context),
        )
      ],
    );
  }
}
