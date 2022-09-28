import 'dart:async';
import 'dart:io';

class ApiCon {
  //pre production
  //static String baseurl = 'https://drinklink-preprod-be.azurewebsites.net/api';
  //production
  //static String baseurl = 'https://drinklink-prod-be.azurewebsites.net/api';
  static String storeUrl = '/places?page=0';
  static String recentUrl = '/users/currentUser/orders?pageSize=1&pageNumber=1';

  static String baseurl() {
    bool isPro = false;

    String url;
    String prepro = 'https://drinklink-preprod-be.azurewebsites.net/api';
    String pro = 'https://drinklink-prod-be.azurewebsites.net/api';
    if (isPro == true) {
      url = pro;
    } else {
      url = prepro;
    }
    return url;
  }

  static String paymenturl() {
    bool isPro = false;

    String url;
    String prepro = 'https://paypage.sandbox.ngenius-payments.com';
    String pro = 'https://paypage.ngenius-payments.com';
    if (isPro == true) {
      url = pro;
    } else {
      url = prepro;
    }
    return url;
  }
}
