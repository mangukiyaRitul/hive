import 'package:hive/hive.dart';

part 'hive_adepter.g.dart'; // Generated Hive TypeAdapter

@HiveType(typeId: 0)
class Person{
  Person({
    required this.name,
    required this.age,
});
  @HiveField(0)
  late String name;

  @HiveField(1)
  late int age;

}