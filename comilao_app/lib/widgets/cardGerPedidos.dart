import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardGerPedidos extends StatelessWidget {
  final String idPedido;

  CardGerPedidos(this.idPedido);

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
                        "Editar status:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Firestore.instance
                                      .collection('pedidos')
                                      .document(idPedido)
                                      .updateData({
                                    "status": snapshot.data["status"] - 1
                                  });
                                },
                              ),
                              Text('Voltar status')
                            ],
                          ),
                          Column(children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Firestore.instance
                                    .collection('pedidos')
                                    .document(idPedido)
                                    .updateData({
                                  "status": snapshot.data["status"] + 1
                                });
                              },
                            ),
                            Text('Avançar status')
                          ]),
                          Column(children: [
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                Firestore.instance
                                    .collection('pedidos')
                                    .document(idPedido)
                                    .delete();
                              },
                            ),
                            Text('Remover')
                          ])
                        ],
                      )
                    ],
                  );
                }
              }),
        ));
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text =
        "Cliente: Leonardo Moraes Rebelatto\nEndereço: Rua: xxx, Número: xxx, Bairro: xxx, Complemento: xxx\n\n";
    //String text = "Cliente:${snapshot.data['cliente']}\n";
    for (LinkedHashMap p in snapshot.data["produtos"]) {
      text +=
          "${p["quantidade"]} x ${p["produto"]["nome"]} (R\$ ${p["produto"]["preco"].toStringAsFixed(2)})\n${p["observacao"]}\n";
    }
    text +=
        "Total: R\$ ${snapshot.data["precoTotal"].toStringAsFixed(2)} \nStatus: ${snapshot.data["status"]}";
    return text;
  }
}
