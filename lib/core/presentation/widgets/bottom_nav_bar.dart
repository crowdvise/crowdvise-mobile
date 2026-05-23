import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/gradient_widget.dart';
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
    BottomNavBarItem(text: 'Session', icon: icSession),

    BottomNavBarItem(text: 'History', icon: icHistory),

    BottomNavBarItem(text: 'Account', icon: icSettings),
  ];
}

class BottomNavBar extends StatefulWidget {
  BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.currentIndex,
    this.items,
    this.height = 70.0,
    this.iconSize = 24.0,
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
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      _BottomNavBarState(selectedIndex: selectedIndex);
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  var selectedIndex = 0;

  _BottomNavBarState({required this.selectedIndex});

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _updateIndex(int index) {
    widget.onTabSelected!(index);
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> items = List.generate(widget.items!.length, (int index) {
      return _buildTabItem(
        item: widget.items![index],
        index: index,
        onPressed: _updateIndex,
        theme: theme,
      );
    });

    return BottomAppBar(
      color: nearBlack,
      height: widget.height,
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  Widget _buildTabItem({
    required BottomNavBarItem item,
    required ThemeData theme,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    final isActive = widget.currentIndex == index;

    return Clickable(
      onPressed: () {
        HapticFeedback.lightImpact();
        onPressed(index);
      },
      child: SizedBox(
        height: widget.height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastLinearToSlowEaseIn,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1.0, end: 1.5).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Curves.fastLinearToSlowEaseIn,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgImage(
                        asset: item.icon!,
                        color: isActive
                            ? electricBlue
                            : theme.colorScheme.onSurface.withAlpha(150),
                      ),
                      
                      const Gap(2),
                      GradientText(
                        text: item.text,
                        gradient: isActive
                            ? mefaraiGradient
                            : bottomNavGradient,
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontWeight: isActive
                              ? FontWeight.w400
                              : FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
