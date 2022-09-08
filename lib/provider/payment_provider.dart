import 'package:flutter/cupertino.dart';
import 'package:driklink/pages/Api.dart';

class PaymentProvider extends ChangeNotifier {
  String paycon = ApiCon.paymenturl();
  String paymenturl = '';
  String paymentMessage = '';
  bool isPaymentlinkurl;

  void checkurl(String url) {
    if (url.isNotEmpty)
      _paymenturl();
    else
      _paymentMessage();
  }

  void _paymenturl() {
    paymenturl = paycon;
    isPaymentlinkurl = true;
    //Call this whenever there is some change in any field of change notifier.
    notifyListeners();
  }

  void _paymentMessage() {
    paymentMessage = '';
    isPaymentlinkurl = false;
    //Call this whenever there is some change in any field of change notifier.
    notifyListeners();
  }

  String get paymentlink => paymenturl;
  bool get isPaymentlink => isPaymentlinkurl;
}
