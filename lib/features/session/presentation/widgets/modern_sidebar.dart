import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/bottom_nav_bar.dart';
import 'package:crowdvise/core/presentation/widgets/clickable.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';
import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/domain/utils/utils.dart';
import 'package:crowdvise/features/auth/presentation/screens/login.dart';
import 'package:crowdvise/features/session/presentation/manager/session_provider.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ModernSidebar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const ModernSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  State<ModernSidebar> createState() => _ModernSidebarState();
}

class _ModernSidebarState extends State<ModernSidebar> {
  bool _isCollapsed = false;

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = BottomNavBarItem.items;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _isCollapsed ? 80 : 280,
      decoration: const BoxDecoration(
        color: nearBlack,
        border: Border(right: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white10, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!_isCollapsed)
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: electricBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'C',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Gap(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Crowdvise',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Enterprise Dashboard',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white54,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_isCollapsed)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: electricBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'C',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                if (!_isCollapsed)
                  Clickable(
                    onPressed: _toggleCollapse,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.white54,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Collapse button when collapsed (centered)
          if (_isCollapsed)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: Clickable(
                  onPressed: _toggleCollapse,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white54,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),

          const Gap(16),

          // Navigation Links
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: _isCollapsed ? 12 : 16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isActive = widget.selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Clickable(
                    onPressed: () => widget.onDestinationSelected(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: _isCollapsed ? 0 : 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? electricBlue.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: _isCollapsed
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          SvgImage(
                            asset: item.icon!,
                            color: isActive ? electricBlue : Colors.white54,
                            width: 20,
                            height: 20,
                          ),
                          if (!_isCollapsed)
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                child: Row(
                                  children: [
                                    const Gap(12),
                                    Text(
                                      item.text,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: isActive ? electricBlue : Colors.white70,
                                        fontWeight: isActive
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Profile Section
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white10, width: 1)),
            ),
            child: Column(
              children: [
                // Profile
                // Padding(
                //   padding: EdgeInsets.all(_isCollapsed ? 16 : 20),
                //   child: Row(
                //     mainAxisAlignment: _isCollapsed
                //         ? MainAxisAlignment.center
                //         : MainAxisAlignment.start,
                //     children: [
                //       Container(
                //         width: 36,
                //         height: 36,
                //         decoration: BoxDecoration(
                //           color: Colors.white.withValues(alpha: 0.1),
                //           shape: BoxShape.circle,
                //         ),
                //         alignment: Alignment.center,
                //         child: const Text(
                //           'JD',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.w600,
                //             fontSize: 14,
                //           ),
                //         ),
                //       ),
                //       if (!_isCollapsed)
                //         Expanded(
                //           child: SingleChildScrollView(
                //             scrollDirection: Axis.horizontal,
                //             physics: const NeverScrollableScrollPhysics(),
                //             child: Row(
                //               children: [
                //                 const Gap(12),
                //                 Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Text(
                //                       'John Doe',
                //                       style: theme.textTheme.bodyMedium?.copyWith(
                //                         fontWeight: FontWeight.w600,
                //                         color: Colors.white,
                //                       ),
                //                     ),
                //                     Text(
                //                       'Senior Administrator',
                //                       style: theme.textTheme.bodySmall?.copyWith(
                //                         color: Colors.white54,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //     ],
                //   ),
                // ),
                // Logout
                Clickable(
                  onPressed: () async {
                    final pref = await getIt.getAsync<SharedPreferences>();
                    await pref.remove(tokenKey);
                    await pref.remove(user);
                    await pref.remove(currentEmail);

                    if (context.mounted) {
                      try {
                        context.read<SessionProvider>().reset();
                        context.read<HistoryProvider>().reset();
                      } catch (_) {}
                      
                      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                        LoginScreen.id,
                        (route) => false,
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _isCollapsed ? 0 : 20,
                      vertical: 16,
                    ),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: _isCollapsed
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.logout,
                          color: Color(
                            0xFFF24968,
                          ), // Red dropout color used in app
                          size: 20,
                        ),
                        if (!_isCollapsed)
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              child: Row(
                                children: [
                                  const Gap(12),
                                  Text(
                                    'Logout',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFFF24968),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
