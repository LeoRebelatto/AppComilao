import 'package:comilaoapp/models/modeloUsuario.dart';
import 'package:comilaoapp/shared/constants.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  String email;
  String nome;
  String telefone;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ModeloUsuario>(
        builder: (context, child, model) {
      return Scaffold(
        appBar: CustomAppBar(),
        body: Container(
          margin: EdgeInsets.only(right: 20, left: 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: TextStyle(color: Colors.deepOrange),
                  keyboardType: TextInputType.text,
                  decoration: textInputDecorantionPerfil.copyWith(
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.black,
                    ),
                    hintText: model.userData['nome'],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.deepOrange),
                  keyboardType: TextInputType.text,
                  decoration: textInputDecorantionPerfil.copyWith(
                    prefixIcon: Icon(
                      Icons.alternate_email,
                      color: Colors.black,
                    ),
                    hintText: model.userData['email'],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.deepOrange),
                  keyboardType: TextInputType.text,
                  decoration: textInputDecorantionPerfil.copyWith(
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: Colors.black,
                    ),
                    hintText: model.userData['telefone'],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size(double.infinity, 250);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ModeloUsuario>(
      builder: (context, child, model) {
        return ClipPath(
          clipper: MyClipper(),
          child: Container(
              padding: EdgeInsets.only(top: 4),
              decoration: BoxDecoration(color: Colors.deepOrange, boxShadow: [
                BoxShadow(
                    color: Colors.red, blurRadius: 20, offset: Offset(0, 0))
              ]),
              child: Column(children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      "Perfil",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .17,
                    )
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        image: DecorationImage(
                          image: FirebaseImage(model.userData['foto']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 24, 16, 0),
                      child: Container(
                        width: 110,
                        height: 32,
                        child: Center(
                          child: Text("Editar Perfil"),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 20)
                            ]),
                      ),
                    ),
                  ),
                ),
              ])),
        );
      },
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();

    p.lineTo(0, size.height - 70);
    p.lineTo(size.width, size.height);

    p.lineTo(size.width, 0);

    p.close();

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
