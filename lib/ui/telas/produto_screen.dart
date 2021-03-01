import 'package:app8lojavirtual/dados/carrinho_produto.dart';
import 'package:app8lojavirtual/dados/produto_dados.dart';
import 'package:app8lojavirtual/model/carrinho_model.dart';
import 'package:app8lojavirtual/model/usuario_model.dart';
import 'package:app8lojavirtual/ui/login_screen.dart';
import 'package:app8lojavirtual/ui/telas/carrinho_screen.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class ProdutoScreen extends StatefulWidget {

  final ProdutoDados produto;

  ProdutoScreen(this.produto);

  @override
  _ProdutoScreenState createState() => _ProdutoScreenState(produto);
}

class _ProdutoScreenState extends State<ProdutoScreen> {

  int qtde=0;
  final ProdutoDados produto;
  _ProdutoScreenState(this.produto);
  String size;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    // widget.produto;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(produto.titulo),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: produto.imagens.map((url){
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  produto.titulo,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${produto.preco.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(
                  height: 35.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.48
                    ),
                    children: produto.tamanhos.map((tamanho){
                      return GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(1.0)),
                            border: Border.all(
                              color: (null!=size && tamanho == size) ? primaryColor : Colors.grey[500],
                              width: 3.0
                            )
                          ),
                          width: 50.0,
                          alignment: Alignment.center,
                          child: Text(
                            tamanho
                          ),
                        ),
                        onTap: (){
                          setState(() {
                            size = tamanho;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                /*SizedBox(height: 16.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: RaisedButton(
                        child: Text(
                          "-",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          if(qtde>0){
                            setState(() {
                              qtde -= 1;
                              validaQtdeProtudo();
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    Flexible(
                      flex: 1,
                      child: Text(
                        qtde<=0 ?
                        "Quantidade"
                            :
                        qtde.toString()
                        ,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    Flexible(
                      flex: 1,
                      child: RaisedButton(
                        child: Text(
                          "+",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          if(qtde>=0){
                            setState(() {
                              qtde += 1;
                              validaQtdeProtudo();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),*/
                SizedBox(height: 16.0,),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: size!=null? (){
                      if(UsuarioModel.of(context).isLoggedIn()){// uma forma de verificar se o usuario está na sessão(contexto)
                        if(validaQtdeProtudo()){
                          CarrinhoProduto carrinhoProduto = CarrinhoProduto();
                          carrinhoProduto.tamanhoProduto = size;
                          carrinhoProduto.qtdeItens = 1;
                          carrinhoProduto.produtoId = produto.id;
                          carrinhoProduto.categoriaProduto = produto.categoria;
                          carrinhoProduto.produtoDados = produto;

                          CarrinhoModel.of(context).adicionaItem(carrinhoProduto);

                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => CarrinhoScreen())
                          );
                        }
                      }else{
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginScreen())
                        );
                      }
                    } : null,
                    child: Text(
                      UsuarioModel.of(context).isLoggedIn() ?
                        "Adicionar ao carrinho"
                          :
                        "Entre para comprar",
                      style: TextStyle(
                        fontSize: 18.0
                      ),
                    ),
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0,),
                Text(
                  "Descrição",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  produto.descricao,
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool validaQtdeProtudo(){
    if(produto.qtde < qtde){
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Não possuimos no estoque essa quantidade!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          )
      );
      return false;
    }
    if(qtde < 0){
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Quantidade inválida!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          )
      );
      return false;
    }
    return true;
  }
}