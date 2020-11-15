import 'dart:async';

import 'package:comilaoapp/models/modeloUsuario.dart';
import 'package:comilaoapp/telas/autenticacao/entrar.dart';
import 'package:comilaoapp/telas/home/sidebar/enderecos.dart';
import 'package:comilaoapp/telas/home/sidebar/gerenciamentoDePedidos.dart';
import 'package:comilaoapp/telas/home/sidebar/menu_item.dart';
import 'package:comilaoapp/telas/home/sidebar/pedidos.dart';
import 'package:comilaoapp/telas/home/sidebar/perfil.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenStreamController;
  Stream<bool> isSidebarOpenStream;
  StreamSink<bool> isSidebarOpenSink;
  final _animationTime = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationTime);
    isSidebarOpenStreamController = PublishSubject<bool>();
    isSidebarOpenStream = isSidebarOpenStreamController.stream;
    isSidebarOpenSink = isSidebarOpenStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenStreamController.close();
    isSidebarOpenSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final ModeloUsuario user = ModeloUsuario();

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenStream,
      builder: (context, isSidebarOpenAsync) {
        return AnimatedPositioned(
          duration: _animationTime,
          top: 0,
          bottom: 0,
          left: isSidebarOpenAsync.data ? 0 : -screenWidth,
          right: isSidebarOpenAsync.data ? 0 : screenWidth - 35,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/fundoSemLogo.png"), // <-- BACKGROUND IMAGE
                        fit: BoxFit.cover,
                      )),
                  //color: Color(0xFF112187),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 90,
                      ),
                      ScopedModelDescendant<ModeloUsuario>(
                        builder: (context, child, model) {
                          if (model.isLoggedIn()) {
                            return ListTile(
                                title: Text(
                                  model.userData['nome'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800),
                                ),
                                subtitle: Text(
                                  model.userData['email'],
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image:
                                          FirebaseImage(model.userData['foto']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  onIconPressed();
                                  await model.signOut();
                                });
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Olá,',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  'Entre ou cadastre-se aqui',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SignIn()));
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      ScopedModel.of<ModeloUsuario>(context,
                                  rebuildOnChange: true)
                              .isLoggedIn()
                          ? ScopedModel.of<ModeloUsuario>(context,
                                      rebuildOnChange: true)
                                  .verifyUserAdmin()
                              ? Column(
                                  children: [
                                    Divider(
                                      height: 64,
                                      thickness: 0.5,
                                      color: Colors.white,
                                      indent: 32,
                                      endIndent: 32,
                                    ),
                                    MenuItem(
                                      icon: Icons.home,
                                      title: 'Home',
                                      onTap: () async {
                                        onIconPressed();
                                      },
                                    ),
                                    MenuItem(
                                      icon: Icons.history,
                                      title: 'Gerenciar Pedidos',
                                      onTap: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TelaGerenciamentoPedidos()));
                                      },
                                    ),
                                    Divider(
                                      height: 64,
                                      thickness: 0.5,
                                      color: Colors.white,
                                      indent: 32,
                                      endIndent: 32,
                                    ),
                                    MenuItem(
                                        icon: Icons.exit_to_app,
                                        title: 'Logout',
                                        onTap: () async {
                                          await ScopedModel.of<ModeloUsuario>(
                                                  context,
                                                  rebuildOnChange: true)
                                              .signOut();
                                        })
                                  ],
                                )
                              : Column(
                                  children: [
                                    Divider(
                                      height: 64,
                                      thickness: 0.5,
                                      color: Colors.white,
                                      indent: 32,
                                      endIndent: 32,
                                    ),
                                    MenuItem(
                                      icon: Icons.home,
                                      title: 'Home',
                                      onTap: () async {
                                        onIconPressed();
                                      },
                                    ),
                                    MenuItem(
                                      icon: Icons.person,
                                      title: 'Perfil',
                                      onTap: () async {
                                        onIconPressed();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Perfil()));
                                      },
                                    ),
                                    MenuItem(
                                      icon: Icons.location_on,
                                      title: 'Endereços',
                                      onTap: () async {
                                        //onIconPressed();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TelaEnderecos()));
                                      },
                                    ),
                                    MenuItem(
                                      icon: Icons.history,
                                      title: 'Pedidos',
                                      onTap: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TelaPedidos()));
                                      },
                                    ),
                                    Divider(
                                      height: 64,
                                      thickness: 0.5,
                                      color: Colors.white,
                                      indent: 32,
                                      endIndent: 32,
                                    ),
                                    MenuItem(
                                        icon: Icons.exit_to_app,
                                        title: 'Logout',
                                        onTap: () async {
                                          await ScopedModel.of<ModeloUsuario>(
                                                  context,
                                                  rebuildOnChange: true)
                                              .signOut();
                                        })
                                  ],
                                )
                          : Container()
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Color(0xFF20201F),
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Color(0xFFFFFFFF),
                        size: 25,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
