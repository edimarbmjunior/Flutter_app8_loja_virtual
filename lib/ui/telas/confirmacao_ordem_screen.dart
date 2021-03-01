import 'package:flutter/material.dart';

class ConfirmacaoOrdemScreen extends StatelessWidget {

  final String ordemId;

  ConfirmacaoOrdemScreen(this.ordemId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido Realizado"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
              size: 80.0,
            ),
            Text(
              "Pedido realizado com sucesso!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
            ),
            Text("Código do pedido: $ordemId", style: TextStyle(fontSize: 16.0),)
          ],
        ),
      ),
    );
  }
}
