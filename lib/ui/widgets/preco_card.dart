import 'package:app8lojavirtual/model/carrinho_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PrecoCard extends StatelessWidget {

  final VoidCallback comprar;

  PrecoCard(this.comprar);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: ScopedModelDescendant<CarrinhoModel>(
          builder: (context, child, model){

            double preco = model.getProdutoPreco();
            double desconto = model.getDescontoPreco();
            double envioValor = model.getEntregaPreco();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Resumo do Pedido",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("SubTotal"),
                    Text("R\$ ${preco.toStringAsFixed(2)}")
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Desconto"),
                    Text("R\$ ${desconto.toStringAsFixed(2)}")
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Entrega"),
                    Text("R\$ ${envioValor.toStringAsFixed(2)}")
                  ],
                ),
                Divider(),
                SizedBox(height: 12.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                        "R\$ ${(preco + envioValor - desconto).toStringAsFixed(2)}",
                      style: TextStyle(color:  Theme.of(context).primaryColor, fontSize: 16.0),
                    )
                  ],
                ),
                SizedBox(height: 12.0,),
                RaisedButton(
                    child: Text("Finlizar Pedido"),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: comprar
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
