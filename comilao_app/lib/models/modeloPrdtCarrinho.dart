import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comilaoapp/models/modeloAdicionais.dart';
import 'package:comilaoapp/models/modeloProduto.dart';

class ModeloPrdtCarrinho {
  String cid; //Id da coleção no firebase
  String produtoId; //Id do produto
  String adicionaisId;

  int quantidade;
  String observacao;

  ModeloProduto modeloProduto;
  ModeloAdicionais modeloAdicionais;

  ModeloPrdtCarrinho();

  ModeloPrdtCarrinho.fromMap(DocumentSnapshot document) {
    cid = document.documentID;
    produtoId = document.data['produtoId'];
    quantidade = document.data['quantidade'];
    observacao = document.data['observacao'];
    adicionaisId = document.data['adicionaisID'];
  }

  Map<String, dynamic> toMap() {
    return {
      'produtoId': produtoId,
      'quantidade': quantidade,
      'observacao': observacao,
      'produto': modeloProduto.toResumedMap(),
      //'adicionais': modeloAdicionais.toResumedMap()
    };
  }
}
