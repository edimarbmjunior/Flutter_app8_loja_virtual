import 'package:app8lojavirtual/model/carrinho_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DescontoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
            "Cupom de desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom"
              ),
              initialValue: CarrinhoModel.of(context).cupomDesconto ?? "",
              onFieldSubmitted: (text){
                Firestore.instance.collection("cupons").document(text).get().then(
                    (docCupom){
                      if(docCupom.data != null){
                        CarrinhoModel.of(context).setCupom(text, docCupom.data["porcento"]);
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Desconto de ${docCupom.data["porcento"]}% aplicado!"),
                            backgroundColor: Theme.of(context).primaryColor,
                          )
                        );
                      }else{
                        CarrinhoModel.of(context).setCupom(null, 0);
                        Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Cupom não existe!"),
                              backgroundColor: Colors.redAccent,
                            )
                        );
                      }
                    }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
