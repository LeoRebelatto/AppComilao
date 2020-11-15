import 'package:comilaoapp/models/modeloCarrinho.dart';
import 'package:comilaoapp/models/modeloPrdtCarrinho.dart';
import 'package:comilaoapp/models/modeloUsuario.dart';
import 'package:comilaoapp/telas/autenticacao/entrar.dart';
import 'package:comilaoapp/telas/cardapio/telaCarrinho.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:comilaoapp/models/modeloProduto.dart';

class TelaProduto extends StatefulWidget {
  final ModeloProduto produto;

  TelaProduto(this.produto);

  @override
  _TelaProdutoState createState() => _TelaProdutoState(produto);
}

class _TelaProdutoState extends State<TelaProduto> {
  final ModeloProduto produto;

  String observacao = '';

  _TelaProdutoState(this.produto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarProduto(produto),
      body: Container(
        margin: EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            Text('Descrição:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),
            Text(produto.descricao),
            SizedBox(
              height: 10,
            ),
            // Text(
            //   'Adicionais: ',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            SizedBox(
              height: 150,
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.assignment,
                  color: Colors.black38,
                ),
                hintStyle: TextStyle(
                    color: Colors.black38,
                    fontFamily: "WorkSansLight",
                    fontSize: 12.0),
                hintText: 'Observação. Ex: Sem cebola, sem alface etc...',
              ),
              onChanged: (text) {
                observacao = text;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .065,
                child: RaisedButton(
                  color: Color(0xFFED7F05),
                  child: Text(
                    ModeloUsuario.of(context).isLoggedIn()
                        ? 'Adicionar ao carrinho'
                        : 'Faça o login para comprar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (ModeloUsuario.of(context).isLoggedIn()) {
                      ModeloPrdtCarrinho modeloPrdtCarrinho =
                          ModeloPrdtCarrinho();
                      modeloPrdtCarrinho.quantidade = 1;
                      modeloPrdtCarrinho.produtoId = produto.documentId();
                      modeloPrdtCarrinho.observacao = observacao;
                      modeloPrdtCarrinho.modeloProduto = produto;

                      ModeloCarrinho.of(context)
                          .addCartItem(modeloPrdtCarrinho);

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TelaCarrinho()));
                    } else {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignIn()));
                    }
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomAppBarProduto extends StatelessWidget with PreferredSizeWidget {
  final ModeloProduto produto;
  CustomAppBarProduto(this.produto);
  @override
  Size get preferredSize => Size(double.infinity, 250);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 1),
        decoration: BoxDecoration(color: Color(0xFFED7F05), boxShadow: [
          BoxShadow(
              color: Colors.deepOrange, blurRadius: 20, offset: Offset(0, 0))
        ]),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  produto.nome,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .2,
                )
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * .8,
              height: MediaQuery.of(context).size.height * .30,
              decoration: BoxDecoration(
                  image: DecorationImage(image: FirebaseImage(produto.foto))),
            ),
          ],
        ));
  }
}
