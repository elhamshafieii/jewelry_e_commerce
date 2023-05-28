part of 'cart_bloc.dart';

abstract class CartState {
  const CartState();
}

class CartSLoading extends CartState {}

class CartError extends CartState {
  final String error;
  const CartError(this.error);
}

class CartSuccess extends CartState {
  final List<CartItem> cartItems;


  const CartSuccess({required this.cartItems});
}

class CartAuthRequired extends CartState {}

class CartEmpty extends CartState {}
