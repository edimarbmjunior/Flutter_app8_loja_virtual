import 'package:app8lojavirtual/ui/tabs/home_tab.dart';
import 'package:app8lojavirtual/ui/tabs/loja_tab.dart';
import 'package:app8lojavirtual/ui/tabs/ordem_tab.dart';
import 'package:app8lojavirtual/ui/tabs/produtos_tab.dart';
import 'package:app8lojavirtual/ui/widgets/carrinho_button.dart';
import 'package:app8lojavirtual/ui/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CarrinhoButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProdutosTab(),
          floatingActionButton: CarrinhoButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
          ),
          body: LojasTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OrdemTab(),
          drawer: CustomDrawer(_pageController),
        ),
      ],
    );
  }
}
