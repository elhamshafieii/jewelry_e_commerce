import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jewelry_e_commerce/ui/animated_notch_bottom_bar/model/bottom_bar_item_model.dart';
import 'package:jewelry_e_commerce/ui/root/root.dart';

import 'bottom_bar_active_item.dart';
import 'bottom_bar_inactive_item.dart';
import 'bottom_bar_painter.dart';
import 'constants/constants.dart';

/// Class to generate the NotchBottomBar
class AnimatedNotchBottomBar extends StatefulWidget {
  final int index;

  /// Controller for animation
  //final PageController pageController;

  /// List of items of bottom bar
  final List<BottomBarItem> bottomBarItems;

  /// Function called when an item was tapped
  final ValueChanged<int> onTap;

  /// Color of bottom bar
  final Color color;

  /// Boolean to show shadow
  final bool showShadow;

  /// Boolean to show bottom text
  final bool showLabel;

  /// TextStyle to show bottom text
  final TextStyle? itemLabelStyle;

  ///Boolean to show blur effect
  final bool showBlurBottomBar;

  ///Opacity
  final double blurOpacity;

  /// Filter X
  final double blurFilterX;

  /// Filter Y
  final double blurFilterY;

  /// Color of bottom bar
  final Color notchColor;

  const AnimatedNotchBottomBar(
      {Key? key,
      //required this.pageController,
      required this.bottomBarItems,
      required this.onTap,
      this.color = Colors.white,
      this.itemLabelStyle,
      this.showShadow = true,
      this.showLabel = true,
      this.showBlurBottomBar = false,
      this.blurOpacity = 0.5,
      this.blurFilterX = 5.0,
      this.blurFilterY = 10.0,
      this.notchColor = Colors.white,
      required this.index})
      : super(key: key);

  @override
  _AnimatedNotchBottomBarState createState() => _AnimatedNotchBottomBarState();
}

class _AnimatedNotchBottomBarState extends State<AnimatedNotchBottomBar> {
  late double _screenWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    const height = kHeight + kMargin * 2;

    return AnimatedBuilder(
      animation: ValueNotifier(widget.index),
      //animation: ChangeNotifier(),
      builder: (BuildContext _, Widget? child) {
        ///to set any initial page
        double scrollPosition = widget.index.toDouble();
        int currentIndex = homeIndex;

        scrollPosition = widget.index.toDouble();
        currentIndex = (widget.index.toDouble() + 0.5).toInt();

        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: widget.showBlurBottomBar ? widget.blurFilterX : 0.0,
                sigmaY: widget.showBlurBottomBar ? widget.blurFilterY : 0.0,
              ),
              child: Opacity(
                opacity: widget.showBlurBottomBar ? widget.blurOpacity : 1,
                child: CustomPaint(
                  size: Size(width, height),
                  painter: BottomBarPainter(
                      position: _itemPosByScrollPosition(scrollPosition),
                      color: widget.color,
                      showShadow: widget.showShadow,
                      notchColor: widget.notchColor),
                ),
              ),
            ),
            for (var i = 0; i < widget.bottomBarItems.length; i++) ...[
              if (i == currentIndex)
                Positioned(
                  top: kTopMargin,
                  left: kCircleRadius -
                      kCircleMargin / 2 +
                      _itemPosByScrollPosition(scrollPosition),
                  child: BottomBarActiveItem(
                    i,
                    itemWidget: widget.bottomBarItems[i].activeItem,
                    scrollPosition: scrollPosition,
                    onTap: widget.onTap,
                  ),
                ),
              if (i != currentIndex)
                Positioned(
                  top: kMargin + (kHeight - kCircleRadius * 2) / 2,
                  left: kCircleMargin + _itemPosByIndex(i),
                  child: BottomBarInActiveItem(i,
                      itemWidget: widget.bottomBarItems[i].inActiveItem,
                      label: widget.bottomBarItems[i].itemLabel,
                      onTap: widget.onTap,
                      showLabel: widget.showLabel,
                      labelStyle: widget.itemLabelStyle),
                ),
            ],
          ],
        );
      },
    );
  }

  double _firstItemPosition() {
    return (_screenWidth - kMargin * 2) * 0.1;
  }

  double _lastItemPosition() {
    return _screenWidth -
        (_screenWidth - kMargin * 2) * 0.1 -
        (kCircleRadius + kCircleMargin) * 2;
  }

  double _itemDistance() {
    return (_lastItemPosition() - _firstItemPosition()) /
        (widget.bottomBarItems.length - 1);
  }

  double _itemPosByScrollPosition(double scrollPosition) {
    return _firstItemPosition() + _itemDistance() * scrollPosition;
  }

  double _itemPosByIndex(int index) {
    return _firstItemPosition() + _itemDistance() * index;
  }
}
