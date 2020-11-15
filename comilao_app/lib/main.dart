import 'package:comilaoapp/models/modeloCarrinho.dart';
import 'package:comilaoapp/models/modeloUsuario.dart';
import 'package:comilaoapp/telas/home/home.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ModeloUsuario>(
      model: ModeloUsuario(),
      child: ScopedModelDescendant<ModeloUsuario>(
        builder: (context, child, model) {
            return ScopedModel<ModeloCarrinho>(
                model: ModeloCarrinho(model),
                child: MaterialApp(
                    debugShowCheckedModeBanner: false, home: Home()));
        },
      ),
    );
  }
}
