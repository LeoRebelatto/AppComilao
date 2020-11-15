import 'package:cloud_firestore/cloud_firestore.dart';
import 'modeloBase.dart';

class ModeloProduto extends ModeloBase {
  String _documentId;
  String nome;
  String descricao;
  double preco;
  String foto;
  String tipo;

  ModeloProduto();
  ModeloProduto.parametrizado(this.nome, this.descricao, this.preco, this.foto);

  ModeloProduto.fromMap(DocumentSnapshot document) {
    _documentId = document.documentID;

    this.nome = document.data["nome"];
    this.descricao = document.data["descricao"];
    this.preco = document.data["preco"] + 0.00;
    this.foto = document.data["foto"];
    this.tipo = document.data["tipo"];
  }

  String get getNome => this.nome;
  String get getDescricao => this.descricao;
  double get getPreco => this.preco;
  String get getFoto => this.foto;
  String get getTipo => this.tipo;

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['nome'] = this.nome;
    map['descricao'] = this.descricao;
    map['preco'] = this.preco.toStringAsFixed(2);
    map['foto'] = this.foto;
    map['tipo'] = this.tipo;

    return map;
  }

  Map<String, dynamic> toResumedMap() {
    return {'nome': nome, 'descricao': descricao, 'preco': preco};
  }

  @override
  String documentId() => _documentId;
}
