import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jewelry_e_commerce/model/product.dart';
import 'package:jewelry_e_commerce/ui/carousel/carousel_slider.dart';
import 'package:jewelry_e_commerce/util/common.dart';

class RecentProductsList extends StatefulWidget {
  const RecentProductsList({
    Key? key,
    required this.themeData,
    required this.goldGramPrice,
    required this.recentProducts,
  }) : super(key: key);
  final ThemeData themeData;
  final int goldGramPrice;
  final List<ProductEntity> recentProducts;
  @override
  State<RecentProductsList> createState() => _RecentProductsListState();
}

class _RecentProductsListState extends State<RecentProductsList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: defaultScrollPhysics,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('جدیدترین محصولات:',
                    style: widget.themeData.textTheme.headlineSmall),
                TextButton(onPressed: (() {}), child: const Text('مشاهده همه'))
              ],
            ),
          ),
          CarouselSlider.builder(
            itemCount: widget.recentProducts.length,
            itemBuilder: ((context, index, realIndex) {
              return RecentItem(
                recentProduct: widget.recentProducts[index],
                themeData: widget.themeData,
                goldGramPrice: widget.goldGramPrice
              );
            }),
            options: CarouselOptions(
                height: 250,
                enlargeFactor: 0.4,
                scrollPhysics: defaultScrollPhysics,
                scrollDirection: Axis.horizontal,
                viewportFraction: 0.6,
                initialPage: 0,
                disableCenter: true,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.scale),
          ),
        ],
      ),
    );
  }
}

class RecentItem extends StatelessWidget {
  final ProductEntity recentProduct;
  final ThemeData themeData;
  final int goldGramPrice;
  const RecentItem({
    Key? key,
    required this.recentProduct,
    required this.themeData,
    required this.goldGramPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 8, 12, 8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: Colors.black.withOpacity(0.2),
                )
              ]),
          child: InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: () => Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return Container();
            })),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: recentProduct.imageUrls[0] != ''
                    ? CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: recentProduct.imageUrls[0],
                      )
                    : null),
          ),
        ),
      ),
      Positioned(
        bottom: 15,
        right: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(
                recentProduct.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: themeData.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(
                priceCalculator(goldGramPrice, recentProduct.wage,
                        recentProduct.weight[0], recentProduct.discount)
                    .toInt()
                    .withPriceLabel,
                style: themeData.textTheme.bodySmall!,
              ),
            )
          ],
        ),
      )
    ]);
  }
}
