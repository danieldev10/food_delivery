
import 'package:hive/hive.dart';

part 'Favourite.g.dart';

@HiveType(typeId: 0)
class Favourites{

  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String price;
  @HiveField(3)
  String image;
  @HiveField(4)
  String description;

  Favourites(){
    Hive.openBox('favourites');
  }


  Favourites.constuctor(this.id, this.name, this.price, this.image, this.description);

  Future<bool> addToDataBase(Favourites fav) async{
    bool chk = false;
    final favBox = Hive.box('favourites');
    await favBox.add(fav).then((value){
      chk = true;
    });
    return chk;
  }

  Future<List<Favourites>> readingDatabase() async{
    List<Favourites> list = List();
    await Hive.openBox('favourites');
    final favBox = Hive.box('favourites');
     for(int i=0; i<favBox.length; i++){
       final item = favBox.getAt(i) as Favourites;
       list.add(Favourites.constuctor(item.id, item.name, item.price,item.image,item.description));
     }
    return list;
  }

  Future<bool> chkIfAlreadyInDatabase(int x) async{
    bool chk = false;
    await Hive.openBox('favourites');
    final favBox = Hive.box('favourites');
     for(int i=0; i<favBox.length; i++){
       final item = favBox.getAt(i) as Favourites;
       if(x == item.id){
         chk = true;
         print('Item available');
         break;
       }
     }
    return chk;
  }

  Future<bool> removeFromFavourites(int x) async{
    bool chk = true;
    await Hive.openBox('favourites');
    final favBox = Hive.box('favourites');
     for(int i=0; i<favBox.length; i++){
       final item = favBox.getAt(i) as Favourites;
       if(x == item.id){
         chk = false;
         await favBox.deleteAt(i);
         print('Item removed');
         break;
       }
     }
    return chk;
  }

  removeFromDatabase(){
    final favBox = Hive.box('favourites');
  }

}