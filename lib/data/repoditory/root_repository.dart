import 'package:jewelry_e_commerce/data/data_source/root_data_source.dart';
import 'package:jewelry_e_commerce/model/banner.dart';

final classesRepository =
    ClassesRepositry(dataSource: ClassesFirebaseDataSource());

abstract class IClassesRepository {
  Future<List> getClasses();
  Future<List<BannerEntity>> getBanners();
  Future<int> getGoldPerGramPrice();
}

class ClassesRepositry implements IClassesRepository {
  final IClassesDataSource dataSource;

  ClassesRepositry({required this.dataSource});
  @override
  Future<List> getClasses() {
    return dataSource.getClasses();
  }

  @override
  Future<List<BannerEntity>> getBanners() {
    return dataSource.getBanners();
  }

  @override
  Future<int> getGoldPerGramPrice() {
    return dataSource.getGoldPerGramPrice();
  }
}
