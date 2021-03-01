import 'package:app8lojavirtual/dados/produto_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarrinhoProduto{

  String cId;
  String categoriaProduto;
  String produtoId;
  int qtdeItens;
  String tamanhoProduto;

  ProdutoDados produtoDados;

  CarrinhoProduto();

  CarrinhoProduto.fromDocument(DocumentSnapshot documento){
    cId = documento.documentID;
    categoriaProduto = documento.data["categoriaProduto"];
    produtoId = documento.data["produtoId"];
    qtdeItens = documento.data["qtdeItens"];
    tamanhoProduto = documento.data["tamanhoProduto"];
  }

  Map<String, dynamic> toMap(){
    return {
      "categoriaProduto": categoriaProduto,
      "produtoId": produtoId,
      "qtdeItens": qtdeItens,
      "tamanhoProduto": tamanhoProduto,
      "produtoDados": produtoDados.toResumeMap()
    };
  }

  @override
  String toString() {
    return "id:" + cId + " - Categoria:" + categoriaProduto + " - identificador:" + produtoId + " - quantidade:" + qtdeItens.toString() + " - tamanho:" + tamanhoProduto;
  }
}