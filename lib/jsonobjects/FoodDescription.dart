
import 'package:food_delivery/modals/CartItems.dart';
import 'package:food_delivery/modals/Toppings.dart';

class FoodDescription{

  String itemId;
  String itemName;
  String itemQty;
  String itemAmt;
  String itemTotalPrice;
  List<Toppings> toppingsList;


  FoodDescription.defaultc();

  FoodDescription(this.itemId, this.itemName, this.itemQty, this.itemAmt,
      this.itemTotalPrice, this.toppingsList);
  List<FoodDescription> list = List();

  String jEncoder(List<CartITems> list){
    String x =
        '{"Order":[';
    for(int i=0; i<list.length; i++){
      x = x + '{"ItemId":"${list[i].itemId}","ItemName":"${list[i].itemName}","ItemQty":"${list[i].itemQty}","ItemAmt":"${list[i].itemAmt}","ItemTotalPrice":"${list[i].itemTotalPrice}","Topping":[';
      for(int j=0; j<list[i].toppings.length; j++){
        x = x + '{"id":"${list[i].toppings[j].id}","top_cat_id":"${list[i].toppings[j].top_cat_id}","name":"${list[i].toppings[j].toppingName}","price":"${list[i].toppings[j].toppingPrice}"}${j < list[i].toppings.length - 1 ? ',' :''}';
      }
      x = x + ']}${i<list.length-1 ? ',' : ''}';
    }
    x = x + ']}';
    print(x.replaceAll('"', '\\"'));
    return x;
  }
    //String y ='\"id\":\"1\",\"top_cat_id\":\"1\",\"name\":\"Thums up\",\"price\":\"12.00\"},{\"id\":\"5\",\"top_cat_id\":\"2\",\"name\":\"FRESH\",\"price\":\"15.00\"}]}]}';
  }

