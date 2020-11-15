import 'package:cloud_firestore/cloud_firestore.dart';
import 'modeloBase.dart';

class ModeloAdicionais extends ModeloBase {
  String _documentId;
  String nome;
  double preco;
  String tipo;

  ModeloAdicionais();
  ModeloAdicionais.parametrizado(this.nome, this.preco);

  ModeloAdicionais.fromMap(DocumentSnapshot document) {
    _documentId = document.documentID;

    this.nome = document.data["nome"];
    this.preco = document.data["preco"] + 0.00;
    this.tipo = document.data["tipo"];
  }

  String get getNome => this.nome;
  double get getPreco => this.preco;
  String get getTipo => this.tipo;

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['nome'] = this.nome;
    map['preco'] = this.preco.toStringAsFixed(2);
    map['tipo'] = this.tipo;

    return map;
  }

  Map<String, dynamic> toResumedMap() {
    return {'nome': nome, 'preco': preco};
  }

  @override
  String documentId() => _documentId;
}
