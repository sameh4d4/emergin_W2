import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'ItemBasket.dart';
import '../class/recipe.dart';

class Basket extends StatefulWidget {
  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  @override
  Widget build(BuildContext context) {
    recipes.add(new Recipe(id: 1,
        name: ' Tradisional Talam Gula Merah',
        photo: 'https://assets.resepedia.id/assets/images/2021/07/1705957323322829-kue-talam-gula-merah-640.jpeg',
        desc: 'Resep dan cara membuat  Tradisional talam gula merah yang super lembut, manis legit, dan gurih.',
        cat: ' Traditional'
    ));
    recipes.add(new Recipe(id: 2,
        name: 'Cenil Singkong',
        photo: 'https://assets.resepedia.id/assets/images/2021/07/1705908963394190-cenil-singkong-640.jpeg',
        desc: 'Resep dan cara membuat cenil singkong sederhana yang super kenyal, empuk, dan enak.',
        cat:' Tradisional'
    ));
    recipes.add(new Recipe(id: 3,
        name: 'Pukis Bangka',
        photo: 'https://assets.resepedia.id/assets/images/2021/07/1705907506606570-pukis-bangka-640.jpeg',
        desc: 'Resep dan cara membuat pukis bangka yang super kenyal, empuk, dan aromanya harum.',cat: ' Tradisional'));
    recipes.add(new Recipe(id: 4,
        name: 'Buka Pandan',
        photo: 'https://assets.resepedia.id/assets/images/2021/07/1704999203399338-buko-pandan-640.jpg',
        desc: 'Resep dan cara membuat buko pandan, dessert khas filipina yang segar, lezat, dan mengenyangkan.',cat: ' Tradisional'));

    List<Widget> widRecipes() {
      List<Widget> temp = [];
      int i = 0;
      while (i < recipes.length) {
        int idResep=recipes[i].id;
        Widget w = Card(
            child:
              Column(children: [
                Text(recipes[i].name),
                Image.network(recipes[i].photo),
                Text(recipes[i].desc),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(5),
                  ),
                  onPressed: () {
                    recipes.removeWhere((element) =>  element.id==idResep);
                    setState(() {});
                  },
                  child: Text('HAPUS')
                ),
                Divider(height: 30,)
              ],
            )
        );
        temp.add(w);
        i++;
      }
      return temp;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Basket'),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
            Text("Your basket "),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: widRecipes(),
            ),
            Divider(
              height: 100,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("This is Basket"),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ItemBasket(1, 10))
                      );
                    },
                    child: Text("Item 1")
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ItemBasket(2, 14))
                      );
                    },
                    child: Text("Item 2")
                ),
              ],
            ),
          ]
        )
      ),
    );
  }
}