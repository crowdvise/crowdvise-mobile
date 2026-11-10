import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/widgets/clickable.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class BottomNavBarItem {
  BottomNavBarItem({this.icon, required this.text});

  String? icon;
  String text;

  static List<BottomNavBarItem> get items => [
        BottomNavBarItem(text: 'Home', icon: home),
        BottomNavBarItem(text: 'History', icon: icHistory),
        BottomNavBarItem(text: 'Account', icon: icSettings),
      ];
}

/// Solid bottom bar — no BackdropFilter (full-screen blur every frame).
class BottomNavBar extends StatelessWidget {
  BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.currentIndex,
    this.items,
    this.height = 64.0,
    this.iconSize = 22.0,
    this.onTabSelected,
  }) {
    assert(items?.length == 2 || items?.length == 3);
  }

  final List<BottomNavBarItem>? items;
  final double? height;
  final double? iconSize;
  final ValueChanged<int>? onTabSelected;
  final int selectedIndex;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: const BoxDecoration(
          color: wsSidebar,
          border: Border(top: BorderSide(color: hairline)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: height,
            child: Row(
              children: List.generate(items!.length, (index) {
                final item = items![index];
                final isActive = currentIndex == index;
                return Expanded(
                  child: Clickable(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onTabSelected?.call(index);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgImage(
                          asset: item.icon!,
                          color: isActive ? textPrimary : textTertiary,
                          height: iconSize,
                        ),
                        const Gap(5),
                        Text(
                          item.text,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 11,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w500,
                            color: isActive ? textPrimary : textTertiary,
                          ),
                        ),
                        const Gap(4),
                        Container(
                          width: 16,
                          height: 2,
                          decoration: BoxDecoration(
                            color: isActive ? signal : Colors.transparent,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
