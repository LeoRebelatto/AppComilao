import 'package:comilaoapp/models/modeloCarrinho.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PrecoCarrinho extends StatefulWidget {
  VoidCallback buy;

  PrecoCarrinho(this.buy);

  @override
  _PrecoCarrinhoState createState() => _PrecoCarrinhoState();
}

class _PrecoCarrinhoState extends State<PrecoCarrinho> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<ModeloCarrinho>(
            builder: (context, child, model) {
          double preco = model.getPrecoProdutos();
          double entrega = model.getPrecoEntrega();
          double desconto = model.getDesconto();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Resumo do pedido',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Subtotal'),
                  Text('R\$ ${preco.toStringAsFixed(2)}'),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Desconto'),
                  Text('-R\$ ${desconto.toStringAsFixed(2)}'),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Entrega'),
                  Text('R\$ ${entrega.toStringAsFixed(2)}')
                ],
              ),
              Divider(
                thickness: 2.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total', style: TextStyle(fontWeight: FontWeight.w500)),
                  Text('R\$ ${(preco + entrega - desconto).toStringAsFixed(2)}')
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .065,
                child: RaisedButton(
                  color: Color(0xFFED7F05),
                  child: Text(
                    'Finalizar Pedido',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: widget.buy,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
