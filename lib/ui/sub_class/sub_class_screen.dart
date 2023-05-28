import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jewelry_e_commerce/model/product.dart';
import 'package:jewelry_e_commerce/ui/product_detail/product_detail_screen.dart';
import 'package:jewelry_e_commerce/util/common.dart';
import 'package:jewelry_e_commerce/util/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SubClassScreen extends StatelessWidget {
  final int goldGramPrice;
  final List subClassItems;

  const SubClassScreen(
      {super.key,
      required this.subClassItems,
      required this.goldGramPrice,});

  @override
  Widget build(BuildContext context) {
    final String subClassName = (subClassItems[0] as Map).keys.first;
    final List products = (subClassItems[0] as Map)[subClassName];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(8, 12, 8, 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.withOpacity(0.2)),
              child: Row(
                children: [
                  BackButton(
                    color: LightThemeColors.secoundryColor.withOpacity(0.8),
                  ),
                  Expanded(
                    child: TextField(
                      decoration:
                          InputDecoration(hintText: 'جستجو در $subClassName'),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1)
                  ]),
              height: 2,
              width: MediaQuery.of(context).size.width,
            ),
            Expanded(
                child: GridView.builder(
                    itemCount: products.length + 2,
                    physics: defaultScrollPhysics,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                    ),
                    itemBuilder: ((context, index) {
                      if (index <= products.length - 1) {
                        final String productIndex =
                            (products[index] as Map).keys.first;
                        final productMap =
                            (products[index] as Map)[productIndex];
                        final product = ProductEntity.fromJson(productMap);
                        return Container(
                          margin: const EdgeInsets.all(8),
                          child: ProductItems(
                            product: product,
                            goldGramPrice: goldGramPrice,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    })))
          ],
        ),
      ),
    );
  }
}

class ProductItems extends StatefulWidget {
  const ProductItems({
    Key? key,
    required this.goldGramPrice,
    required this.product,

  }) : super(key: key);
  final ProductEntity product;
  final int goldGramPrice;


  @override
  State<ProductItems> createState() => _ProductItemsState();
}

class _ProductItemsState extends State<ProductItems> {
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (context) {
          return ProductDetailScreen(
            goleGramPrice: widget.goldGramPrice,
            productEntity: widget.product,
          );
        }));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1)
              ],
              borderRadius: BorderRadius.circular(24),
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(children: [
                PageView.builder(
                    controller: _controller,
                    itemCount: widget.product.imageUrls.length,
                    itemBuilder: ((context, index1) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: CachedNetworkImage(
                            imageUrl: widget.product.imageUrls[index1]),
                      );
                    })),
                widget.product.imageUrls.length != 1
                    ? Positioned(
                        left: 0,
                        right: 0,
                        bottom: 8,
                        child: Center(
                            child: SmoothPageIndicator(
                          controller: _controller,
                          count: widget.product.imageUrls.length,
                          effect: SwapEffect(
                            activeDotColor:
                                Theme.of(context).colorScheme.primary,
                            dotHeight: 8,
                            dotWidth: 8,
                            type: SwapType.yRotation,
                          ),
                        )))
                    : Container()
              ]),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            maxLines: 1,
            widget.product.title,
            style: themeData.textTheme.bodyMedium!.copyWith(
              overflow: TextOverflow.ellipsis,
            ),
          ),
          RichText(
            text: TextSpan(
                text: 'کد: ',
                style: themeData.textTheme.bodyMedium,
                children: [
                  TextSpan(
                      text: widget.product.code,
                      style: themeData.textTheme.bodySmall),
                ]),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'رنگ: ',
                style: themeData.textTheme.bodyMedium,
              ),
              Expanded(
                child: SizedBox(
                  height: 10,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.product.color.length,
                      itemBuilder: ((context, index) {
                        return Container(
                          margin: const EdgeInsets.only(left: 5),
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color:
                                  colorCalculator(widget.product.color[index]),
                              borderRadius: BorderRadius.circular(5)),
                        );
                      })),
                ),
              ),
            ],
          ),
          // RichText(
          //   text: TextSpan(
          //       text: 'رنگ: ',
          //       style: themeData.textTheme.bodyMedium,
          //       children: [
          //         TextSpan(
          //             text: widget.product.color.toString()
          //             // .replaceAll(']', '')
          //             // .replaceAll('[', '')
          //             ,
          //             style: themeData.textTheme.bodySmall),
          //       ]),
          // ),
          RichText(
            text: TextSpan(
                text: 'قیمت: ',
                style: themeData.textTheme.bodyMedium,
                children: [
                  TextSpan(
                      text: priceCalculator(
                              widget.goldGramPrice,
                              widget.product.wage,
                              widget.product.weight[0].toDouble(),
                              widget.product.discount)
                          .round()
                          .withPriceLabel
                          .toString(),
                      style: themeData.textTheme.bodySmall),
                ]),
          )
        ],
      ),
    );
  }
}
