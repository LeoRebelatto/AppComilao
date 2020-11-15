import 'package:comilaoapp/models/modeloUsuario.dart';
import 'package:comilaoapp/shared/constants.dart';
import 'package:comilaoapp/telas/autenticacao/recuperarSenha.dart';
import 'package:comilaoapp/telas/autenticacao/register.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final ModeloUsuario _mUser = ModeloUsuario();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
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
        backgroundColor: Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
        body: ScopedModelDescendant<ModeloUsuario>(
            builder: (context, child, model) {
              if (model.isLoading)
                return Center(child: CircularProgressIndicator(),);
              return Center(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 180.0),
                          TextFormField(
                            controller: _emailController,
                            decoration: textInputDecoration.copyWith(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.white24,
                              ),
                              hintText: 'E-mail',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (text) =>
                            text.isEmpty|| !text.contains("@") ?
                            'Digite um e-mail válido' : null,
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
                            validator: (val) =>
                            val.length < 6 ?
                            'A senha deve ter mais de 6 digitos' : null,
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * .065,
                            child: RaisedButton(
                              color: Color(0xFFE03906),
                              child: Text(
                                'Entrar',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {

                                }
                                model.signIn(
                                    email: _emailController.text,
                                    pass: _passController.text,
                                    onSuccess: _onSuccess,
                                    onFail: _onFail
                                );
                              },
                              shape: new RoundedRectangleBorder(borderRadius:
                              new BorderRadius.circular(30.0)),
                            ),
                          ),
                          SizedBox(height: 10,),
                          InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Register())
                              );
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 40, top: 10),
                                child: Text('Não tem uma conta?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (context) => RecuperarSenha())
                              );
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 40, top: 10),
                                child: Text('Esqueci minha senha',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          ),
                          Divider(
                            height: 30,
                            thickness: 0.5,
                            color: Colors.white.withOpacity(0.3),
                            indent: 32,
                            endIndent: 32,
                          ),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * .065,
                            child: RaisedButton(
                              color: Color(0xFF4267B2),
                              child: Text(
                                'Entrar com Facebook',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                dynamic result =
                                await _mUser.signInWithFacebook();
                                if (result == null) {
                                  setState(() => error = 'Erro');
                                }
                              },
                              shape: new RoundedRectangleBorder(borderRadius:
                              new BorderRadius.circular(30.0)),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * .065,
                            child: RaisedButton(
                              color: Color(0xFFFA0400),
                              child: Text(
                                'Entrar com Google',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                dynamic result = await _mUser.signInWithGoogle();
                                if (result == null) {
                                  setState(() => error = 'Erro');
                                }
                              },
                              shape: new RoundedRectangleBorder(borderRadius:
                              new BorderRadius.circular(30.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      ],
    );
  }
  void _onSuccess(){
    Navigator.of(context).pop();
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao Entrar!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}

