import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:jewelry_e_commerce/model/cart_item.dart';
import 'package:jewelry_e_commerce/model/product.dart';

bool checkIsInCart(List<CartItem> cartItems, ProductEntity item) {
  final index =
      cartItems.indexWhere((element) => element.product.code == item.code);
  if (index == -1) {
    return false;
  } else {
    return true;
  }
}

Future<bool> checkNetworkConectivity() async {
  final isConnectedToNetwork = await InternetConnectionChecker().hasConnection;
  return isConnectedToNetwork;
}

const defaultScrollPhysics = BouncingScrollPhysics();
const defaulProgressIndicator = CircularProgressIndicator(
  strokeWidth: 3,
);

extension PriceLabel on int {
  String get withPriceLabel => this > 0 ? '$seprateByComma تومان' : 'رایگان';

  String get seprateByComma {
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}

int priceCalculator(
    int goldGramPrice, double wage, double weight, int discount) {
  final double price =
      (((goldGramPrice * (1 + wage) * weight) * 1.02) - discount);
  return price.round();
}

Color colorCalculator(String color) {
  switch (color) {
    case 'زرد':
      return Colors.amber;
    case 'سفید':
      return Colors.grey;
    case 'رزگلد':
      return Colors.yellow.shade900;
    default:
      return Colors.white;
  }
}

// Future<int> userCounter() async {
//   final QuerySnapshot userCountSnapshot =
//       await database.collection("user").get();
//   final userCount = userCountSnapshot.docs.length;
//   return userCount;
// }

