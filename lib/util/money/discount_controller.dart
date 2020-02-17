

import 'package:surtiSP/models/discount.dart';
import 'package:surtiSP/models/product.dart';
import 'package:surtiSP/util/user_Controller.dart';

class DiscountController{

  final Product model;
  final currentAmountOfItems;
  List<Discount> _productDiscounts = [];
  double _currentDiscount = 0;
  double _price;

  DiscountController(
      this.model,
      this.currentAmountOfItems,
  );

  void _updateDiscount() {
    for (int i = 0; i < _productDiscounts.length; i++) {
      if (this._productDiscounts[i].isPercentage) {
          _currentDiscount += (
              (model.price * currentAmountOfItems) *
              ((_productDiscounts[i].discountPercentage) / 100)
          );

      } else {
        _currentDiscount += (this._productDiscounts[i].discountAmount);
      }

      print('Percentage discount: $_currentDiscount');
      _price = (model.price * currentAmountOfItems) - _currentDiscount;
      print('${model.name} - Normal Price: ${model.price} - Precio Bomba: $_price');
      _price = _price < 0 ? 0 : _price;
    }
  }

  void _getDiscounts() {

    UserController.discounts.grabDiscountListFromIds(
      model.discountIds,
      (discounts, success) {
        List<Discount> discountList = discounts;
        var discountsLength = discountList.length;

        for (int i = 0; i < discountsLength; i++) {
          Discount discount = discountList[i];
          _productDiscounts.add(discount);
        }
      }
    );
  }

  double getDiscountedPrice(){
    _getDiscounts();

    if (0 == _productDiscounts.length){
      _price = model.price * currentAmountOfItems;
    } else {
      _updateDiscount();
    }

    return _price;
  }

}