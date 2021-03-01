import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrdemTile extends StatelessWidget {

  final String ordemId;

  OrdemTile(this.ordemId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection("ordemPedido").document(ordemId).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {

              int status = snapshot.data["status"];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Código do pedido: $ordemId",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0,),
                  Text(
                    _buildProdutoText(snapshot.data)
                  ),
                  SizedBox(height: 4.0,),
                  Text(
                    "Status do pedido: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildCircle("1", "Preparação", status, 1),
                      Container(
                        height: 1.0,
                        width: 40.0,
                        color: Colors.grey[500],
                      ),
                      _buildCircle("2", "Transporte", status, 2),
                      Container(
                        height: 1.0,
                        width: 40.0,
                        color: Colors.grey[500],
                      ),
                      _buildCircle("3", "Entrega", status, 3),
                    ],
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String _buildProdutoText(DocumentSnapshot snapshot){
    String text = "Descrição: \n";
    for(LinkedHashMap p in snapshot.data["produtos"]){
      text += "${p["qtdeItens"]} x ${p["produtoDados"]["titulo"]} (R\$ ${p["produtoDados"]["preco"].toStringAsFixed(2)})\n";
    }
    text += "Total : R\$ ${snapshot.data["totalPedido"].toStringAsFixed(2)}";
    return text;
  }
  
  Widget _buildCircle(String titulo, String subTitulo, int status, int thisStatus){
    Color backColor;
    Widget child;
    
    if(status < thisStatus){
      backColor = Colors.grey[500];
      child = Text(titulo, style: TextStyle(color: Colors.white),);
    } else {
      if ( status == thisStatus) {
        backColor = Colors.blue;
        child = Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Text(titulo, style: TextStyle(color: Colors.white),),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          ],
        );
      } else {
        if (status > thisStatus) {
          backColor = Colors.green;
          child = Icon((Icons.check), color: Colors.white,);
        }
      }
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subTitulo),
      ],
    );
  }
}
