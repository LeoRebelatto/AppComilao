import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardPedidos extends StatelessWidget {
  final String idPedido;

  CardPedidos(this.idPedido);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection("pedidos")
                  .document(idPedido)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  int status = snapshot.data["status"];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(_buildProductsText(snapshot.data)),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "Status do Pedido:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildCircle("1", "Aceito", status, 1),
                          Icon(Icons.arrow_right_alt),
                          _buildCircle("2", "Preparando", status, 2),
                          Icon(Icons.arrow_right_alt),
                          _buildCircle("3", "Em trânsito", status, 3),
                          Icon(Icons.arrow_right_alt),
                          _buildCircle("4", "Entregue", status, 4),
                        ],
                      )
                    ],
                  );
                }
              }),
        ));
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = "Pedido:\n";
    for (LinkedHashMap p in snapshot.data["produtos"]) {
      text +=
          "${p["quantidade"]} x ${p["produto"]["nome"]} (R\$ ${p["produto"]["preco"].toStringAsFixed(2)})\n${p["observacao"]}\n";
    }
    text += "Total: R\$ ${snapshot.data["precoTotal"].toStringAsFixed(2)}";
    return text;
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
        size: 12,
      );
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 12.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
