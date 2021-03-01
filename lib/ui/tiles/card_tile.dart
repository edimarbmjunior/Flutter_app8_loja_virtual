import 'package:app8lojavirtual/dados/carrinho_produto.dart';
import 'package:app8lojavirtual/dados/produto_dados.dart';
import 'package:app8lojavirtual/model/carrinho_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {

  final CarrinhoProduto carrinhoProduto;
  final CarrinhoProduto carrinhoProdutoFinal;

  CardTile(this.carrinhoProduto, this.carrinhoProdutoFinal);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      if(carrinhoProduto == carrinhoProdutoFinal){
        CarrinhoModel.of(context).updatePreco();//Isso é para atualizar os precos no card de resumo do pedido quando carregar os produtos do carrinho
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              carrinhoProduto.produtoDados.imagens[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    carrinhoProduto.produtoDados.titulo,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    "Tamanho: ${carrinhoProduto.tamanhoProduto}",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "R\$ ${carrinhoProduto.produtoDados.preco.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.remove),
                          color: Theme.of(context).primaryColor,
                          onPressed: carrinhoProduto.qtdeItens > 1 ?
                              (){
                                CarrinhoModel.of(context).decProduto(carrinhoProduto);
                              }
                              :
                              null,
                      ),
                      Text(carrinhoProduto.qtdeItens.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: carrinhoProduto.qtdeItens > 0 ?
                            (){
                              CarrinhoModel.of(context).incProduto(carrinhoProduto);
                            }
                            :
                            null,
                      ),
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed: carrinhoProduto.qtdeItens > 0 ?
                            (){
                              CarrinhoModel.of(context).removeItem(carrinhoProduto);
                            }
                            :
                            null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget _verificaMontagem(ProdutoDados produtoDados){
      if(null == produtoDados){
        return FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection("produtos").document(carrinhoProduto.categoriaProduto)
              .collection("itens").document(carrinhoProduto.produtoId).get(),
          builder: (context, snapshot){
            switch(snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Container(
                  height: 70.0,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              default:
                carrinhoProduto.produtoDados = ProdutoDados.fromDocument(snapshot.data);
                return _buildContent();
            }
          },
        );
      }else{
        return _buildContent();
      }
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: _verificaMontagem(carrinhoProduto.produtoDados),
    );
  }
}
