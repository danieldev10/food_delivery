
import 'package:hive/hive.dart';

part 'Toppings.g.dart';

@HiveType(typeId: 3)
class Toppings{
  String title;
  @HiveField(0)
  String id;
  @HiveField(1)
  String top_cat_id;
  @HiveField(2)
  String toppingName;
  @HiveField(3)
  String toppingPrice;

  Toppings(this.id,this.top_cat_id,this.toppingName, this.toppingPrice);

  Toppings.title(this.title);

  Map<String, dynamic> toJson() => {
    'id' : id,
    'top_cat_id' :top_cat_id,
    'name' : toppingName,
    'price' : toppingPrice,
  };

}