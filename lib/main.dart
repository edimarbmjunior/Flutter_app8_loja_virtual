import 'package:app8lojavirtual/model/carrinho_model.dart';
import 'package:app8lojavirtual/model/usuario_model.dart';
import 'package:app8lojavirtual/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UsuarioModel>( // O usuario não tem acesso ao carrinho da sessão
        model: UsuarioModel(),
        child: ScopedModelDescendant<UsuarioModel>( // Dessa forma caso o usuario seja trocado, "refaz" por completo o app
          builder: (context, child, model){
            return ScopedModel<CarrinhoModel>( // Assim é possível que o carrinho tenha acesso ao usuario da sessão
              model: CarrinhoModel(model),
              child: MaterialApp(
                title: "Flutter1s Clouthing",
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                    primaryColor: Color.fromARGB(255, 4, 125, 141)
                ),
                debugShowCheckedModeBanner: false,
                home: HomeScreen(),
              ),
            );
          },
        ),
    );
  }
}
