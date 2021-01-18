import 'package:app8lojavirtual/ui/widgets/carrinho_screen.dart';
import 'package:flutter/material.dart';

class CarrinhoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.shopping_cart, color: Colors.white,),
      onPressed: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CarrinhoScreen())
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
