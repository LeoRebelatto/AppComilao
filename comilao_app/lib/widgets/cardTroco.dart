import 'package:comilaoapp/models/modeloCarrinho.dart';
import 'package:flutter/material.dart';

class CardTroco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ExpansionTile(
            title: Text(
              "Solicitar troco",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                  fontSize: 16),
            ),
            leading: Icon(Icons.money_outlined),
            trailing: Icon(Icons.add),
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Troco para quanto?"),
                      initialValue: ModeloCarrinho.of(context).codCupom ?? "",
                      onFieldSubmitted: (text) {
                        ModeloCarrinho.of(context).setTroco(text);
                      }))
            ]));
  }
}
