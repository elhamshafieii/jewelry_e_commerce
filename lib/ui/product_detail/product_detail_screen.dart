import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jewelry_e_commerce/data/repoditory/cart_repository.dart';
import 'package:jewelry_e_commerce/model/cart_item.dart';
import 'package:jewelry_e_commerce/model/product.dart';
import 'package:jewelry_e_commerce/ui/cart/cart.dart';
import 'package:jewelry_e_commerce/ui/product_detail/bloc/product_detail_bloc.dart';
import 'package:jewelry_e_commerce/util/common.dart';
import 'package:jewelry_e_commerce/util/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductEntity productEntity;
  final int goleGramPrice;
  ProductDetailScreen({
    super.key,
    required this.productEntity,
    required this.goleGramPrice,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedWeightIndex = 0;
  String selectedColor = 'زرد';
  StreamSubscription<ProductDetailState>? stateSubscription;
  @override
  void dispose() {
    stateSubscription?.cancel();
    super.dispose();
  }

  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final productDescriptions = widget.productEntity.description;
    final productImageUrls = widget.productEntity.imageUrls;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider<ProductDetailBloc>(
          create: (context) {
            final bloc = ProductDetailBloc(cartRepository: cartRepository);
            bloc.add(ProductDetailStarted());
            stateSubscription = bloc.stream.listen((state) async {
              // final cartItems = await context
              //     .read<CartBloc>()
              //     .cartRepository
              //     .getAll(await authRepository.loadAuthInfo());
              if (state is ProductAddToCartSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('با موفقیت به سبد خرید شما اضافه شد')));
              } else if (state is ProductAddToCartError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error.toString())));
              }
            });
            return bloc;
          },
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                BlocBuilder<ProductDetailBloc, ProductDetailState>(
                    builder: (context, state) {
              if (state is ProductDetailInitial) {
                return SizedBox(

                    // FloatingActionButton.extended(
                    //     onPressed: () {}, label: Text('jjjjjjjjjjjjj'))
                    );
              } else if (state is ProductDetailGetCartItems) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width - 48,
                    child: checkIsInCart(state.cartItems, widget.productEntity)
                        ? FloatingActionButton.extended(
                            onPressed: () {
                              if (checkIsInCart(
                                  state.cartItems, widget.productEntity)) {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return CartScreen(
                                    goldGramPrice: widget.goleGramPrice,
                                  );
                                }));
                              } else {
                                CartItem cartItem = CartItem(
                                    color: selectedColor,
                                    weight: widget.productEntity
                                        .weight[selectedWeightIndex],
                                    count: 1,
                                    product: widget.productEntity);
                                context.read<ProductDetailBloc>().add(
                                    ProductAddButtonClick(
                                        cartItem: cartItem, context: context));
                              }
                            },
                            label: Text('مشاهده در سبد خرید'))
                        : FloatingActionButton.extended(
                            onPressed: () {
                              if (checkIsInCart(
                                  state.cartItems, widget.productEntity)) {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return CartScreen(
                                    goldGramPrice: widget.goleGramPrice,
                                  );
                                }));
                              } else {
                                CartItem cartItem = CartItem(
                                    color: selectedColor,
                                    weight: widget.productEntity
                                        .weight[selectedWeightIndex],
                                    count: 1,
                                    product: widget.productEntity);
                                context.read<ProductDetailBloc>().add(
                                    ProductAddButtonClick(
                                        cartItem: cartItem, context: context));
                              }
                            },
                            label: Text('افزودن به سبد خرید')));
              } else if (state is ProductAddToCartButtonLoading) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width - 48,
                    child: FloatingActionButton.extended(
                        onPressed: () {},
                        label:
                            CupertinoActivityIndicator(color: Colors.white)));
              } else if (state is ProductAddToCartSuccess) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width - 48,
                    child: FloatingActionButton.extended(
                        onPressed: () {}, label: Text('مشاهده در سبد خرید')));
              } else {
                throw Exception('jjjjjj');
              }

              //   state is ProductAddToCartButtonLoading
              //       ? CupertinoActivityIndicator(
              //           color: Theme.of(context).colorScheme.onSecondary,
              //         )
              //       : Text('افزودن به سبد خرید'),
              // ));
            }),
            body: CustomScrollView(
              physics: defaultScrollPhysics,
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width,
                  flexibleSpace: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32)),
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _controller,
                          itemCount: productImageUrls.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CachedNetworkImage(
                                imageUrl:
                                    widget.productEntity.imageUrls[index]);
                          },
                        ),
                        productImageUrls.length > 1
                            ? Positioned(
                                left: 0,
                                right: 0,
                                bottom: 8,
                                child: Center(
                                    child: SmoothPageIndicator(
                                  controller: _controller,
                                  count: productImageUrls.length,
                                  effect: SwapEffect(
                                    activeDotColor:
                                        themeData.colorScheme.primary,
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    type: SwapType.yRotation,
                                  ),
                                )))
                            : Container()
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.heart,
                        ))
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(
                              widget.productEntity.title,
                              style: themeData.textTheme.headlineMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          LightThemeColors.theritaryTextColor),
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RatingBar.builder(
                              itemSize: 15,
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                          ],
                        ),
                        const Divider(
                          height: 24,
                        ),
                        Text(
                          'ویژگی های محصول',
                          style: themeData.textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: LightThemeColors.theritaryTextColor),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.circle_fill,
                              size: 8,
                              color: themeData.textTheme.labelLarge!.color,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              'کد: ',
                              style: themeData.textTheme.labelLarge,
                            ),
                            Text(
                              widget.productEntity.code,
                              style: themeData.textTheme.labelLarge!.copyWith(
                                  color: LightThemeColors.primaryTextColor),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.circle_fill,
                              size: 8,
                              color: themeData.textTheme.labelLarge!.color,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              'وزن: ',
                              style: themeData.textTheme.labelLarge,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 20,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        widget.productEntity.color.length + 1,
                                    itemBuilder: ((context, index) {
                                      if (index <
                                          widget.productEntity.color.length) {
                                        return Text(
                                          '${widget.productEntity.weight[index]} , ',
                                          style: themeData.textTheme.labelLarge!
                                              .copyWith(
                                                  color: LightThemeColors
                                                      .primaryTextColor),
                                        );
                                      } else {
                                        return Text(
                                          'گرم',
                                          style: themeData.textTheme.labelLarge!
                                              .copyWith(
                                                  color: LightThemeColors
                                                      .primaryTextColor),
                                        );
                                      }
                                    })),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.circle_fill,
                              size: 8,
                              color: themeData.textTheme.labelLarge!.color,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              'رنگ: ',
                              style: themeData.textTheme.labelLarge,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 10,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        widget.productEntity.color.length,
                                    itemBuilder: ((context, index) {
                                      return Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            color: colorCalculator(widget
                                                .productEntity.color[index]),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      );
                                    })),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: productDescriptions.length, (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      child: Text(
                        productDescriptions[index],
                      ),
                    );
                  }),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Divider(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('سایز: '),
                                Text(
                                    '${widget.productEntity.weight[selectedWeightIndex]} گرم'),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(priceCalculator(
                                            widget.goleGramPrice,
                                            widget.productEntity.wage
                                                .toDouble(),
                                            widget.productEntity
                                                .weight[selectedWeightIndex],
                                            widget.productEntity.discount)
                                        .toInt()
                                        .withPriceLabel
                                        .toString())
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.productEntity.weight.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  width: 70,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: selectedWeightIndex == index
                                              ? LightThemeColors
                                                  .theritaryTextColor
                                                  .withOpacity(0.5)
                                              : LightThemeColors.secoundryColor
                                                  .withOpacity(0.1)),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      setState(() {
                                        selectedWeightIndex = index;
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        '${widget.productEntity.weight[index]} گرم',
                                        style: themeData.textTheme.labelMedium!
                                            .copyWith(
                                                color: LightThemeColors
                                                    .primaryTextColor),
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Divider(
                          height: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('رنگ: '),
                                Text(selectedColor),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.productEntity.color.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.only(left: 8),
                                  width: 70,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: selectedColor ==
                                                  widget.productEntity
                                                      .color[index]
                                              ? LightThemeColors
                                                  .theritaryTextColor
                                                  .withOpacity(0.5)
                                              : LightThemeColors.secoundryColor
                                                  .withOpacity(0.1)),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      setState(() {
                                        selectedColor =
                                            widget.productEntity.color[index];
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: colorCalculator(widget
                                                    .productEntity
                                                    .color[index])),
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            color: colorCalculator(widget
                                                    .productEntity.color[index])
                                                .withOpacity(0.5),
                                          ),
                                          height: 18,
                                          width: 18,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          widget.productEntity.color[index],
                                          style: themeData
                                              .textTheme.labelMedium!
                                              .copyWith(
                                                  color: LightThemeColors
                                                      .primaryTextColor),
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Divider(
                          height: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(
                  height: 100,
                )
                    //     CommentList(
                    //   comments: widget.productEntity.comments,
                    // )
                    ),
              ],
            ),
          ),
        ));
  }
}
