import 'package:app8lojavirtual/dados/carrinho_produto.dart';
import 'package:app8lojavirtual/model/usuario_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoModel extends Model {

  UsuarioModel user;

  List<CarrinhoProduto> produtos = [];
  String cupomDesconto;
  int descontoPorcento = 0;

  bool isLoading = false;

  CarrinhoModel(this.user){
    if(user.isLoggedIn()){
      _loadCarrinhoItens();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _verificaCarrinho();
  }

  static CarrinhoModel of(BuildContext context) => ScopedModel.of<CarrinhoModel>(context);

  void adicionaItem(CarrinhoProduto carrinhoProduto){
    produtos.add(carrinhoProduto);

    Firestore.instance.collection("usuarios").document(user.firebaseUser.uid)
      .collection("carrinho").add(carrinhoProduto.toMap()).then((doc){
        carrinhoProduto.cId = doc.documentID;
      });
    notifyListeners();
  }

  void removeItem(CarrinhoProduto carrinhoProduto){
    Firestore.instance.collection("usuarios").document(user.firebaseUser.uid)
      .collection("carrinho").document(carrinhoProduto.cId).delete().then((doc){
        produtos.remove(carrinhoProduto);
        notifyListeners();
      });
  }

  void decProduto(CarrinhoProduto carrinhoProduto){
    carrinhoProduto.qtdeItens--;
    Firestore.instance.collection("usuarios").document(user.firebaseUser.uid).collection("carrinho")
      .document(carrinhoProduto.cId).updateData(carrinhoProduto.toMap()).then((doc){
      notifyListeners();
    });
  }

  void incProduto(CarrinhoProduto carrinhoProduto){
    carrinhoProduto.qtdeItens++;
    Firestore.instance.collection("usuarios").document(user.firebaseUser.uid).collection("carrinho")
        .document(carrinhoProduto.cId).updateData(carrinhoProduto.toMap()).then((doc){
      notifyListeners();
    });
  }

  Future<Null> _verificaCarrinho() async {
    if(user.firebaseUser!=null){
      _loadCarrinhoItens();
    }
  }

  void setCupom(String codCupom, int percent){
    this.cupomDesconto = codCupom;
    this.descontoPorcento = percent;
  }

  void _loadCarrinhoItens() async {
    QuerySnapshot query = await Firestore.instance.collection("usuarios").document(user.firebaseUser.uid).collection("carrinho")
      .getDocuments();

    produtos = [];
    produtos = query.documents.map((doc) => CarrinhoProduto.fromDocument(doc)).toList();
    notifyListeners();
  }

  void updatePreco(){
    notifyListeners();
  }

  double getProdutoPreco(){
    double preco = 0.0;
    for(CarrinhoProduto c in produtos){
      if(c.produtoDados != null){
        preco += c.qtdeItens * c.produtoDados.preco;
      }
    }

    return preco;
  }

  double getDescontoPreco(){
    return getProdutoPreco() * descontoPorcento / 100;
  }

  double getEntregaPreco(){
    return 9.99;
  }

  Future<String> finlizacaoPedido() async {
    if(produtos.length == 0) return null;
    isLoading = true;
    notifyListeners();

    double precoProdutos = getProdutoPreco();
    double precoEntrega = getEntregaPreco();
    double precoDesconto = getDescontoPreco();
    
    DocumentReference refOrder = await Firestore.instance.collection("ordemPedido").add({
      "clienteId": user.firebaseUser.uid,
      "produtos": produtos.map((carrinhoProduto)=> carrinhoProduto.toMap()).toList(),
      "precoEntrega": precoEntrega,
      "precoProdutos": precoProdutos,
      "precoDesconto": precoDesconto,
      "totalPedido": precoProdutos + precoEntrega - precoDesconto,
      "status": 1
    });

    await Firestore.instance.collection("usuarios").document(user.firebaseUser.uid)
      .collection("ordemPedido").document(refOrder.documentID).setData({
      "ordemPedidoId": refOrder.documentID
    });

    QuerySnapshot query = await Firestore.instance.collection("usuarios")
        .document(user.firebaseUser.uid)
        .collection("carrinho").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    produtos.clear();
    descontoPorcento=0;
    cupomDesconto=null;
    isLoading = false;
    notifyListeners();
    return refOrder.documentID;
  }
}
