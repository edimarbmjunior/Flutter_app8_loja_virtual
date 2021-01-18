import 'package:app8lojavirtual/model/carrinho_model.dart';
import 'package:app8lojavirtual/model/usuario_model.dart';
import 'package:app8lojavirtual/ui/login_screen.dart';
import 'package:app8lojavirtual/ui/tiles/card_tile.dart';
import 'package:app8lojavirtual/ui/widgets/desconto_card.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 15.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CarrinhoModel>(
              builder: (context, child, model){
                int p = model.produtos.length;
                return Text(
                  "${p ?? 0} ${p==1? "ITEN" : "ITENS"}",
                  style: TextStyle(fontSize: 15.5,),
                );
              },
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CarrinhoModel>(
        builder: (context, child, model){
          if(model.isLoading && UsuarioModel.of(context).isLoggedIn()){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if(!UsuarioModel.of(context).isLoggedIn()){
              return Container(
                padding: EdgeInsets.all(17.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.remove_shopping_cart,
                      size: 80.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 16.0,),
                    Text(
                      "Faça o login para adinionar produtos!",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.0,),
                    RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginScreen())
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              if(model.produtos == null || model.produtos.length == 0){
                return Center(
                  child: Text(
                    "Nenhum produto no carrinho",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return ListView(
                  children: <Widget>[
                    Column(
                      children: model.produtos.map((produto){
                        print("produto->" + produto.toString());
                        return CardTile(produto);
                      }).toList(),
                    ),
                    DescontoCard(),
                  ],
                );
              }
            }
          }
        },
      ),
    );
  }
}
