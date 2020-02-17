import 'package:surtiSP/settings.dart';
import 'package:surtiSP/util/user_Controller.dart';

enum Service {
  //
  LOGIN,
  REFRESH_TOKEN,

  PRODUCT_LIST,
  PRODUCT_BY_ID,
  PRODUCT_LIST_CART,
  PRODUCT_CATEGORY,

  CART_ITEM_VIEW,
  CART_ITEM_DELETE,
  CART_CLEAR,
  CART_ITEM_ADD,
  CART_ITEM_EDIT,
  CART_ACTIVE,

  ORDER_GET,
  ORDER_GET_BY_ID,
  ORDER_GET_ALL_CUSTOMER_ORDERS,
  ORDER_GET_ALL_ACTIVE,
  ORDER_GET_UNIFIED,
  ORDER_GET_2_DELIVER,
  ORDER_GET_CUSTOMER_ACTIVE,
  ORDER_CANCEL,
  ORDER_SHIPPED,
  ORDER_DELIVERED,
  ORDER_UPDATE_PRODUCT,

  DISCOUNT_GET,

  CLIENT_GET,
  CLIENT_ADD_GEO,
  CLIENT_SEARCH_GET,
  CLIENT_CREATE_BASIC,
  CLIENT_MODIFY_BASIC,
  CLIENT_UPGRADE,
  CLIENT_GET_BY_PT_CODE,
  ADDRESS_ADD,

  FEATURED_GET,

  PURCHASE,
  VENDOR
  //
}

class HTTP {
  static const String
      //
      LOCAL_MAIN = "assets/sp/offline_jsons",

      //[item]_[any sufix a.e. LIST]_[type] eg. PRODUCT_LIST

      LOGIN = "/token",

      REFRESH_TOKEN = "/token-refresh",

      PURCHASE =
          "/api/orders", // [POST] {INT customerId} ///new: vendor-order //Default:orders
      VENDOR =
          "/api/vendor-order", // [POST] {INT customerId} ///new: vendor-order //Default:orders

      /*  [GET] "/api/products" */
      PRODUCT_LIST = "/api/products-by-category",

      /*  [GET] "" */
      PRODUCT_BY_ID = "/api/products",
      /*  [GET] "" */
      PRODUCT_LIST_CART = "/api/shopping_cart_items",
      /*  [GET] "" */
      PRODUCT_CATEGORY = "/api/products-by-category",
      /*  [GET] "" */

      /* [] /ID  */
      CART_ACTIVE = "/api/is_shopping_cart_empty",
      /* [] /ID  */
      CART_ITEM_VIEW = "/api/shopping_cart_items",
      /* [DELETE] "/ID"  */
      CART_ITEM_DELETE = "/api/simple_shopping_cart_items",
      /* [DELETE] "/ID"  */
      CART_CLEAR = "/api/clear_shopping_cart_items",
      /* [POST] ""  */
      CART_ITEM_ADD = "/api/simple_shopping_cart_items",
      /* [PUT] */
      CART_ITEM_EDIT = "/api/shopping_cart_items/",

      /* [GET] {INT order_id}  */
      ORDER_GET = "/api/orders/customer/",
      ORDER_GET_ALL_ACTIVE = "/api/all-active-orders",
      /* [GET] {INT order_id}  */
      ORDER_GET_BY_ID = "/api/orders/",
      ORDER_UPDATE_PRODUCT = "/api/orders/products/",
      /* */
      /* [POST] {INT order_id}  */
      ORDER_GET_ALL_CUSTOMER_ORDERS = "/api/orders/customer",
      /* [GET] */
      ORDER_GET_UNIFIED = "/api/consolidado-productos",

      /* [GET] */
      ORDER_GET_2_DELIVER = "/api/orders_to_deliver",

      ORDER_GET_CUSTOMER_ACTIVE = "/api/active-orders",

      /* [POST] {INT order_id}  */
      ORDER_CANCEL = "/api/cancel-orders/",
      ORDER_SHIPPED = "/api/shipping-status/shipped/orders/",
      ORDER_DELIVERED = "/api/shipping-status/delivered/orders/",

      // [GET] "/api/discounts"
      DISCOUNT_GET = "/api/discounts",

      // [PUT]
      CLIENT_CREATE_BASIC = "/api/basic-customers",      
      CLIENT_MODIFY_BASIC = "/api/basic-customers",
      CLIENT_UPGRADE = "/api/app-customer-enrollment", /* Level UP */

