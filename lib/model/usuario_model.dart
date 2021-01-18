import 'dart:async';

import 'package:app8lojavirtual/model/carrinho_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//Forma de usar atualização constantes de infromação do usuario
class UsuarioModel extends Model{
  //Usuario Atual
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  static UsuarioModel of(BuildContext context) => ScopedModel.of<UsuarioModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUsuario();
  }

  void signUp({@required Map<String, dynamic> userData, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}) async{
    isLoading = true;
    notifyListeners();
    
    _auth
      .createUserWithEmailAndPassword(email: userData["email"], password: pass)
      .then((user) async {
      firebaseUser = user;

        await _saveUserData(userData);

        onSuccess();
        isLoading = false;
        notifyListeners();
      })
      .catchError((erro){
        onFail();
        isLoading = false;
        notifyListeners();
      });
  }

  void signIn({@required String email, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}) async{
    isLoading = true;

    _auth
    .signInWithEmailAndPassword(email: email, password: pass)
    .then((user) async {
      firebaseUser = user;

      await _loadCurrentUsuario();

      onSuccess();
      isLoading = false;
      notifyListeners();
    })
    .catchError((erro){
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  void recoverPass(String email, VoidCallback onSuccess, Function onFail){
    isLoading = true;

    _auth.sendPasswordResetEmail(email: email)
        .then((value){
          onSuccess();
          isLoading = false;
          notifyListeners();
        })
        .catchError((erro){
          String errorMessage;
          switch(erro.code){
            case "ERROR_INVALID_EMAIL":
              errorMessage = "Email inválido";
              break;
            default:
              errorMessage=null;
          }
          onFail(errorMessage);
          notifyListeners();
          isLoading = false;
        }
    );
  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance.collection("usuarios").document(firebaseUser.uid).setData(userData);
  }

  Future<Null> _loadCurrentUsuario() async {
    if(firebaseUser == null){
      // ignore: unnecessary_statements
      firebaseUser == await _auth.currentUser();
    }
    if(firebaseUser != null){
      if(userData["nome"]==null){
        DocumentSnapshot docUsuario =
          await Firestore
              .instance
              .collection("usuarios")
              .document(firebaseUser.uid)
              .get();
        userData = docUsuario.data;
        notifyListeners();
      }
    }
  }
}