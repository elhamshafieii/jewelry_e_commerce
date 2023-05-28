import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelry_e_commerce/data/repoditory/cart_repository.dart';
import 'package:jewelry_e_commerce/data/repoditory/root_repository.dart';
import 'package:jewelry_e_commerce/model/banner.dart';
import 'package:jewelry_e_commerce/model/product.dart';
part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final IClassesRepository classesRepository;
  final ICartRepository cartRepository;
  RootBloc({required this.cartRepository, required this.classesRepository})
      : super(RootLoading()) {
    on<RootEvent>((event, emit) async {
      if (event is RootStarted) {
        try {
          emit(RootLoading());
          final classes = await classesRepository.getClasses();
          final banners = await classesRepository.getBanners();
          final goldPerGramPrice =
              await classesRepository.getGoldPerGramPrice();
          final recentProductsList = getRecentProducts(classes);
          emit(RootSuccess(
            classes: classes,
            banners: banners,
            goldPerGramPrice: goldPerGramPrice,
            recentProducts: recentProductsList,
          ));
        } on SocketException catch (error) {
          emit(RootError(error: error.toString()));
        }
      }
    });
  }

  List<ProductEntity> getRecentProducts(List classes) {
    List<ProductEntity> recentProducts = [];
    for (var classItem in classes) {
      final classItemList = (classItem as Map).values.toList()[0];
      for (var subClass in classItemList) {
        final subClassList = (subClass[0] as Map).values.toList()[0];
        for (var subClass in subClassList) {
          final productRecent =
              (subClass as Map<String, dynamic>).values.toList()[0]['recent'];
          if (productRecent != null && productRecent) {
            final ProductEntity recentProduct =
                ProductEntity.fromJson(subClass.values.toList()[0]);
            recentProducts.add(recentProduct);
          }
        }
      }
    }
    return recentProducts;
  }
}
