import 'package:comilaoapp/models/modeloCarrinho.dart';
import 'package:comilaoapp/telas/home/sidebar/pedidos.dart';
import 'package:comilaoapp/widgets/cardCarrinho.dart';
import 'package:comilaoapp/widgets/cardDesconto.dart';
import 'package:comilaoapp/widgets/cardPagamento.dart';
import 'package:comilaoapp/widgets/cardTroco.dart';
import 'package:comilaoapp/widgets/precoCarrinho.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class TelaCarrinho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Text('Carrinho'),
        actions: <Widget>[],
      ),
      body: ScopedModelDescendant<ModeloCarrinho>(
          builder: (context, child, model) {
        if (model.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (model.produtos == null || model.produtos.length == 0) {
          return Center(
            child: Text(
              'Nenhum produto no carrinho!',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return ListView(
            children: <Widget>[
              Column(
                children: model.produtos.map((produto) {
                  return CardCarrinho(produto);
                }).toList(),
              ),
              CardDesconto(),
              CardPagamento(),
              CardTroco(),
              PrecoCarrinho(() async {
                String idPedido = await model.finalizarPedido();
                if (idPedido != null) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TelaPedidos()));
                }
              }),
            ],
          );
        }
      }),
    );
  }
}
