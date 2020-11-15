import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comilaoapp/models/modeloUsuario.dart';
import 'package:comilaoapp/widgets/cardPedidos.dart';
import 'package:flutter/material.dart';

class TelaPedidos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = ModeloUsuario.of(context).firebaseUser.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
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
          future: Firestore.instance
              .collection("users")
              .document(uid)
              .collection("pedidos")
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              return ListView(
                children: snapshot.data.documents
                    .map((doc) => CardPedidos(doc.documentID))
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
