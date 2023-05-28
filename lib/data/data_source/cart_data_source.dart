import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jewelry_e_commerce/data/common.dart';

import 'package:jewelry_e_commerce/model/auth_info.dart';
import 'package:jewelry_e_commerce/model/cart_item.dart';
import 'package:jewelry_e_commerce/model/product.dart';

abstract class ICartDataSource {
  Future<CartItem> add(
      AuthInfo authInfo, ProductEntity product, String color, double weight);
  Future<CartItem> changeCount(
      AuthInfo authInfo, CartItem cartItem, int newCount);
  Future<void> delete(AuthInfo authInfo, CartItem cartItem);
  Future<int> count(AuthInfo authInfo);
  Future<List<CartItem>> getAll(AuthInfo authInfo);
}

class CartFirebaseDataSource implements ICartDataSource {
  // final String? uid = AuthRepository.authChangeNotifier.value?.uid;
  @override
  Future<CartItem> add(AuthInfo authInfo,
      ProductEntity product, String color, double weight) async {
    final String productCode = product.code;
    final ref = findRef(productCode);
    await database.collection('user').doc(authInfo.uid).update({
      'cart': FieldValue.arrayUnion([
        {'color': color, 'weight': weight, 'count': 1, 'cart_ref': ref}
      ]),
    });
    return CartItem(color: color, weight: weight, product: product, count: 1);
  }

  @override
  Future<void> delete(AuthInfo authInfo,CartItem cartItem) async {
    final String productCode = cartItem.product.code;
    final productRef = findRef(productCode);
    final cartItemsSnapshot = await database.collection('user').doc(authInfo.uid).get();
    final cartItems = (cartItemsSnapshot.data() as Map)['cart'] as List;
    final item = cartItems
        .firstWhere((element) => (element as Map)['cart_ref'] == productRef);
    await database.collection('user').doc(authInfo.uid).update({
      'cart': FieldValue.arrayRemove([item])
    });
  }

  @override
  Future<CartItem> changeCount(AuthInfo authInfo,CartItem cartItem, int newCount) async {
    final DocumentReference ref = findRef(cartItem.product.code);
    final cartItemsSnapshot = await database.collection('user').doc(authInfo.uid).get();
    final cartItems = (cartItemsSnapshot.data() as Map)['cart'] as List;
    final index =
        cartItems.indexWhere((element) => (element as Map)['cart_ref'] == ref);
    cartItems[index]['count'] = newCount;
    await database.collection('user').doc(authInfo.uid).update({'cart': cartItems});
    return CartItem(
        weight: cartItems[index]['weight'],
        color: cartItems[index]['color'],
        count: cartItems[index]['count'],
        product: cartItem.product);
  }

  @override
  Future<int> count(AuthInfo authInfo) async {
    final String uid = authInfo.uid;
    final cartItemsSnapshot = await database.collection('user').doc(uid).get();
    final cartItemList = (cartItemsSnapshot.data() as Map)['cart'] as List;
    int count = 0;
    for (var cartItem in cartItemList) {
      count = count + (cartItem as Map)['count'] as int;
    }
    return count;
  }

  @override
  Future<List<CartItem>> getAll(AuthInfo authInfo) async {
    List<CartItem> cartItems = [];
    final String uid = authInfo.uid;
    final cartItemsSnapshot = await database.collection('user').doc(uid).get();
    final cartItemList = (cartItemsSnapshot.data() as Map)['cart'];
    List<ProductEntity> cartProducts = [];
    for (var cartItem in cartItemList) {
      final DocumentReference ref = cartItem['cart_ref'];
      final cartProductSnapshot = await ref.get();
      final cartProductMap = cartProductSnapshot.data() as Map<String, dynamic>;
      final cartProduct = ProductEntity.fromJson(cartProductMap);
      cartProducts.add(cartProduct);
    }
    for (var i = 0; i < cartItemList.length; i++) {
      final item = CartItem(
          color: cartItemList[i]['color'],
          weight: cartItemList[i]['weight'],
          count: cartItemList[i]['count'],
          product: cartProducts[i]);
      cartItems.add(item);
    }
    return cartItems;
  }
}
