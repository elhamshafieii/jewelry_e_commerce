import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jewelry_e_commerce/model/banner.dart';

abstract class IClassesDataSource {
  Future<List> getClasses();
  Future<List<BannerEntity>> getBanners();
  Future<int> getGoldPerGramPrice();
}

class ClassesFirebaseDataSource implements IClassesDataSource {
  final FirebaseFirestore database = FirebaseFirestore.instance;
  List<String> classnames = [];

  @override
  Future<List> getClasses() async {
    final classes = await getAllProducts(database);
    return classes;
  }

  Future<List> getAllProducts(FirebaseFirestore database) async {
    List classes = [];
    final QuerySnapshot classQuerySnapshot =
        await database.collectionGroup('class').get();
    for (var doc in classQuerySnapshot.docs) {
      final String className = doc.id;
      classnames.add(className);
      final QuerySnapshot querySnapshotSubClass =
          await doc.reference.collection('sub_class').get();
      List subClasses = [];
      for (var docSubClass in querySnapshotSubClass.docs) {
        final String subClassName = docSubClass.id;
        final QuerySnapshot querySnapshotProducts =
            await docSubClass.reference.collection('products').get();
        List products = [];
        for (var docProduct in querySnapshotProducts.docs) {
          final productId = docProduct.id;
          Map<String, dynamic> productMap =
              docProduct.data() as Map<String, dynamic>;
          Map<String, dynamic> productsMap = {
            productId: productMap,
          };
          products.add(productsMap);
        }
        final querySnapshotSubClassImageUrl = await docSubClass.reference.get();
        final String subClassImageUrl =
            (querySnapshotSubClassImageUrl.data() as Map)['image_url'];
        List subClassSpec = [];
        Map<String, List> subClassMap = {subClassName: products};
        subClassSpec.add(subClassMap);
        Map<String, String> subClassImageUrlMap = {
          'image_url': subClassImageUrl
        };
        subClassSpec.add(subClassImageUrlMap);
        subClasses.add(
          subClassSpec,
        );
      }
      Map<String, List> classMap = {className: subClasses};
      classes.add(classMap);
    }
    return classes;
  }

  @override
  Future<List<BannerEntity>> getBanners() async {
    const String imagePath = 'banners';
    final listResult =
        await FirebaseStorage.instance.ref().child(imagePath).listAll();
    List<BannerEntity> bannerImageUrls = [];
    for (var i = 0; i < listResult.items.length; i++) {
      bannerImageUrls.add(BannerEntity(
          title: classnames[i],
          imageUrl: await listResult.items[i].getDownloadURL()));
    }
    return bannerImageUrls;
  }

  @override
  Future<int> getGoldPerGramPrice() async {
    int price = 0;
    final collection = database.collection('gold_per_gram_price');
    final docSnapshot = await collection.doc('gold_price').get();
    if (docSnapshot.exists) {
      price = docSnapshot.data()!['price'];
    }
    return price;
  }
}
