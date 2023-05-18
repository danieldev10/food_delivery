class DeliveryBoyOrders {
  String success;
  List<Order> order;

  DeliveryBoyOrders({this.success, this.order});

  DeliveryBoyOrders.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['order'] != null) {
      order = new List<Order>();
      json['order'].forEach((v) {
        order.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.order != null) {
      data['order'] = this.order.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  int orderNo;
  String totalAmount;
  int items;
  String date;
  String status;
  String address;

  Order(
      {this.orderNo,
        this.totalAmount,
        this.items,
        this.date,
        this.status,
        this.address});

  Order.fromJson(Map<String, dynamic> json) {
    orderNo = json['order_no'];
    totalAmount = json['total_amount'];
    items = json['items'];
    date = json['date'];
    status = json['status'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_no'] = this.orderNo;
    data['total_amount'] = this.totalAmount;
    data['items'] = this.items;
    data['date'] = this.date;
    data['status'] = this.status;
    data['address'] = this.address;
    return data;
  }
}