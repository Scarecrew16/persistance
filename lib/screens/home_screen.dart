import 'package:flutter/material.dart';
import 'package:persistance/helpers/database_helper.dart';
import 'package:persistance/screens/taken_picture_screen.dart';
import '../models/cat_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? catId;
  final textControllerRace = TextEditingController();
  final textControllerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SQLite example with cats'),
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              TextFormField(
                  controller: textControllerRace,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.view_comfortable),
                      labelText: "Input the race of the cat")),
              TextFormField(
                  controller: textControllerName,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.text_format_outlined),
                      labelText: "Input the name of the cat")),
              Center(
                child: (FutureBuilder<List<Cat>>(
                    future: DatabaseHelper.instance.getCats(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Cat>> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text("Loading..."),
                        ));
                      } else {
                        return snapshot.data!.isEmpty
                            ? Center(
                                child: Container(
                                    child: const Text("No cats in the list")))
                            : ListView(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: snapshot.data!.map((cat) {
                                  return Center(
                                    child: Card(
                                      color: catId == cat.id
                                          ? const Color.fromARGB(
                                              255, 164, 1, 185)
                                          : Colors.white24,
                                      child: ListTile(
                                        textColor: catId == cat.id
                                            ? Colors.deepPurple
                                            : Colors.deepOrange,
                                        title: Text(
                                            'Name: ${cat.name}|Race: ${cat.race}'),
                                        onLongPress: () {
                                          setState(() {
                                            DatabaseHelper.instance
                                                .delete(cat.id!);
                                          });
                                        },
                                        onTap: () {
                                          setState(() {
                                            if (catId == null) {
                                              textControllerName.text =
                                                  cat.name;
                                              textControllerRace.text =
                                                  cat.race;
                                              catId = cat.id;
                                            } else {
                                              textControllerName.clear();
                                              textControllerRace.clear();
                                              catId = null;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                }).toList());
                      }
                    })),
              )
            ],
          ),
        ),
        floatingActionButton: Column(children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () async {
              if (catId != null) {
                await DatabaseHelper.instance.update(Cat(
                    name: textControllerName.text,
                    race: textControllerRace.text,
                    id: catId));
              } else {
                DatabaseHelper.instance.add(Cat(
                    race: textControllerRace.text,
                    name: textControllerName.text));
              }
              setState(() {
                textControllerName.clear();
                textControllerRace.clear();
              });
            },
          ),
          const SizedBox(
            height: 15.0,
          ),
          FloatingActionButton(
            child: const Icon(Icons.camera),
            onPressed: () {
              final route = MaterialPageRoute(
                  builder: (context) => const TakenPictureScreen(
                        camera: firstCamera,
                      ));
              Navigator.push(context, route);
            },
          )
        ]));
  }
}
