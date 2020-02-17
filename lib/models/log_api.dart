import 'package:surtiSP/util/user_Controller.dart';

enum LogApiModelType {
  ADDPRODUCTCART, //enviado
  BUY,
}

class LogApiModelString {
  static const String //
      ADDPRODUCTCART = "AddProductToCart",
      BUY = "Buy" ;
}

class LogActions {
  int id;
  String className;
  String methodName;
  String text;
  String action;
  String user;
  String product;
  String dateTime;

  LogActions({
    this.className,
    this.methodName,
    this.text,
    this.action,
    this.user,
    this.product,
    this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'methodName': methodName,
      'text': text,
      'action': action,
      'user': UserController.client.userId,
      'product': product,
      'dateTime': dateTime,
    };
  }

  static LogActions fromMap(Map<String, dynamic> map) {
    return LogActions(
      className: map['className'],
      methodName: map['methodName'],
      text: map['text'],
      action: map['action'],
      user: UserController.client.userId,
      product: map['product'],
      dateTime: map['dateTime'],
    );
  }
  String toString() {
    return "/?user=${UserController.client.userId}&action=$action.&product=$product.&dateTime=$dateTime";
  }

}
