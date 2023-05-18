class OrderItemDetails {
  String success;
  Order order;

  OrderItemDetails({this.success, this.order});

  OrderItemDetails.fromJson(Map<String, dynamic> json) {
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
  String orderAmount;
  String payment;
  String date;
  String address;
  String customerName;
  String phone;
  String latitude;
  String longitude;
  String deliveryCharges;
  Null tax;
  List<ItemName> itemName;

  Order(
      {this.orderAmount,
        this.payment,
        this.date,
        this.address,
        this.customerName,
        this.phone,
        this.latitude,
        this.longitude,
        this.deliveryCharges,
        this.tax,
        this.itemName});

  Order.fromJson(Map<String, dynamic> json) {
    orderAmount = json['order_amount'];
    payment = json['payment'];
    date = json['date'];
    address = json['address'];
    customerName = json['customer_name'];
    phone = json['phone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deliveryCharges = json['delivery_charges'];
    tax = json['tax'];
    if (json['item_name'] != null) {
      itemName = new List<ItemName>();
      json['item_name'].forEach((v) {
        itemName.add(new ItemName.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_amount'] = this.orderAmount;
    data['payment'] = this.payment;
    data['date'] = this.date;
    data['address'] = this.address;
    data['customer_name'] = this.customerName;
    data['phone'] = this.phone;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['delivery_charges'] = this.deliveryCharges;
    data['tax'] = this.tax;
    if (this.itemName != null) {
      data['item_name'] = this.itemName.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemName {
  String name;
  String description;
  int qty;
  String amount;
  Null size;
  String ingredientsId;

  ItemName(
      {this.name,
        this.description,
        this.qty,
        this.amount,
        this.size,
        this.ingredientsId});

  ItemName.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    qty = json['qty'];
    amount = json['amount'];
    size = json['size'];
    ingredientsId = json['ingredients_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['qty'] = this.qty;
    data['amount'] = this.amount;
    data['size'] = this.size;
    data['ingredients_id'] = this.ingredientsId;
    return data;
  }
}
