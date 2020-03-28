
import 'package:flutter/material.dart';
import 'package:milk/model/theme_model.dart';
import 'package:milk/resources/resources.dart';
import 'package:milk/widgets/my_card.dart';

import 'load_image.dart';

class OrderTagItem extends StatelessWidget {

  const OrderTagItem({
    Key key,
    @required this.date,
    @required this.orderTotal,
  }) : super(key: key);

  final String date;
  final int orderTotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: MyCard(
          child: Container(
            height: 34.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                ThemeModel.isuserDarkMode()? const LoadAssetImage('order/icon_calendar_dark', width: 14.0, height: 14.0) :
                const LoadAssetImage('order/icon_calendar', width: 14.0, height: 14.0),
                Gaps.hGap10,
                Text(date),
                Expanded(child: Gaps.empty),
                Text('$orderTotal单')
              ],
            ),
          )
      ),
    );
  }
}