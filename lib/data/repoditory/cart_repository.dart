import 'package:flutter/foundation.dart';
import 'package:jewelry_e_commerce/data/data_source/cart_data_source.dart';
import 'package:jewelry_e_commerce/model/auth_info.dart';
import 'package:jewelry_e_commerce/model/cart_item.dart';

import '../../model/product.dart';

final cartRepository = CartRepository(dataSource: CartFirebaseDataSource());

abstract class ICartRepository {
  Future<CartItem> add(
      AuthInfo authInfo, ProductEntity product, String color, double weight);
  Future<CartItem> changeCount(
      AuthInfo authInfo, CartItem cartItem, int newCount);
  Future<void> delete(AuthInfo authInfo, CartItem cartItem);
  Future<int> count(AuthInfo authInfo);
  Future<List<CartItem>> getAll(AuthInfo authInfo);
}

class CartRepository implements ICartRepository {
  final CartFirebaseDataSource dataSource;
  static ValueNotifier<int> cartItemCountNotifier = ValueNotifier(0);
  // static ValueNotifier<CartItem> cartItemsNotifier = ValueNotifier(CartItem(
  //     color: '',
  //     weight: 0,
  //     product: ProductEntity(
  //         imageUrls: [],
  //         code: '',
  //         recent: false,
  //         title: '',
  //         weight: [],
  //         color: [],
  //         wage: 0,
  //         discount: 0,
  //         description: []),
  //     count: 0));
  CartRepository({required this.dataSource});
  @override
  Future<CartItem> add(
      AuthInfo authInfo, ProductEntity product, String color, double weight) {
    return dataSource.add(authInfo, product, color, weight);
  }

  @override
  Future<CartItem> changeCount(
      AuthInfo authInfo, CartItem cartItem, int newCount) {
    return dataSource.changeCount(authInfo, cartItem, newCount);
  }

  @override
  Future<int> count(AuthInfo authInfo) async {
    final count = await dataSource.count(authInfo);
    cartItemCountNotifier.value = count;
    return count;
  }

  @override
  Future<void> delete(AuthInfo authInfo, CartItem cartItem) {
    return dataSource.delete(authInfo, cartItem);
  }

  @override
  Future<List<CartItem>> getAll(AuthInfo authInfo) {
    return dataSource.getAll(authInfo);
  }
}
