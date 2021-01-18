import 'package:app8lojavirtual/dados/produto_dados.dart';
import 'package:app8lojavirtual/ui/tiles/produto_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriaScreen extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoriaScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data["titulo"]),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.list),
                ),
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: Firestore
                .instance
                .collection("produtos")
                .document(snapshot.documentID)
                .collection("itens")
                .getDocuments(),
            builder: (context, snapshot){
              switch(snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: CircularProgressIndicator(),
                  );
                default:
                  return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      GridView.builder(
                        padding: EdgeInsets.all(4.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(//widget Em grade
                          crossAxisCount: 2,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 0.65
                        ),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index){
                          ProdutoDados data = ProdutoDados
                              .fromDocument(snapshot.data.documents[index]);
                          data.categoria = this.snapshot.documentID;
                          return ProdutoTile(
                              "grid",
                              data
                          );
                        },
                      ),
                      ListView.builder(
                        padding: EdgeInsets.all(4.0),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index){
                          ProdutoDados data = ProdutoDados
                              .fromDocument(snapshot.data.documents[index]);
                          data.categoria = this.snapshot.documentID;
                          return ProdutoTile(
                              "list",
                              data
                          );
                        },
                      ),
                    ],
                  );
              }
            },
          ),
        ),
    );
  }


}
