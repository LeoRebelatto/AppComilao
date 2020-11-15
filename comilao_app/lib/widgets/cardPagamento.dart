import 'package:comilaoapp/models/modeloCarrinho.dart';
import 'package:flutter/material.dart';

class CardPagamento extends StatefulWidget {
  @override
  _CardPagamentoState createState() => _CardPagamentoState();
}

class _CardPagamentoState extends State<CardPagamento> {
  int selectedRadio;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Método de pagamento:',
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            RadioListTile(
                title: Text('Cartão',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                activeColor: Colors.blueAccent,
                value: 1,
                groupValue: selectedRadio,
                onChanged: (val) {
                  setSelectedRadio(val);
                  ModeloCarrinho.of(context).setPagamento('Cartão');
                }),
            RadioListTile(
                title: Text('Dinheiro',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                activeColor: Colors.blueAccent,
                value: 2,
                groupValue: selectedRadio,
                onChanged: (val) {
                  setSelectedRadio(val);

                  ModeloCarrinho.of(context).setPagamento('Dinheiro');
                })
          ],
        ),
      ),
    );
  }
}
