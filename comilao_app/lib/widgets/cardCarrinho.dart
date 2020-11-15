import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comilaoapp/models/modeloCarrinho.dart';
import 'package:comilaoapp/models/modeloPrdtCarrinho.dart';
import 'package:comilaoapp/models/modeloProduto.dart';
import 'package:flutter/material.dart';

class CardCarrinho extends StatelessWidget {
  final ModeloPrdtCarrinho modeloPrdtCarrinho;

  CardCarrinho(this.modeloPrdtCarrinho);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      String observacao;
      ModeloCarrinho.of(context).atualizarPrecos();
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      modeloPrdtCarrinho.modeloProduto.nome,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 17.0),
                    ),
                    Text(
                      'R\$ ${modeloPrdtCarrinho.modeloProduto.preco.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 17.0),
                    ),
                    Text(
                      modeloPrdtCarrinho.observacao == null
                          ? ''
                          : '${modeloPrdtCarrinho.observacao}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 17.0),
                    )
                  ]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.remove),
                color: Theme.of(context).primaryColor,
                onPressed: modeloPrdtCarrinho.quantidade > 1
                    ? () {
                        ModeloCarrinho.of(context)
                            .decProduct(modeloPrdtCarrinho);
                      }
                    : null,
              ),
              Text(modeloPrdtCarrinho.quantidade.toString()),
              IconButton(
                icon: Icon(Icons.add),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  ModeloCarrinho.of(context).incProduct(modeloPrdtCarrinho);
                },
              ),
              FlatButton(
                child: Text("Remover"),
                textColor: Colors.grey[500],
                onPressed: () {
                  ModeloCarrinho.of(context)
                      .removerCartItem(modeloPrdtCarrinho);
                },
              )
            ],
          )
        ],
      );
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: modeloPrdtCarrinho.modeloProduto == null
            ? FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance
                    .collection('produto')
                    .document(modeloPrdtCarrinho.produtoId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    modeloPrdtCarrinho.modeloProduto =
                        ModeloProduto.fromMap(snapshot.data);
                    return _buildContent();
                  } else {
                    return Container(
                      height: 70.0,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  }
                },
              )
            : _buildContent());
  }
}
