import 'package:app8lojavirtual/model/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class CriarContaScreen extends StatefulWidget {
  @override
  _CriarContaScreenState createState() => _CriarContaScreenState();
}

class _CriarContaScreenState extends State<CriarContaScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _enderecoController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UsuarioModel>(
        builder: (context, child, model){
          if(model.isLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(15.0),
              children: <Widget>[
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                      hintText: "Nome Completo"
                  ),
                  // ignore: missing_return
                  validator: (text){
                    if(text.isEmpty || text.length < 5) return "Nome inválido";
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: "E-mail"
                  ),
                  keyboardType: TextInputType.emailAddress,
                  // ignore: missing_return
                  validator: (text){
                    if(text.isEmpty || !text.contains("@")) return "E-mail inválido";
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _senhaController,
                  decoration: InputDecoration(
                      hintText: "Senha"
                  ),
                  obscureText: true,
                  // ignore: missing_return
                  validator: (text){
                    if(text.isEmpty || text.length<6) return "Senha inválida";
                  },
                ),
                SizedBox(height: 30.0,),
                TextFormField(
                  controller: _enderecoController,
                  decoration: InputDecoration(
                      hintText: "Endereço"
                  ),
                  keyboardType: TextInputType.text,
                  // ignore: missing_return
                  validator: (text){
                    if(text.isEmpty || text.length<6) return "Endereço inválida";
                  },
                ),
                SizedBox(height: 30.0,),
                MaterialButton(
                  onPressed: (){},
                  child: RaisedButton(
                    splashColor: Colors.red,
                    child: Text(
                      "   Criar   ",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        Map<String, dynamic> userData ={
                          "nome": _nomeController.text,
                          "email": _emailController.text,
                          "endereco": _enderecoController.text
                        };
                        model.signUp(
                            userData: userData,
                            pass: _senhaController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Usuário criado com sucesso"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Falha ao criar o usuário!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
    );
  }
}
