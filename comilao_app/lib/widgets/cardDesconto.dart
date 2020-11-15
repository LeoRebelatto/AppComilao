import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comilaoapp/models/modeloCarrinho.dart';
import 'package:flutter/material.dart';

class CardDesconto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              fontSize: 16),
        ),
        leading: Icon(Icons.local_offer_outlined),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Digite seu cupom"),
              initialValue: ModeloCarrinho.of(context).codCupom ?? "",
              onFieldSubmitted: (text) {
                Firestore.instance
                    .collection("cupons")
                    .document(text)
                    .get()
                    .then((docSnap) {
                  if (docSnap.data != null) {
                    ModeloCarrinho.of(context)
                        .setCupom(text, docSnap.data["porcentagem"]);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Desconto de ${docSnap.data["porcentagem"]}% aplicado!"),
                      backgroundColor: Theme.of(context).primaryColor,
                    ));
                  } else {
                    ModeloCarrinho.of(context).setCupom(null, 0);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Cupom não existente!"),
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
