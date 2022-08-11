import 'dart:async';
import 'dart:io';

class ApiCon{
  //pre production
  static String baseurl = 'https://drinklink-preprod-be.azurewebsites.net/api';
  //production
  //static String baseurl = 'https://drinklink-prod-be.azurewebsites.net/api';
  static String storeUrl = '/places?page=0';
  static String recentUrl = '/users/currentUser/orders?pageSize=1&pageNumber=1';



}