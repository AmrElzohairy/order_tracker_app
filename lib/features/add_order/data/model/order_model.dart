class OrderModel {
  final String orderId;
  final String orderName;
  final num orderLat;
  final num orderLong;
  final String orderDate;
  final String orderStatus;
  final String orderUserId;
  final String userLat;
  final String userLong;

  OrderModel({
    required this.orderId,
    required this.orderName,
    required this.orderLat,
    required this.orderLong,
    required this.orderDate,
    required this.orderStatus,
    required this.orderUserId,
    required this.userLat,
    required this.userLong,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      orderName: json['orderName'],
      orderLat: json['orderLat'],
      orderLong: json['orderLong'],
      orderDate: json['orderDate'],
      orderStatus: json['orderStatus'],
      orderUserId: json['orderUserId'],
      userLat: json['userLat'],
      userLong: json['userLong'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderName': orderName,
      'orderLat': orderLat,
      'orderLong': orderLong,
      'orderDate': orderDate,
      'orderStatus': orderStatus,
      'orderUserId': orderUserId,
      'userLat': userLat,
      'userLong': userLong,
    };
  }
}
