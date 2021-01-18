import 'package:app8lojavirtual/ui/tiles/categoria_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProdutosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("produtos").getDocuments(),
      builder: (context, snapshot){
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
                child: CircularProgressIndicator(),
            );
          default:
            var dividedTiles = ListTile
                .divideTiles(tiles: snapshot.data.documents.map((doc){
                                      return CategoriaTile(doc);
                                    }).toList(),
              color: Colors.blue
            ).toList();
            return ListView(
              children: dividedTiles,
            );
        }
      },
    );
  }
}