      CLIENT_GET = "/api/customers",
      CLIENT_SEARCH_GET = "/api/customers/search/",
      CLIENT_ADD_GEO = "/api/geoloaction-address",
      CLIENT_GET_BY_PT_CODE = "/api/basic-customers-integrated",
      ADDRESS_ADD = "/api/customer-address",

      // [GET] "/api/featured"
      FEATURED_GET = "/api/featured";

  static String getSufix(Service service) {
    switch (service) {
      case Service.LOGIN:
        return LOGIN;
        break;
      case Service.REFRESH_TOKEN:
        return REFRESH_TOKEN;
      break;
      //
      case Service.PRODUCT_BY_ID:
        return PRODUCT_BY_ID;
        break;
      case Service.PRODUCT_LIST:
        return PRODUCT_LIST;
        break;
      case Service.PRODUCT_LIST_CART:
        return PRODUCT_LIST_CART;
        break;
      case Service.PRODUCT_CATEGORY:
        return PRODUCT_CATEGORY;
        break;
      //
      case Service.CART_ACTIVE:
        return CART_ACTIVE;
        break;
      case Service.CART_ITEM_VIEW:
        return CART_ITEM_VIEW;
        break;
      case Service.CART_ITEM_DELETE:
        return CART_ITEM_DELETE;
        break;
      case Service.CART_CLEAR:
        return CART_CLEAR;
        break;
      case Service.CART_ITEM_ADD:
        return CART_ITEM_ADD;
        break;
      case Service.CART_ITEM_EDIT:
        return CART_ITEM_EDIT;
        break;
      case Service.ORDER_GET:
        return ORDER_GET;
        break;
      case Service.ORDER_SHIPPED:
        return ORDER_SHIPPED;
        break;
      case Service.ORDER_DELIVERED:
        return ORDER_DELIVERED;
        break;
      case Service.ORDER_GET_ALL_ACTIVE:
        return ORDER_GET_ALL_ACTIVE;
        break;
      case Service.ORDER_GET_BY_ID:
        return ORDER_GET_BY_ID;
        break;
      case Service.ORDER_GET_ALL_CUSTOMER_ORDERS:
        return ORDER_GET_ALL_CUSTOMER_ORDERS;
        break;
      case Service.ORDER_GET_UNIFIED:
        return ORDER_GET_UNIFIED;
        break;
      case Service.ORDER_UPDATE_PRODUCT:
        return ORDER_UPDATE_PRODUCT;
        break;
      case Service.ORDER_GET_2_DELIVER:
        return ORDER_GET_2_DELIVER;
        break;
      case Service.ORDER_CANCEL:
        return ORDER_CANCEL;
        break;
      case Service.CLIENT_MODIFY_BASIC:       
        return CLIENT_MODIFY_BASIC;
        break;
      case Service.CLIENT_UPGRADE:        
        return CLIENT_UPGRADE;
        break;
      case Service.ORDER_GET_CUSTOMER_ACTIVE:
        return ORDER_GET_CUSTOMER_ACTIVE;
        break;
      case Service.DISCOUNT_GET:
        return DISCOUNT_GET;
        break;
      case Service.CLIENT_GET:
        return CLIENT_GET;
        break;
      case Service.CLIENT_CREATE_BASIC:
        return CLIENT_CREATE_BASIC;
        break;
      case Service.CLIENT_SEARCH_GET:
        return CLIENT_SEARCH_GET;
        break;
      case Service.CLIENT_GET_BY_PT_CODE:
        return CLIENT_GET_BY_PT_CODE;
        break;
      case Service.CLIENT_ADD_GEO:
        return CLIENT_ADD_GEO;
        break;
      case Service.ADDRESS_ADD:
        return ADDRESS_ADD;
        break;
      case Service.PURCHASE:
        return PURCHASE;
        break;
      case Service.VENDOR:
        return VENDOR;
        break;
      default:
        return "";
    }
  }

  static String getAddress(Service service) {
    String baseURL = Global.env.baseUrl;
    return "$baseURL${getSufix(service)}";
  }

  static String getLocalAddress(Service service, {bool useEnvironmentSufix = false, String extraSufix = ""}) {
    switch (useEnvironmentSufix) {
      case true:
        return "$LOCAL_MAIN${getSufix(service)}.${Global.env.environmentType}.json";
      case false:
        return "$LOCAL_MAIN${getSufix(service)}$extraSufix.json";
    }
  }

  static String getHeader() {
    return "Bearer ${UserController.me.token}";
  }
}
