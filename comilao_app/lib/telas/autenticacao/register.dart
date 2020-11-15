import 'package:comilaoapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:comilaoapp/models/modeloUsuario.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _telefoneController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor:
              Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
          body: ScopedModelDescendant<ModeloUsuario>(
              builder: (context, child, model) {
            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 70.0),
                        TextFormField(
                          controller: _nomeController,
                          decoration: textInputDecoration.copyWith(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white24,
                            ),
                            hintText: 'Nome',
                          ),
                          validator: (text) =>
                              text.isEmpty ? 'Nome inválido' : null,
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          controller: _telefoneController,
                          decoration: textInputDecoration.copyWith(
                            prefixIcon: Icon(
                              Icons.smartphone,
                              color: Colors.white24,
                            ),
                            hintText: 'Telefone',
                          ),
                          validator: (text) => text.isEmpty || text.length != 11
                              ? "O celular deve ter 11 dígitos ex: 61 999999999"
                              : null,
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          controller: _emailController,
                          decoration: textInputDecoration.copyWith(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white24,
                            ),
                            hintText: 'E-mail',
                          ),
                          validator: (text) =>
                              text.isEmpty || !text.contains("@")
                                  ? 'Digite um e-mail válido'
                                  : null,
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          controller: _passController,
                          decoration: textInputDecoration.copyWith(
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: Colors.white24,
                            ),
                            hintText: 'Senha',
                          ),
                          obscureText: true,
                          validator: (val) => val.length < 6
                              ? 'A senha deve ter mais de 6 digitos'
                              : null,
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .065,
                          child: RaisedButton(
                            color: Color(0xFFE03906),
                            child: Text(
                              'Registar',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {}
                              Map<String, dynamic> userData = {
                                'nome': _nomeController.text,
                                'telefone': _telefoneController.text,
                                'email': _emailController.text,
                                'foto':
                                    'gs://comilao-8b6e4.appspot.com/fotosUsuarios/AvatarPadrão.png',
                              };

                              model.signUp(
                                  userData: userData,
                                  pass: _passController.text,
                                  onSuccess: _onSuccess,
                                  onFail: _onFail);
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 40, top: 10),
                              child: Text('Já sou cadastrado!',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
