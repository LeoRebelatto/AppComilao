
import 'package:comilaoapp/telas/cardapio/cardapio.dart';
import 'package:comilaoapp/telas/home/sidebar/sidebar.dart';
import 'package:flutter/material.dart';


class Home extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: <Widget>[
        Scaffold(
          body: Stack(
            children: <Widget>[
              Cardapio(),
              SideBar(),
            ],
          ),
        )
      ],

    );
  }
}
