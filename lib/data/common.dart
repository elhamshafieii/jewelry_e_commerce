import 'package:cloud_firestore/cloud_firestore.dart';

const Map<String, String> classString = {
  'EAR': 'گوشواره',
  'BAN': 'النگو',
  'RIN': 'انگشتر',
  'BRA': 'دستبند',
  'NEC': 'گردنبند',
  'ANK': 'پابند',
  'WAT': 'آویز ساعت',
  'PIE': 'پیرسینگ',
};

const Map<String, Map> subClassString = {
  'EAR': earSubClassString,
  'BAN': banSubCateroryString,
  'RIN': rinSubClassString,
  'BRA': braSubClassString,
  'NEC': necSubClassString,
  'ANK': ankSubClassString,
  'WAT': watSubClassString,
  'PIE': pieSubClassString,
};

const Map<int, String> earSubClassString = {
  1: 'گوشواره آویز',
  2: 'گوشواره بخیه ای',
  3: 'گوشواره حلقه ای',
  4: 'گوشواره پونزی',
  5: 'گوشواره میخی',
  6: 'گوشواره کارتیه',
  7: 'گوشواره کلیپسی',
  8: 'گوشواره مروارید',
  9: 'گوشواره فیروزه'
};

const Map<int, String> banSubCateroryString = {
  1: 'النگو باریک زنانه',
  2: 'النگو دستبندی زنانه',
};
const Map<int, String> rinSubClassString = {
  1: 'انگشتر بدون نگین زنانه',
  2: 'انگشتر پینکی زنانه',
  3: 'انگشتر عقیق زنانه',
  4: 'انگشتر فیروزه زنانه',
  5: 'انگشتر کارتیر زنانه',
  6: 'انگشتر نگین دار زنانه',
  7: 'انگشتر یاقوت زنانه',
  8: 'حلقه ازدواج',
};
const Map<int, String> braSubClassString = {
  1: 'دستبند بافت زنانه',
  2: 'دستبند چرم زنانه',
  3: 'دستبند چشم نظر زنانه',
  4: 'دستبند حدید زنانه',
  5: 'دستبند زنجیری زنانه',
  6: 'دستبند سکه ای زنانه',
  7: 'دستبند سنگی زنانه',
  8: 'دستبند فیروزه زنانه',
  9: 'دستبند کارتیر زنانه',
  10: 'دستبند مروارید زنانه',
  11: 'دستبند مهره ای زنانه',
};

const Map<int, String> necSubClassString = {
  1: 'گردنبند چرم زنانه',
  2: 'گردنبند چشم و نظر زنانه',
  3: 'گردنبند زنانه عقیق',
  4: 'گردنبند زنانه فیروزه',
  5: 'گردنبند زنجیری زنانه',
  6: 'گردنبند سنگی زنانه',
  7: 'گردنبند ظریف زنانه',
  8: 'گردنبند قلب فیروزه',
  9: 'گردنبند کارتیر زنانه',
  10: 'گردنبند مروارید زنانه',
};

const Map<int, String> ankSubClassString = {
  1: 'پابند',
};
const Map<int, String> watSubClassString = {
  1: 'آویز ساعت',
};
const Map<int, String> pieSubClassString = {
  1: 'پیرسینگ',
};

final FirebaseFirestore database = FirebaseFirestore.instance;

  DocumentReference findRef(String code) {
    final String className = classString[code.substring(0, 3)]!;
    final int subClassCode = int.parse(code.substring(3, 5));
    final String subClassName =
        subClassString[code.substring(0, 3)]![subClassCode];
    final int itemNumber = int.parse(code.substring(5, 7));
    final String productRef =
        'class/$className/sub_class/$subClassName/products/$itemNumber';
    final ref = database.doc(productRef);
    return ref;
  }
