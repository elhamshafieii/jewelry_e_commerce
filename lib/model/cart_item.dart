
import 'package:jewelry_e_commerce/model/product.dart';

class CartItem {
  final ProductEntity product;
   int count;
  final String color;
  final double weight;
  bool deleteButtomLoading = false;
  bool changeCountButtomLoading = false;

  CartItem(
      {required this.color,
      required this.weight,
      required this.product,
      required this.count});

  // Map<String, dynamic> toMap() {
  //   return {
  //     'cart_ref': product,
  //     'count': count,
  //     'color': color,
  //     'weight': weight,
  //   };
  // }
}
