part of 'product_detail_bloc.dart';

abstract class ProductDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailGetCartItems extends ProductDetailState {
  final List<CartItem> cartItems;

  ProductDetailGetCartItems({required this.cartItems});
}

class ProductAddToCartButtonLoading extends ProductDetailState {}

class ProductAddToCartError extends ProductDetailState {
  final String error;

  ProductAddToCartError({required this.error});

  @override
  List<Object> get props => [error];
}

class ProductAddToCartSuccess extends ProductDetailState {
  final CartItem cartItem;

  ProductAddToCartSuccess({required this.cartItem});
}
