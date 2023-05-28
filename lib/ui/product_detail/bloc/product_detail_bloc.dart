import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelry_e_commerce/data/repoditory/auth_repository.dart';
import 'package:jewelry_e_commerce/data/repoditory/cart_repository.dart';
import 'package:jewelry_e_commerce/model/cart_item.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ICartRepository cartRepository;
  ProductDetailBloc({required this.cartRepository})
      : super(ProductDetailInitial()) {
    on<ProductDetailEvent>((event, emit) async {
      if (event is ProductDetailStarted) {
        try {
          emit(ProductAddToCartButtonLoading());
          final cartItems =
              await cartRepository.getAll(await authRepository.loadAuthInfo());
          emit(ProductDetailGetCartItems(cartItems: cartItems));
        } on FirebaseException catch (e) {
          emit(ProductAddToCartError(error: e.toString()));
        }
      } else if (event is ProductAddButtonClick) {
        try {
          emit(ProductAddToCartButtonLoading());
          CartItem cartItem = await cartRepository.add(
              await authRepository.loadAuthInfo(),
              event.cartItem.product,
              event.cartItem.color,
              event.cartItem.weight);
          emit(ProductAddToCartSuccess(cartItem: cartItem));
          await cartRepository.count(await authRepository.loadAuthInfo());
        } on FirebaseException catch (e) {
          emit(ProductAddToCartError(error: e.toString()));
        }
      }
    });
  }
}
