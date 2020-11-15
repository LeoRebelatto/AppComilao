import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comilaoapp/models/modeloUsuario.dart';
import 'package:comilaoapp/widgets/cardGerPedidos.dart';
import 'package:comilaoapp/widgets/cardPedidos.dart';
import 'package:flutter/material.dart';

class TelaGerenciamentoPedidos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Pedidos'),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(
                  "assets/fundoGradiente.png"), // <-- BACKGROUND IMAGE
              fit: BoxFit.fill,
            )),
        child: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("pedidos").getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              return ListView(
                children: snapshot.data.documents
                    .map((doc) => CardGerPedidos(doc.documentID))
                    .toList()
                    .reversed
                    .toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
