part of 'cart_bloc.dart';

abstract class CartEvent {
  const CartEvent();
}

class CartStarted extends CartEvent {
  final AuthInfo? authInfo;

  const CartStarted(this.authInfo);
}

class CartAuthInfoChanged extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChanged(this.authInfo);
}

class CartIncreaseCountButtonClicked extends CartEvent {
  final CartItem cartItem;

  const CartIncreaseCountButtonClicked({required this.cartItem});
}

class CartDecreaseCountButtonClicked extends CartEvent {
  final CartItem cartItem;

  const CartDecreaseCountButtonClicked({required this.cartItem});
}

class CartDeleteButtonClicked extends CartEvent {
  final CartItem cartItem;

  const CartDeleteButtonClicked({required this.cartItem});
}
