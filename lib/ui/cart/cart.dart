import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jewelry_e_commerce/data/repoditory/auth_repository.dart';
import 'package:jewelry_e_commerce/ui/auth/auth.dart';
import 'package:jewelry_e_commerce/ui/cart/bloc/cart_bloc.dart';
import 'package:jewelry_e_commerce/ui/product_detail/product_detail_screen.dart';
import 'package:jewelry_e_commerce/ui/widgets/empty_state.dart';
import 'package:jewelry_e_commerce/util/common.dart';
import 'package:jewelry_e_commerce/util/theme.dart';

class CartScreen extends StatefulWidget {
  final int goldGramPrice;
  const CartScreen({super.key, required this.goldGramPrice});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  @override
  void initState() {
    cartBloc?.close();
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
    super.initState();
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    super.dispose();
  }

  void authChangeNotifierListener() {
    context
        .read<CartBloc>()
        .add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('سبد خرید'),
        ),
        body: BlocProvider<CartBloc>(
          create: (context) {
            final bloc = context.read<CartBloc>();
            cartBloc = bloc;
            bloc.add(CartStarted(AuthRepository.authChangeNotifier.value));
            return bloc;
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartSLoading) {
                return const Center(
                  child: defaulProgressIndicator,
                );
              } else if (state is CartError) {
                return Center(
                  child: Text(state.error),
                );
              } else if (state is CartSuccess) {
                double totalPrice = 0;
                return ListView.builder(
                    itemCount: state.cartItems.length + 2,
                    physics: defaultScrollPhysics,
                    itemBuilder: (context, index) {
                      if (index < state.cartItems.length) {
                        final cartItem = state.cartItems[index];
                        final price = priceCalculator(
                                widget.goldGramPrice,
                                cartItem.product.wage,
                                cartItem.weight,
                                cartItem.product.discount) *
                            cartItem.count;
                        totalPrice =
                            totalPrice + (price - cartItem.product.discount);
                        return Container(
                          height: 240,
                          margin: const EdgeInsets.all(8),
                          child: Card(
                            elevation: 5,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(
                                              builder: (context) {
                                        return ProductDetailScreen(
                                          productEntity: cartItem.product,
                                          goleGramPrice: widget.goldGramPrice,
                                        );
                                      }));
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: CachedNetworkImage(
                                            height: 110,
                                            width: 110,
                                            imageUrl:
                                                cartItem.product.imageUrls[0],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(cartItem.product.title),
                                            Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.star,
                                                  size: 15,
                                                  color: LightThemeColors
                                                      .primaryTextColor
                                                      .withOpacity(0.5),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  '${cartItem.weight} گرم',
                                                  style: themeData
                                                      .textTheme.labelMedium!
                                                      .copyWith(
                                                    color: LightThemeColors
                                                        .primaryTextColor
                                                        .withOpacity(0.5),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.star,
                                                  size: 15,
                                                  color: LightThemeColors
                                                      .primaryTextColor
                                                      .withOpacity(0.5),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  'رنگ ${cartItem.color}',
                                                  style: themeData
                                                      .textTheme.labelMedium!
                                                      .copyWith(
                                                    color: LightThemeColors
                                                        .primaryTextColor
                                                        .withOpacity(0.5),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons
                                                      .asterisk_circle,
                                                  size: 15,
                                                  color: LightThemeColors
                                                      .primaryTextColor
                                                      .withOpacity(0.5),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                    'گارانتی اصالت و سلامت فیزیکی کالا',
                                                    style: themeData
                                                        .textTheme.labelMedium!
                                                        .copyWith(
                                                      color: LightThemeColors
                                                          .primaryTextColor
                                                          .withOpacity(0.5),
                                                    ))
                                              ],
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 12, right: 12, bottom: 12),
                                        width: 100,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: LightThemeColors
                                                    .secoundryTextColor
                                                    .withOpacity(0.5)),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                cartBloc!.add(
                                                    CartIncreaseCountButtonClicked(
                                                        cartItem: cartItem));
                                              },
                                              child: const Icon(
                                                CupertinoIcons.add,
                                                color: LightThemeColors
                                                    .primaryColor,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            cartItem.changeCountButtomLoading
                                                ? const CupertinoActivityIndicator(
                                                    color: LightThemeColors
                                                        .primaryColor,
                                                  )
                                                : Text(
                                                    state.cartItems[index].count
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: LightThemeColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                cartItem.count == 1
                                                    ? cartBloc!.add(
                                                        CartDeleteButtonClicked(
                                                            cartItem: cartItem))
                                                    : cartBloc!.add(
                                                        CartDecreaseCountButtonClicked(
                                                            cartItem:
                                                                cartItem));
                                              },
                                              child: Icon(
                                                cartItem.count == 1
                                                    ? CupertinoIcons.bin_xmark
                                                    : CupertinoIcons.minus,
                                                color: LightThemeColors
                                                    .primaryColor,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            price.withPriceLabel.toString(),
                                            style: themeData
                                                .textTheme.bodySmall!
                                                .copyWith(
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                          ),
                                          Text((price -
                                                  cartItem.product.discount)
                                              .withPriceLabel),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 0,
                                  thickness: 1,
                                ),
                                TextButton(
                                    onPressed: () {
                                      cartBloc!.add(CartDeleteButtonClicked(
                                          cartItem: cartItem));
                                    },
                                    child: cartItem.deleteButtomLoading
                                        ? const CupertinoActivityIndicator()
                                        : Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child:
                                                const Text('حذف از سبد خرید')))
                              ],
                            ),
                          ),
                        );
                      } else if (index == state.cartItems.length) {
                        return Container(
                          height: 100,
                          margin: const EdgeInsets.all(8),
                          child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('ادامه فرایند خرید')),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'جمع سبد خرید',
                                        style: themeData.textTheme.bodySmall,
                                      ),
                                      Text(totalPrice
                                          .round()
                                          .withPriceLabel
                                          .toString())
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 100,
                        );
                      }
                    });
              } else if (state is CartAuthRequired) {
                return EmptyView(
                    message:
                        'برای دیدن سبد خرید لطفا وارد حساب کاربری خود شوید',
                    callToAction: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(builder: ((context) {
                            return const AuthScreen();
                          })));
                        },
                        child: const Text('ورود به حساب کاربری')),
                    image: SvgPicture.asset(
                      'assets/images/auth_required.svg',
                      width: 140,
                    ));
              } else if (state is CartEmpty) {
                return EmptyView(
                    message: 'سبد خرید خالی است',
                    image: SvgPicture.asset(
                      'assets/images/empty_cart.svg',
                      width: 200,
                    ));
              } else {
                throw Exception('state is not supported');
              }
            },
          ),
        ));
  }
}
