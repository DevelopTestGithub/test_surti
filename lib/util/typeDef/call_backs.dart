import 'package:surtiSP/api/login_api.dart';
import 'package:surtiSP/models/user_status.dart';
import 'package:surtiSP/models/discount.dart';
import 'package:surtiSP/util/http/request.dart';
import 'package:surtiSP/view/pages/login_page.dart';

typedef void CountCallBack(int);

typedef void BoolCallBack(bool);

typedef void UserStatusCallback(UserStatus);

typedef void MessageCallback(String);

typedef void LoginCallback(LoginSend, LoginState);

typedef void GetRequestCallback(GetRequest);

/// Calls back a discount.
/// Param 1: discount to return
/// Param 2: Succesful ?, Is it succesfully retreived
typedef void DiscountCallback(Discount, bool);

/// Calls back a discount list, used on products.
/// Param 1: discount list to return
/// Param 2: Succesful ?, Is it succesfully retreived
typedef void DiscountListCallback(List, bool);
