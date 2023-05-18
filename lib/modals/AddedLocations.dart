
import 'package:hive/hive.dart';

part 'AddedLocations.g.dart';

@HiveType(typeId: 4)
class AddedLocations{

  @HiveField(0)
  String type;
  @HiveField(1)
  String addressLine;
  @HiveField(2)
  String lat;
  @HiveField(3)
  String long;


  AddedLocations();

  AddedLocations.constructor(this.type, this.addressLine, this.lat, this.long);

  Future<bool> addToDataBase(AddedLocations loc) async{
    bool chk = false;
    await Hive.openBox('locations');
    final favBox = Hive.box('locations');
    await favBox.add(loc).then((value){
      chk = true;
    });
    return chk;
  }

  Future<List<AddedLocations>> readingDatabase() async{
    List<AddedLocations> list = List();
    await Hive.openBox('locations');
    final favBox = Hive.box('locations');
    for(int i=0; i<favBox.length; i++){
      final item = favBox.getAt(i) as AddedLocations;
      list.add(AddedLocations.constructor(item.type, item.addressLine, item.lat, item.long));
    }
    return list;
  }

  Future<bool> removeFromFavourites(String x) async{
    bool chk = true;
    await Hive.openBox('locations');
    final favBox = Hive.box('locations');
    for(int i=0; i<favBox.length; i++){
      final item = favBox.getAt(i) as AddedLocations;
      if(x == (item.lat+item.long)){
        chk = false;
        await favBox.deleteAt(i);
        print('Item removed');
        break;
      }
    }
    return chk;
  }

}