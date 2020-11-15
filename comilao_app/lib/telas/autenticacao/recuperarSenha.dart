import 'package:comilaoapp/shared/constants.dart';
import 'package:flutter/material.dart';

class RecuperarSenha extends StatefulWidget {
  @override
  _RecuperarSenhaState createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("assets/fundoLogo.png"), // <-- BACKGROUND IMAGE
              fit: BoxFit.fill,
            ),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor:
              Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
          body: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white24,
                          ),
                          hintText: 'E-mail',
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Digite um e-mail' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        child: RaisedButton(
                          color: Color(0xFFE03906),
                          child: Text(
                            'Recuperar Senha',
                            style: TextStyle(color: Colors.white),
                            maxLines: 1,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              // _auth.recuperarSenha(email);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text('Recuperar senha'),
                                  content: Text('Caso o endereço de e-mail '
                                      'esteja cadastrado, você receberá '
                                      'um link para recuperar sua senha.'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                        ),
                      ),
                      Container(
                        child: RaisedButton(
                          color: Color(0xFFFA0400),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.white),
                            maxLines: 1,
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                        ),
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
