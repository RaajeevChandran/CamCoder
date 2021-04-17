import 'package:hive/hive.dart';
part 'snippet.g.dart';
@HiveType(typeId:1)
class Snippet {
  Snippet({this.imageURL, this.name, this.code});

  @HiveField(0)
  String imageURL;
  @HiveField(1)
  String name;
  @HiveField(2)
  String code;

  @override
  String toString(){
    return imageURL;
  }
  
}
