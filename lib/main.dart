import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'boxes.dart';
import 'hive_adepter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  boxpersopn = await Hive.openBox<Person>('personBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hive DataBase'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController  name = TextEditingController();
  TextEditingController number = TextEditingController();

  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(child: Text(widget.title)),
        ),
        body: Form(
          key: key,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: name,
                      validator: (namevalue) {
                        if(namevalue != null && namevalue.trim().isNotEmpty)
                          {
                            return null;
                          }else
                            {
                              return "Plass Enter Name";
                            }
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Name",
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: number,
                      validator: (value) {
                        if(value != null && value.isNotEmpty)
                          {
                            if( value.length != 3)
                            {
                              return null;
                            }
                            else
                            {
                              return "Pleas Enter Valid Age";
                            }
                          }
                        else
                          {
                            return "Enter Age";
                          }
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Age",
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromWidth(200),
                          backgroundColor: Colors.blue.shade800,
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if(key.currentState!.validate())
                            {
                              setState(() {
                                boxpersopn.put(
                                  'key_${name.text}',
                                  Person(
                                      name: name.text, age: int.parse(number.text)),
                                );
                              });
                            }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: boxpersopn.length,
                        itemBuilder: (context, index) {
                          Person person = boxpersopn.getAt(index);
                          return ListTile(
                            onTap: () {
                              setState(() {
                                boxpersopn.putAt(
                                    index,
                                    Person(
                                        name: name.text,
                                        age: int.parse(number.text)));
                              });
                            },
                            title: Text("Name : ${person.name}"),
                            subtitle: Text("Age : ${person.age}"),
                            trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    boxpersopn.deleteAt(index);
                                  });
                                },
                                icon: const Icon(Icons.delete)),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(50),
                backgroundColor: Colors.teal,
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                setState(() {
                  boxpersopn.clear();
                });
              },
              child: const Text(
                "Clear All",
                style: TextStyle(color: Colors.white),
              )),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
