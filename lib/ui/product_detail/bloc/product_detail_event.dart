part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class ProductDetailStarted extends ProductDetailEvent {}

class ProductAddButtonClick extends ProductDetailEvent {
  final CartItem cartItem;
  final BuildContext context;

  const ProductAddButtonClick({required this.cartItem, required this.context});
  @override
  List<Object> get props => [cartItem];
}
