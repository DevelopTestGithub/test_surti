//
//

import 'package:surtiSP/models/cart_product.dart';
import 'package:surtiSP/models/product.dart';

class CartData {
  //currently only one (update)
  List<CartProduct> cartList;
  bool allegedCartActive = false;
  int allegedCartCount = 0;
  double allegedCartValue = 0.0;

  void initCart() {
    cartList = new List<CartProduct>();
  }

  void setCartAsActive() {
    allegedCartActive = true;
  }

  void setCartAsInactive() {
    allegedCartActive = false;
  }

  int getNumberOfProducts() {
    int number = 0;
    int cachedNum = cartList.length;

    for (int i = 0; i < cachedNum; i++) {
      Product product = cartList[i].product;
      number += product.ammount;
    }

    return number;
  }

  void deleteProducts(int productId) {
    int cachedNum = cartList.length;

    for (int i = 0; i < cachedNum; i++) {
      Product product = cartList[i].product;
      if (product.id == productId) {
        cartList.removeAt(i);
        return;
      }
    }
  }

  void deleteAllProducts() {
    cartList.clear();
  }

  void editProducts(int productId, int ammount) {
    int cachedNum = cartList.length;

    for (int i = 0; i < cachedNum; i++) {
      Product product = cartList[i].product;
      if (product.id == productId) {
        product.ammount = ammount;
        return;
      }
    }
  }

  double getTotalInCart() {
    double moneyToPay = 0;
    int cachedNum = cartList.length;

    for (int i = 0; i < cachedNum; i++) {
      Product product = cartList[i].product;
      moneyToPay += product.price * product.ammount;
    }

    return moneyToPay;
  }

  void addToCart(CartProduct product) {
    cartList.add(product);
  }

  int howManyOfThis(CartProduct product) {
    int productAmmount = 1;
    int cachedNum = cartList.length;
    for (int i = 0; i < cachedNum; i++) {
      Product product = cartList[i].product;
      if (product.getDataHash() == product.getDataHash()) {
        int ammount = product.getAmmountForCart();
        if (productAmmount < ammount) {
          productAmmount = ammount;
          break;
        }
      }
    }
    return productAmmount;
  }
}
