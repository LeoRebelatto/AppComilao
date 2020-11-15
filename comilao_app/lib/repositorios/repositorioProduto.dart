import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comilaoapp/models/modeloProduto.dart';

class RepositorioProduto{
  CollectionReference _collection = Firestore.instance.collection('produto');

  void add(ModeloProduto modeloProduto) => _collection.add(modeloProduto.toMap());

  void update(String documentId, ModeloProduto modeloProduto) =>
      _collection.document(documentId).updateData(modeloProduto.toMap());

  void delete(String documentId) => _collection.document(documentId).delete();

  Stream<List<ModeloProduto>> listarProdutos(String tipo) {
    return _collection.snapshots().map((query) {
      var aux = query.documents
        .map<ModeloProduto>((document) => ModeloProduto.fromMap(document))
        .toList().where((i)=>i.tipo==tipo).toList();
      aux.sort((x,y)=>x.nome.compareTo(y.nome));
      return aux;
    });
  }

  Stream<List<String>> listarCategorias() {
    return _collection.snapshots().map((query) {
      var aux = query.documents
        .map<ModeloProduto>((document) => ModeloProduto.fromMap(document))
        .map<String>((f)=>f.tipo)
        .toSet()
        .toList();
      aux.sort((x,y)=>-1* x.compareTo(y));
      return aux;
    });
  }

  Stream<int> buscarIndexCategoria(String categoria) {
    return _collection.snapshots().map((query) {
      var aux = query.documents
          .map<ModeloProduto>((document) => ModeloProduto.fromMap(document))
          .map<String>((f)=>f.tipo)
          .toList();
      aux.sort((x,y)=>-1* x.compareTo(y));
      return aux.indexOf(categoria);
    });
  }
}
