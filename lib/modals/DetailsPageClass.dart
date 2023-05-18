
class DetailsPageClass {
  String success;
  Order order;

  DetailsPageClass({this.success, this.order});

  DetailsPageClass.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.order != null) {
      data['order'] = this.order.toJson();
    }
    return data;
  }
}

class Order {
  int id;
  int category;
  String description;
  String menuImage;
  String menuName;
  String price;
  String topping;
  String createdAt;
  String updatedAt;
  String isDeleted;
  String facebookShare;
  String twitterShare;

  Order(
      {this.id,
        this.category,
        this.description,
        this.menuImage,
        this.menuName,
        this.price,
        this.topping,
        this.createdAt,
        this.updatedAt,
        this.isDeleted,
        this.facebookShare,
        this.twitterShare});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    description = json['description'];
    menuImage = json['menu_image'];
    menuName = json['menu_name'];
    price = json['price'];
    topping = json['topping'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDeleted = json['is_deleted'];
    facebookShare = json['facebook_share'];
    twitterShare = json['twitter_share'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['description'] = this.description;
    data['menu_image'] = this.menuImage;
    data['menu_name'] = this.menuName;
    data['price'] = this.price;
    data['topping'] = this.topping;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_deleted'] = this.isDeleted;
    data['facebook_share'] = this.facebookShare;
    data['twitter_share'] = this.twitterShare;
    return data;
  }
}
