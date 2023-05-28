part of 'root_bloc.dart';

abstract class RootState extends Equatable {
  const RootState();

  @override
  List<Object> get props => [];
}

class RootLoading extends RootState {}

class RootError extends RootState {
  final String error;

  const RootError({required this.error});
  @override
  List<Object> get props => [error];
}

class RootNotConnectToFireBase extends RootState {}

class RootSuccess extends RootState {
  final List classes;
  final List<BannerEntity> banners;
  final List<ProductEntity> recentProducts;
  final int goldPerGramPrice;

  const RootSuccess(
      {
      required this.recentProducts,
      required this.goldPerGramPrice,
      required this.banners,
      required this.classes});
}
