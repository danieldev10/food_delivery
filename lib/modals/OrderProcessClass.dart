
class OrderProcessClass {

  String success;
  List<OrderDetails> orderDetails;

  OrderProcessClass({this.success, this.orderDetails});

  OrderProcessClass.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['order_details'] != null) {
      orderDetails = new List<OrderDetails>();
      json['order_details'].forEach((v) {
        orderDetails.add(new OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
  int itemOrder;
  String address;
  String contact;
  String totalPrice;
  String orderStatus;
  String placeStatus;
  String orderPlacedDate;
  String preparingStatus;
  String preparingDateTime;
  String dispatchedStatus;
  String dispatchedDateTime;
  String deliveredDateTime;
  String deliveredStatus;
  String cancelDateTime;
  String deliveryCharges;
  String tax;
  String deliveryMode;
  List<Menu> menu;

  OrderDetails(
      {this.itemOrder,
        this.address,
        this.contact,
        this.totalPrice,
        this.orderStatus,
        this.placeStatus,
        this.orderPlacedDate,
        this.preparingStatus,
        this.preparingDateTime,
        this.dispatchedStatus,
        this.dispatchedDateTime,
        this.deliveredDateTime,
        this.deliveredStatus,
        this.cancelDateTime,
        this.deliveryCharges,
        this.tax,
        this.deliveryMode,
        this.menu});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    itemOrder = json['item_order'];
    address = json['address'];
    contact = json['contact'];
    totalPrice = json['total_price'];
    orderStatus = json['order_status'];
    placeStatus = json['place_status'];
    orderPlacedDate = json['order_placed_date'];
    preparingStatus = json['preparing_status'];
    preparingDateTime = json['preparing_date_time'];
    dispatchedStatus = json['dispatched_status'];
    dispatchedDateTime = json['dispatched_date_time'];
    deliveredDateTime = json['delivered_date_time'];
    deliveredStatus = json['delivered_status'];
    cancelDateTime = json['cancel_date_time'];
    deliveryCharges = json['delivery_charges'];
    tax = json['tax'];
    deliveryMode = json['delivery_mode'];
    if (json['menu'] != null) {
      menu = new List<Menu>();
      json['menu'].forEach((v) {
        menu.add(new Menu.fromJson(v));
      });
    }

    print(address);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_order'] = this.itemOrder;
    data['address'] = this.address;
    data['contact'] = this.contact;
    data['total_price'] = this.totalPrice;
    data['order_status'] = this.orderStatus;
    data['place_status'] = this.placeStatus;
    data['order_placed_date'] = this.orderPlacedDate;
    data['preparing_status'] = this.preparingStatus;
    data['preparing_date_time'] = this.preparingDateTime;
    data['dispatched_status'] = this.dispatchedStatus;
    data['dispatched_date_time'] = this.dispatchedDateTime;
    data['delivered_date_time'] = this.deliveredDateTime;
    data['delivered_status'] = this.deliveredStatus;
    data['cancel_date_time'] = this.cancelDateTime;
    data['delivery_charges'] = this.deliveryCharges;
    data['tax'] = this.tax;
    data['delivery_mode'] = this.deliveryMode;
    if (this.menu != null) {
      data['menu'] = this.menu.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Menu {
  String itemId;
  String itemName;
  String itemQty;
  String itemAmt;
  String itemTotalPrice;
  List<Topping> topping;

  Menu(
      {this.itemId,
        this.itemName,
        this.itemQty,
        this.itemAmt,
        this.itemTotalPrice,
        this.topping});

  Menu.fromJson(Map<String, dynamic> json) {
    itemId = json['ItemId'];
    itemName = json['ItemName'];
    itemQty = json['ItemQty'];
    itemAmt = json['ItemAmt'];
    itemTotalPrice = json['ItemTotalPrice'];
    if (json['Topping'] != null) {
      topping = new List<Topping>();
      json['Topping'].forEach((v) {
        topping.add(new Topping.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemId'] = this.itemId;
    data['ItemName'] = this.itemName;
    data['ItemQty'] = this.itemQty;
    data['ItemAmt'] = this.itemAmt;
    data['ItemTotalPrice'] = this.itemTotalPrice;
    if (this.topping != null) {
      data['Topping'] = this.topping.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Topping {
  String id;
  String topCatId;
  String name;
  String price;

  Topping({this.id, this.topCatId, this.name, this.price});

  Topping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topCatId = json['top_cat_id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['top_cat_id'] = this.topCatId;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}
