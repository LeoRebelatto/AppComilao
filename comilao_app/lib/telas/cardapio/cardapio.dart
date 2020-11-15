import 'package:comilaoapp/models/modeloProduto.dart';
import 'package:comilaoapp/models/modeloUsuario.dart';
import 'package:comilaoapp/repositorios/repositorioProduto.dart';
import 'package:comilaoapp/telas/autenticacao/entrar.dart';
import 'package:comilaoapp/telas/cardapio/destaques.dart';
import 'package:comilaoapp/telas/cardapio/telaCarrinho.dart';
import 'package:comilaoapp/telas/cardapio/telaProduto.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Cardapio extends StatefulWidget {
  @override
  _CardapioState createState() => _CardapioState();
}

class _CardapioState extends State<Cardapio> with TickerProviderStateMixin {
  RepositorioProduto _repositorioProduto = RepositorioProduto();
  TabController _tabController;
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _repositorioProduto.listarCategorias(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Carregando');
          List<String> categorias = snapshot.data;
          _tabController =
              TabController(length: snapshot.data.length, vsync: this);
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (!ModeloUsuario.of(context).isLoggedIn()) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Carrinho'),
                      content: Container(
                        height: 100,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Icon(
                              Icons.remove_shopping_cart,
                              size: 50.0,
                              color: Colors.grey,
                            ),
                            Text('Faça login para acessar o carrinho')
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Fazer login'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SignIn()));
                          },
                        ),
                        FlatButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TelaCarrinho()));
                }
              },
              child: Icon(Icons.shopping_cart),
              backgroundColor: Color(0xFFED7F05),
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(
                      "assets/fundoGradiente.png"), // <-- BACKGROUND IMAGE
                  fit: BoxFit.fill,
                ),
              ),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    backgroundColor: Color(0xFFF78C01),
                    expandedHeight: 220,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        child: Destaques(),
                      ),
                    ),
                    bottom: TabBar(
                        controller: _tabController,
                        labelColor: Colors.white,
                        isScrollable: true,
                        indicatorColor: Colors.transparent,
                        unselectedLabelColor: Colors.white38,
                        unselectedLabelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        onTap: (index) async {
                          int qtdItens = await _repositorioProduto
                              .buscarIndexCategoria(categorias[index])
                              .first;
                          _scrollController.animateTo(
                            qtdItens * 100.0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.decelerate,
                          );
                          // _scrollController.addListener(() {
                          //   if (_scrollController.offset > 0 &&
                          //       _scrollController.offset < qtdItens * 100) {
                          //     _tabController.animateTo(index);
                          //   }
                          // });
                        },
                        tabs: categorias.map((f) => Text(f)).toList()),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [...categorias.map((f) => montarCard(f)).toList()],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget montarCard(String tipo) {
    return StreamBuilder(
      stream: _repositorioProduto.listarProdutos(tipo),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Text("Carregando")
            : ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Divider(
                    thickness: 2,
                    color: Colors.black38,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (ctx, index) {
                        var produto = (snapshot.data[index] as ModeloProduto);
                        return Card(
                          color: Color(0xFFFFFFFF).withOpacity(0.6),
                          elevation: 0.0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TelaProduto(produto)));
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    elevation: 0,
                                    color: Color(0xFFFFFFFF).withOpacity(0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image:
                                                    FirebaseImage(produto.foto),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 5, top: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            //mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                produto.nome,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  produto.descricao,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    'R\$ ',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    produto.preco
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
      },
    );
  }
}
