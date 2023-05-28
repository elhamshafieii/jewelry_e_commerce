import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelry_e_commerce/data/common.dart';
import 'package:jewelry_e_commerce/data/repoditory/auth_repository.dart';

import 'package:jewelry_e_commerce/data/repoditory/cart_repository.dart';
import 'package:jewelry_e_commerce/model/auth_info.dart';
import 'package:jewelry_e_commerce/model/cart_item.dart';
import 'package:jewelry_e_commerce/model/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;
  CartBloc({required this.cartRepository}) : super(CartSLoading()) {
    on<CartEvent>((event, emit) async {
      final authInfo = AuthRepository.authChangeNotifier.value;
      if (event is CartStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.uid.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItems(emit, authInfo);
        }
      } else if (event is CartAuthInfoChanged) {
        if (authInfo == null || authInfo.uid.isEmpty) {
          emit(CartAuthRequired());
        } else {
          if (event is CartAuthRequired) {
            await loadCartItems(emit, authInfo);
          }
        }
      } else if (event is CartDeleteButtonClicked) {
        try {
          if (state is CartSuccess) {
            final DocumentReference ref = findRef(event.cartItem.product.code);
            final successState = state as CartSuccess;
            final cartItem = successState.cartItems
                .firstWhere((element) => findRef(element.product.code) == ref);
            cartItem.deleteButtomLoading = true;
            emit(CartSuccess(cartItems: successState.cartItems));
          }
          await cartRepository.delete(authInfo!, event.cartItem);
          await cartRepository.count(await authRepository.loadAuthInfo());
          if (state is CartSuccess) {
            final DocumentReference ref = findRef(event.cartItem.product.code);
            final successState = state as CartSuccess;
            successState.cartItems
                .removeWhere((element) => findRef(element.product.code) == ref);
            if (successState.cartItems.isEmpty) {
              emit(CartEmpty());
            } else {
              emit(CartSuccess(cartItems: successState.cartItems));
            }
          }
        } on FirebaseException catch (e) {
          emit(CartError(e.toString()));
        }
      } else if (event is CartIncreaseCountButtonClicked ||
          event is CartDecreaseCountButtonClicked) {
        try {
          CartItem? cartItem;
          if (event is CartIncreaseCountButtonClicked) {
            cartItem = event.cartItem;
          } else if (event is CartDecreaseCountButtonClicked) {
            cartItem = event.cartItem;
          }
          if (state is CartSuccess) {
            final successState = state as CartSuccess;
            final index = successState.cartItems.indexWhere((element) =>
                findRef(element.product.code) ==
                findRef(cartItem!.product.code));
            successState.cartItems[index].changeCountButtomLoading = true;
            emit(CartSuccess(cartItems: successState.cartItems));
            final int newCount = event is CartIncreaseCountButtonClicked
                ? successState.cartItems[index].count + 1
                : successState.cartItems[index].count - 1;

            await cartRepository.changeCount(authInfo!, cartItem!, newCount);
            await cartRepository.count(await authRepository.loadAuthInfo());
            successState.cartItems
                .firstWhere((element) =>
                    findRef(element.product.code) ==
                    findRef(cartItem!.product.code))
                .count = newCount;
            successState.cartItems[index].changeCountButtomLoading = false;
            emit(CartSuccess(cartItems: successState.cartItems));
          }
        } on FirebaseException catch (e) {
          emit(CartError(e.toString()));
        }
      }
    });
  }
  Future<void> loadCartItems(Emitter<CartState> emit, AuthInfo authInfo) async {
    List<ProductEntity> cartProducts = [];
    try {
      emit(CartSLoading());
      List<CartItem> cartItems = await cartRepository.getAll(authInfo);
      for (var element in cartItems) {
        DocumentReference productRef = findRef(element.product.code);
        final productSnapshot = await productRef.get();
        final productMap = productSnapshot.data() as Map<String, dynamic>;
        final product = ProductEntity.fromJson(productMap);
        cartProducts.add(product);
      }
      if (cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartSuccess(cartItems: cartItems));
      }
    } on FirebaseException catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
