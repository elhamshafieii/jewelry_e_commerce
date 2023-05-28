import 'package:jewelry_e_commerce/data/common.dart';
import 'package:firebase_storage/firebase_storage.dart';



Future<List<String>> getImageUrl(String code) async {
  final String className = classString[code.substring(0, 3)]!;
  final int subClassNumber = int.parse(code.substring(3, 5));
  final String subClassName =
      subClassString[code.substring(0, 3)]![subClassNumber];
  final String imagePath = 'class/$className/$subClassName/$code';
  final listResult =
      await FirebaseStorage.instance.ref().child(imagePath).listAll();
  List<String> imageUrls = [];
  for (var item in listResult.items) {
    imageUrls.add(await item.getDownloadURL());
  }
  return imageUrls;
}
