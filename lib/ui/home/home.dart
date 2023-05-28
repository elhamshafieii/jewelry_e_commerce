import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jewelry_e_commerce/model/banner.dart';
import 'package:jewelry_e_commerce/model/product.dart';
import 'package:jewelry_e_commerce/ui/class/class_screen.dart';
import 'package:jewelry_e_commerce/ui/home/recent_products.dart';
import 'package:jewelry_e_commerce/ui/home/search_bar.dart';
import 'package:jewelry_e_commerce/ui/sub_class/sub_class_screen.dart';
import 'package:jewelry_e_commerce/util/common.dart';

class HomeScreen extends StatefulWidget {
  final List classes;
  final List<BannerEntity> banners;
  final int goldPerGramPrice;
  final List<ProductEntity> recentProducts;
  const HomeScreen(
      {super.key,
      required this.goldPerGramPrice,
      required this.classes,
      required this.banners,
      required this.recentProducts});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String text = '';
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: SafeArea(
          child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Stack(
                      children: [
                        SizedBox(
                          height: 227.5,
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(65),
                                  bottomRight: Radius.circular(45)),
                              child: Image.asset(
                                'assets/images/banner.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              top: 25,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Text(
                                      'طلای پرسته',
                                      style: themeData.textTheme.headlineLarge!
                                          .copyWith(
                                              color: Colors.white, height: 2),
                                    ),
                                    Text(
                                      'ویترینی به وسعت تمام ایران',
                                      style: themeData.textTheme.headlineLarge!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 40,
                              bottom: 0,
                              child: SearchContainer(
                                goldGramPrice: widget.goldPerGramPrice,
                              ),
                            )
                          ]),
                        ),
                      ],
                    );
                  case 1:
                    return BannerList(
                      themeData: themeData,
                      banners: widget.banners,
                      classmap: widget.classes,
                      goldGramPrice: widget.goldPerGramPrice,
                    );
                  case 2:
                    return RecentProductsList(
                      themeData: themeData,
                      goldGramPrice: widget.goldPerGramPrice,
                      recentProducts: widget.recentProducts,
                    );
                }
              })),
    );
  }
}

class BannerList extends StatelessWidget {
  final List classmap;
  final List<BannerEntity> banners;
  final int goldGramPrice;

  const BannerList(
      {Key? key,
      required this.themeData,
      required this.banners,
      required this.classmap,
      required this.goldGramPrice})
      : super(key: key);

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
          child: Text(
            'دسته بندی مورد نظر شما',
            style: themeData.textTheme.headlineMedium,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 120,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              physics: defaultScrollPhysics,
              itemCount: banners.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final banner = banners[index];
                return BannerItem(
                  banner: banner,
                  themeData: themeData,
                  classMap: classmap[index],
                  goldGramPrice: goldGramPrice,
                );
              }),
        ),
      ],
    );
  }
}

class BannerItem extends StatelessWidget {
  const BannerItem(
      {Key? key,
      required this.banner,
      required this.themeData,
      required this.classMap,
      required this.goldGramPrice})
      : super(key: key);
  final Map classMap;
  final BannerEntity banner;
  final ThemeData themeData;
  final int goldGramPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.fromLTRB(10, 0, 12, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    colors: [
                      Color(0xff376aed),
                      Color(0xff49b0e2),
                      Color(0xff9cecfb)
                    ])),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                if ((classMap[banner.title] as List).length == 1) {
                  return SubClassScreen(
                    subClassItems: classMap[banner.title][0],
                    goldGramPrice: goldGramPrice,
                  );
                } else {
                  return ClassScreen(
                    className: banner.title,
                    classList: classMap[banner.title],
                    goldGramPrice: goldGramPrice,
                  );
                }
              })),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22)),
                margin: const EdgeInsets.all(2),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: CachedNetworkImage(imageUrl: banner.imageUrl),
                  ),
                ),
              ),
            ),
          ),
        ]),
        const SizedBox(
          height: 4,
        ),
        Text(
          banner.title,
          style: themeData.textTheme.bodyMedium,
        )
      ],
    );
  }
}
