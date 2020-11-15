import 'package:flutter/material.dart';

class TelaEnderecos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => CadastrarEndereco()));
        },
        child: Icon(Icons.shopping_cart),
        backgroundColor: Color(0xFFED7F05),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Text('Endereços'),
        actions: <Widget>[],
      ),
    );
  }
}
