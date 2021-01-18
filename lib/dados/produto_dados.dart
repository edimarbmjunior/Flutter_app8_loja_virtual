import 'package:cloud_firestore/cloud_firestore.dart';

class ProdutoDados{

  String categoria;
  String id;
  String titulo;
  String descricao;
  double preco;
  int qtde;
  List imagens;
  List tamanhos;

  ProdutoDados.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    titulo = snapshot.data["titulo"];
    descricao = snapshot.data["descricao"];
    preco = snapshot.data["preco"] + 0.0;
    imagens = snapshot.data["imagens"];
    tamanhos = snapshot.data["tamanhos"];
    qtde = snapshot.data["qtde"];
  }

  Map<String, dynamic> toResumeMap(){
    return {
      "titulo": titulo,
      "descricao": descricao,
      "preco": preco
    };
  }
}