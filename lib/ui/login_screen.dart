import 'package:app8lojavirtual/model/carrinho_model.dart';
import 'package:app8lojavirtual/model/usuario_model.dart';
import 'package:app8lojavirtual/ui/criar_conta_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context)=> CriarContaScreen())
              );
            },
            child: Text(
              "CRIAR CONTA",
              style: TextStyle(
                  fontSize: 15.0
              ),
            ),
            textColor: Colors.white,
          ),
        ],
      ),
      //Forma de usar atualização constantes de infromação do usuario
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
                SizedBox(
                  height: 16.0,
                ),
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
                SizedBox(height: 16.0,),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: (){
                      if(_emailController.text.isEmpty){
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Insira seu email para recuperação da senha!"),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 2),
                            )
                        );
                      } else {
                        model.recoverPass(_emailController.text, _onSuccessPass, _onFailPass);
                      }
                    },
                    child: Text(
                      "Esqueci minha senha",
                      textAlign: TextAlign.right,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
                SizedBox(height: 16.0,),
                RaisedButton(
                  child: Text(
                    "Entrar",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      model.signIn(
                          email: _emailController.text,
                          pass: _senhaController.text,
                          onSuccess: _onSuccess,
                          onFail: _onFail
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSuccess(){
    Navigator.of(context).pop();
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Error no preenchimento da senha/usuário!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
    );
  }

  void _onSuccessPass(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("E-mail Enviado"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _onFailPass(String msg){
    String texto = "Error no envio de email!";
    if(msg!=null){
      texto = msg;
    }
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(texto),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
