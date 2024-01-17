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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  TextEditingController Name =TextEditingController();
  TextEditingController Number =TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                TextFormField(
                  controller: Name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: Number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: () {
              setState(() {
                boxpersopn.put('key_${Name.text}',Person(name:Name.text,age: int.parse(Number.text) ),);
              });
                }, child: Text("Save")),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: boxpersopn.length,
                    itemBuilder: (context, index) {
                      Person person = boxpersopn.getAt(index);
                    return ListTile(
                      onTap: () {
                        setState(() {
                          boxpersopn.putAt(index, Person(name: Name.text, age: int.parse(Number.text)));
                        });
                        },

                      title: Text("Name : ${person.name}"),
                      subtitle: Text("Age : ${person.age}"),
                      trailing:  IconButton(onPressed: (){
                        setState(() {
                          boxpersopn.deleteAt(index);
                        });
                      }, icon: Icon(Icons.delete)),
                    );
                  },),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(50),
              backgroundColor: Colors.teal,
              shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: (){
          setState(() {
            boxpersopn.clear();
          });
        }, child: Text("Clear All",style: TextStyle(color: Colors.white),)),
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
