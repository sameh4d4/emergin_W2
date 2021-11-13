import 'package:flutter/material.dart';
import 'package:week2/class/recipe.dart';

class AddRecipe extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
      return _AddRecipeState();
    }
}



class _AddRecipeState extends State<AddRecipe> {
  late TextEditingController _recipe_name_cont;
  late TextEditingController _recipe_desc_cont;
  late TextEditingController _recipe_photo_cont;
  late int _charleft;
  late String _recipe_category;

  @override
  void initState() {
    super.initState();
    _recipe_name_cont = TextEditingController();
    _recipe_name_cont.text = "your food name";
    _recipe_photo_cont = TextEditingController();
    _recipe_photo_cont.text = "";
    _recipe_desc_cont = TextEditingController();
    _recipe_desc_cont.text = "Recipe of ...";
    _charleft = 200 - _recipe_desc_cont.text.length;
    _recipe_category="Traditional";
  }

  Color getButtonColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
              appBar: AppBar(
                  title: Text('Add Recipe'),
              ),
              body: SingleChildScrollView( 
                  child:Column(
                    children: [
                      TextField(
                          controller: _recipe_name_cont,
                          onChanged: (v) {
                            print(_recipe_name_cont.text);
                          }
                      ),
                      TextField(
                        controller: _recipe_desc_cont,
                        onChanged: (v) {
                          setState(() {
                            _charleft=200-v.length;
                          });
                        },
                        keyboardType: TextInputType.multiline,
                        minLines: 4,
                        maxLines: null,
                      ),
                      Text("char left : " + _charleft.toString()),
                      TextField(
                        controller: _recipe_photo_cont,
                        onSubmitted: (v) {
                          setState(() {});
                        },
                      ),
                      Image.network(
                        _recipe_photo_cont.text,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return const Text('');
                        },
                      ),
                      DropdownButton(
                          value: _recipe_category,
                          items: [
                            DropdownMenuItem(
                              child: Text("Traditional"),
                              value: "Traditional",
                            ),
                            DropdownMenuItem(
                              child: Text("Japannese"),
                              value: "Japannese",
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _recipe_category = value.toString();
                            });
                            print(_recipe_category);
                          }
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5),
                          backgroundColor:
                          MaterialStateProperty.resolveWith(getButtonColor),
                        ),
                        onPressed: () {
                          recipes.add(Recipe(
                            id: recipes.length + 1,
                            name: _recipe_name_cont.text,
                            desc: _recipe_desc_cont.text,
                            photo: _recipe_photo_cont.text,
                            cat: _recipe_category
                          ));
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text('Add Recipe'),
                              content: Text('Recipe successfully added'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'OK');
                                    setState(() {
                                      _recipe_name_cont.text = "your food name";
                                      _recipe_desc_cont.text = "Recipe of ...";
                                      _recipe_photo_cont.text = "";
                                    });
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            )
                          );
                        },
                        child: Text('SUBMIT')
                      ),
                  ],
                )
              )
          );
    }
}