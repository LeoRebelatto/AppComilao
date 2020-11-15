import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comilaoapp/models/modeloPrdtCarrinho.dart';
import 'package:comilaoapp/models/modeloUsuario.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ModeloCarrinho extends Model {
  ModeloUsuario user;

  List<ModeloPrdtCarrinho> produtos = [];

  String codCupom;
  int percentualDesconto = 0;

  bool isLoading = false;
  String metodoPagamento;
  String troco;

  ModeloCarrinho(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  static ModeloCarrinho of(BuildContext context) =>
      ScopedModel.of<ModeloCarrinho>(context);

  void addCartItem(ModeloPrdtCarrinho modeloPrdtCarrinho) {
    produtos.add(modeloPrdtCarrinho);

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('carrinho')
        .add(modeloPrdtCarrinho.toMap())
        .then((doc) {
      modeloPrdtCarrinho.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removerCartItem(ModeloPrdtCarrinho modeloPrdtCarrinho) {
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('carrinho')
        .document(modeloPrdtCarrinho.cid)
        .delete();

    produtos.remove(modeloPrdtCarrinho);

    notifyListeners();
  }

  void decProduct(ModeloPrdtCarrinho modeloPrdtCarrinho) {
    modeloPrdtCarrinho.quantidade--;

    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .document(modeloPrdtCarrinho.cid)
        .updateData(modeloPrdtCarrinho.toMap());

    notifyListeners();
  }

  void incProduct(ModeloPrdtCarrinho modeloPrdtCarrinho) {
    modeloPrdtCarrinho.quantidade++;

    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .document(modeloPrdtCarrinho.cid)
        .updateData(modeloPrdtCarrinho.toMap());

    notifyListeners();
  }

  void setCupom(String codCupom, int percentualDesconto) {
    this.codCupom = codCupom;
    this.percentualDesconto = percentualDesconto;
  }

  double getPrecoProdutos() {
    double preco = 0.0;
    for (ModeloPrdtCarrinho c in produtos) {
      if (c.modeloProduto != null)
        preco += c.quantidade * c.modeloProduto.preco;
    }
    return preco;
  }

  double getDesconto() {
    return getPrecoProdutos() * percentualDesconto / 100;
  }

  double getPrecoEntrega() {
    double entrega = 7;
    return entrega;
  }

  void atualizarPrecos() {
    notifyListeners();
  }

  Future<String> finalizarPedido() async {
    isLoading = true;
    notifyListeners();

    double precoProdutos = getPrecoProdutos();
    double precoEntrega = getPrecoEntrega();
    double desconto = getDesconto();

    DocumentReference refPedido =
        await Firestore.instance.collection("pedidos").add({
      "clientId": user.firebaseUser.uid,
      "produtos": produtos
          .map((modeloPrdtCarrinho) => modeloPrdtCarrinho.toMap())
          .toList(),
      "precoEntrega": precoEntrega,
      "precoProdutos": precoProdutos,
      "desconto": desconto,
      "precoTotal": precoProdutos - desconto + precoEntrega,
      "pagamento": metodoPagamento,
      "troco": troco,
      "status": 1
    });

    await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("pedidos")
        .document(refPedido.documentID)
        .setData({"pedidoId": refPedido.documentID});

    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .getDocuments();

    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }

    produtos.clear();

    codCupom = null;
    percentualDesconto = 0;

    isLoading = false;
    notifyListeners();

    return refPedido.documentID;
  }

  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .getDocuments();

    produtos =
        query.documents.map((doc) => ModeloPrdtCarrinho.fromMap(doc)).toList();

    notifyListeners();
  }

  void setPagamento(String metodoPagamento) {
    this.metodoPagamento = metodoPagamento;
  }

  void setTroco(String troco) {
    this.troco = troco;
  }
}
