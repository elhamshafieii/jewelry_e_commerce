import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelry_e_commerce/data/repoditory/auth_repository.dart';
import 'package:jewelry_e_commerce/data/repoditory/cart_repository.dart';
import 'package:jewelry_e_commerce/data/repoditory/root_repository.dart';
import 'package:jewelry_e_commerce/model/auth_info.dart';
import 'package:jewelry_e_commerce/ui/animated_notch_bottom_bar/model/bottom_bar_item_model.dart';
import 'package:jewelry_e_commerce/ui/animated_notch_bottom_bar/notch_bottom_bar.dart';
import 'package:jewelry_e_commerce/ui/cart/cart.dart';
import 'package:jewelry_e_commerce/ui/favorite/favorite.dart';
import 'package:jewelry_e_commerce/ui/home/home.dart';
import 'package:jewelry_e_commerce/ui/profile/profile.dart';
import 'package:jewelry_e_commerce/ui/root/bloc/root_bloc.dart';
import 'package:jewelry_e_commerce/ui/widgets/badge.dart';
import 'package:jewelry_e_commerce/util/common.dart';
import 'package:jewelry_e_commerce/util/theme.dart';

const int homeIndex = 0;
const int cartIndex = 1;
const int favoriteIndex = 2;
const int profileIndex = 3;

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedScreenIndex = homeIndex;
  final _pageController = PageController(initialPage: homeIndex);
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<int> _history = [];
  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _cartKey = GlobalKey();
  final GlobalKey<NavigatorState> _favoriteKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();
  late final map = {
    homeIndex: _homeKey,
    cartIndex: _cartKey,
    favoriteIndex: _favoriteKey,
    profileIndex: _profileKey,
  };
  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedScreenIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => Offstage(
                    offstage: selectedScreenIndex != index, child: child)));
  }

  Future<AuthInfo> calculateUid() async {
    final AuthInfo authInfo = await authRepository.loadAuthInfo();
    return authInfo;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return FutureBuilder<AuthInfo>(
      future: calculateUid(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          cartRepository.count(snapshot.data);
        }
        return WillPopScope(
          onWillPop: _onWillPop,
          child: BlocProvider<RootBloc>(
            create: (context) {
              final rootBloc = RootBloc(
                classesRepository: classesRepository,
                cartRepository: cartRepository,
              );
              rootBloc.add(RootStarted());
              return rootBloc;
            },
            child: BlocBuilder<RootBloc, RootState>(
              builder: (context, state) {
                if (state is RootLoading) {
                  return Container(
                    color: themeData.scaffoldBackgroundColor,
                    child: const Center(
                      child: defaulProgressIndicator,
                    ),
                  );
                } else if (state is RootError) {
                  return Stack(children: [
                    Center(
                      child: Text(state.error),
                    ),
                  ]);
                } else if (state is RootSuccess) {
                  return Scaffold(
                    body: Stack(
                      children: [
                        IndexedStack(
                          index: selectedScreenIndex,
                          children: [
                            _navigator(
                                _homeKey,
                                homeIndex,
                                HomeScreen(
                                  classes: state.classes,
                                  banners: state.banners,
                                  goldPerGramPrice: state.goldPerGramPrice,
                                  recentProducts: state.recentProducts,
                                )),
                            _navigator(
                                _cartKey,
                                cartIndex,
                                CartScreen(
                                  goldGramPrice: state.goldPerGramPrice
                                )),
                            _navigator(_favoriteKey, favoriteIndex,
                                const FavoriteScreen()),
                            _navigator(_profileKey, profileIndex,
                                const ProfileScreen()),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          child: AnimatedNotchBottomBar(
                            showLabel: false,
                            color: LightThemeColors.primaryColor,
                            notchColor: LightThemeColors.primaryColor,
                            index: selectedScreenIndex,
                            onTap: (int selectedIndex) {
                              setState(() {
                                _history.remove(selectedScreenIndex);
                                _history.add(selectedScreenIndex);
                                selectedScreenIndex = selectedIndex;
                                // _pageController.animateToPage(
                                //   selectedIndex,
                                //   duration: const Duration(milliseconds: 500),
                                //   curve: Curves.easeIn,
                                // );
                              });
                            },
                            bottomBarItems: [
                              const BottomBarItem(
                                inActiveItem: Icon(
                                  CupertinoIcons.home,
                                  color: Colors.white,
                                ),
                                activeItem: Icon(
                                  CupertinoIcons.home,
                                  color: Colors.white,
                                ),
                                itemLabel: 'خانه',
                              ),
                              BottomBarItem(
                                inActiveItem:
                                    Stack(clipBehavior: Clip.none, children: [
                                  const Icon(
                                    CupertinoIcons.cart,
                                    color: Colors.white,
                                  ),
                                  Positioned(
                                    right: -10,
                                    child: ValueListenableBuilder<int>(
                                      builder: (BuildContext context, value,
                                          Widget? child) {
                                        return BadgeIcon(
                                          value: value,
                                        );
                                      },
                                      valueListenable:
                                          CartRepository.cartItemCountNotifier,
                                    ),
                                  )
                                ]),
                                activeItem:
                                    Stack(clipBehavior: Clip.none, children: [
                                  const Icon(
                                    CupertinoIcons.cart,
                                    color: Colors.white,
                                  ),
                                  Positioned(
                                    right: -10,
                                    child: ValueListenableBuilder<int>(
                                      builder: (BuildContext context, value,
                                          Widget? child) {
                                        return BadgeIcon(
                                          value: value,
                                        );
                                      },
                                      valueListenable:
                                          CartRepository.cartItemCountNotifier,
                                    ),
                                  )
                                ]),
                                itemLabel: 'سبد خرید',
                              ),
                              const BottomBarItem(
                                inActiveItem: Icon(
                                  CupertinoIcons.heart,
                                  color: Colors.white,
                                ),
                                activeItem: Icon(
                                  CupertinoIcons.heart,
                                  color: Colors.white,
                                ),
                                itemLabel: 'علاقه مندیها',
                              ),
                              const BottomBarItem(
                                inActiveItem: Icon(
                                  CupertinoIcons.person,
                                  color: Colors.white,
                                ),
                                activeItem: Icon(
                                  CupertinoIcons.person,
                                  color: Colors.white,
                                ),
                                itemLabel: 'پروفایل',
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else if (state is RootNotConnectToFireBase) {
                  return Container();
                } else {
                  throw Exception('خطای نامشخص');
                }
              },
            ),
          ),
        );
      },
    );
  }
}
