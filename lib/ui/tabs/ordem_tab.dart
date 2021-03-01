import 'package:app8lojavirtual/model/usuario_model.dart';
import 'package:app8lojavirtual/ui/login_screen.dart';
import 'package:app8lojavirtual/ui/tiles/ordem_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdemTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(UsuarioModel.of(context).isLoggedIn()){
      String uid= UsuarioModel.of(context).firebaseUser.uid;

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("usuarios").document(uid).collection("ordemPedido").getDocuments(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data.documents.map((doc)=> OrdemTile(doc.documentID)).toList().reversed.toList(),
            );
          }
        },
      );
    }else{
      return Container(
        padding: EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.view_list,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16.0,),
            Text(
              "Faça o login para acompanhar!",
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
    }
  }
}
