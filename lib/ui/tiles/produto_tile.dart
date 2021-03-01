import 'package:app8lojavirtual/dados/produto_dados.dart';
import 'package:app8lojavirtual/ui/telas/produto_screen.dart';
import 'package:flutter/material.dart';

class ProdutoTile extends StatelessWidget {

  final String tipo;
  final ProdutoDados produto;
  ProdutoTile(this.tipo, this.produto);

  @override
  Widget build(BuildContext context) {
    return InkWell(// habilita a ação de apertar(selecionar) na tela
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProdutoScreen(produto))
        );
      },
      child: tipo == "grid" ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AspectRatio(// Defina o formato, dividindo o tamanho pela largura
              aspectRatio: 0.8,
              child: Image.network(
                produto.imagens[0],
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(6.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      produto.titulo,
                      style: TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      "R\$ ${produto.preco.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
        : Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Image.network(
              produto.imagens[0],
              fit: BoxFit.cover,
              height: 250.0,
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    produto.titulo,
                    style: TextStyle(
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    "R\$ ${produto.preco.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
