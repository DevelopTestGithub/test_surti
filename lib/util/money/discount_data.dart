

//

import 'package:flutter/cupertino.dart';
import 'package:surtiSP/api/featured_api.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/discount.dart';
import 'package:surtiSP/models/discount_group.dart';
import 'package:surtiSP/util/typeDef/call_backs.dart';

class DiscountsUtil {

  List<Discount> _discounts;
  List<int> _emergencyCallbackIdList;
  DiscountCallback _emergencyCallback;
  DiscountCallback _emergencyCallbackList;
  bool _whereDiscountsLoaded = false;
  bool _awaiting = false;
  bool _segwayToCallbackOnOneItem = false;
  bool _segwayToCallbackOnListItem = false;
  int _emergencyCallbackId;

  void initDiscounts(VoidCallback callback, BuildContext context, {VoidCallback error}) {

    /* If discounts loaded */
    if(_discounts != null){
      callback();
      return;
    }

    /* If discounts loaded */
    _discounts = new List<Discount>();
    loadDiscounts(callback, context);

  }

  void addToDiscounts(Discount product) {
    _discounts.add(product);
  }

  void loadDiscounts(VoidCallback callback, BuildContext context, {VoidCallback error}) async {

    if (_awaiting || _whereDiscountsLoaded) return;

    print("DiscountsMngr = START");
    _awaiting = true;
    DiscountGroup discounts = await DiscountsApi.getDiscountGroup(context);
    _awaiting = false;

    print("DiscountsMngr = YES");
    if (discounts == null) {
      return;
    }

    _whereDiscountsLoaded = true;
    _discounts = discounts.discounts;
    print("DiscountsMngr = LOAD DISCOUNTS");

    /* IF the discounts loaded after they are required */
    if (_segwayToCallbackOnOneItem) {
      _searchForDiscountInList(_emergencyCallbackId, _emergencyCallback);
      MyApp.enableUI();
    }
    if (_segwayToCallbackOnListItem) {
      _searchForDiscountListInList(
          _emergencyCallbackIdList, _emergencyCallbackList);
      MyApp.enableUI();
    }

    callback();

  }

  void grabDiscountListFromIds(List<int> ids, DiscountListCallback callback) {
    if (_awaiting && !_whereDiscountsLoaded) {
      _segwayToCallbackOnListItem = true;
      _emergencyCallbackList = callback;
      _emergencyCallbackIdList = ids;
      MyApp.disableUI();
    }
    _searchForDiscountListInList(ids, callback);
  }

  void grabDiscountFromId(int id, DiscountCallback callback) {
    if (_awaiting && !_whereDiscountsLoaded) {
      _segwayToCallbackOnOneItem = true;
      _emergencyCallback = callback;
      _emergencyCallbackId = id;
      MyApp.disableUI();
    }
    _searchForDiscountInList(id, callback);
  }

  void _searchForDiscountInList(int id, DiscountCallback callback) {
    int cachedSize = _discounts.length;
    for (int i = 0; i < cachedSize; i++) {
      Discount discountNow = _discounts[i];
      if (discountNow.id == id) {
        callback(discountNow, true);
      }
    }
    //error
    callback(null, false);
  }

  void _searchForDiscountListInList(List<int> ids, DiscountCallback callback) {
    int cachedSizeIds = ids.length;
    int cachedSize = _discounts.length;

    print("DISCOUNT _ LENGTH (0) ++++ = $cachedSize");

    if (cachedSize == 0) {}

    List<Discount> discountsList = new List<Discount>();

    for (int i = 0; i < cachedSize; i++) {
      if (cachedSizeIds == 0) {
        break;
      }
      Discount discountNow = _discounts[i];
      for (int j = 0; j < cachedSizeIds; j++) {
        int id = ids[j];
        if (discountNow.id == id) {
          discountsList.add(discountNow);
          // ids.removeAt(j);
          // cachedSizeIds = ids.length;
          break;
        }
      }
    }

    if (cachedSizeIds != 0) {
      callback(discountsList, true);
    } else {
      /* error*/
      callback(discountsList, false);
    }
  }
  
}
