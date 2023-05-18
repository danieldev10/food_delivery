
import 'package:food_delivery/modals/Toppings.dart';
import 'package:hive/hive.dart';

part 'CartItems.g.dart';

@HiveType(typeId: 1)
class CartITems{

  @HiveField(0)
  String itemQty;
  @HiveField(1)
  String itemName;
  @HiveField(2)
  String itemTotalPrice;
  @HiveField(3)
  String image;
  @HiveField(4)
  List<Toppings> toppings = List();
  @HiveField(5)
  String itemAmt;
  @HiveField(6)
  String itemId;



  CartITems();


  CartITems.constructor(this.itemQty, this.itemName, this.itemTotalPrice, this.image,
      this.toppings, this.itemAmt, this.itemId);

  Future<bool> addToCart(CartITems cartITems) async{
    bool chk = false;
    await Hive.openBox('cart');
    final cartBox = Hive.box('cart');
    await cartBox.add(cartITems).then((value){
      chk = true;
    });
    return chk;
  }

  deleteDatabase() async{
    await Hive.openBox('cart');
    final cartBox = Hive.box('cart');
    await cartBox.deleteFromDisk();
  }

  Future<bool> removeFromCart(String x) async{
    bool chk = true;
    await Hive.openBox('cart');
    final favBox = Hive.box('cart');
    for(int i=0; i<favBox.length; i++){
      final item = favBox.getAt(i) as CartITems;
      if(x == item.itemId){
        chk = false;
        await favBox.deleteAt(i);
        print('Item removed');
        break;
      }
    }
    return chk;
  }

  Future<List<CartITems>> readingCart() async{
    List<CartITems> list = List();
    await Hive.openBox('cart');
    final favBox = Hive.box('cart');
    for(int i=0; i<favBox.length; i++){
      final item = favBox.getAt(i) as CartITems;
      list.add(CartITems.constructor(item.itemQty, item.itemName, item.itemTotalPrice, item.image, item.toppings,item.itemAmt,item.itemId));
    }
    return list;
  }

}