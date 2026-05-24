import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/widgets/bottom_nav_bar.dart';
import 'package:crowdvise/features/account/presentation/screens/account.dart';
import 'package:crowdvise/features/history/presentation/screens/history.dart';
import 'package:crowdvise/features/session/presentation/manager/dashboard_provider.dart';
import 'package:crowdvise/features/session/presentation/screens/home.dart';
import 'package:crowdvise/features/session/presentation/widgets/modern_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Global key exposed so any screen can push/pop within the dashboard shell.
final dashboardNavigatorKey = GlobalKey<NavigatorState>();

class DashboardScreen extends StatefulWidget {
  static const String id = '/dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardProvider? _provider;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardProvider(),
      child: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          _provider ??= provider;
          final state = provider;
          final isDesktop = Responsive.isDesktop(context);

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Row(
              children: [
                if (isDesktop)
                  ModernSidebar(
                    selectedIndex: state.selectedIndex,
                    onDestinationSelected: (index) {
                      // When switching tabs, reset the inner navigator stack
                      dashboardNavigatorKey.currentState
                          ?.popUntil((route) => route.isFirst);
                      provider.updateIndex(index);
                    },
                  ),
                if (isDesktop)
                  const VerticalDivider(
                    width: .02,
                    color: grey900,
                  ),
                Expanded(
                  child: isDesktop
                      // Desktop: nested navigator keeps sidebar visible
                      ? Navigator(
                          key: dashboardNavigatorKey,
                          onGenerateRoute: (_) => MaterialPageRoute(
                            builder: (_) =>
                                _screens.elementAt(state.selectedIndex),
                          ),
                        )
                      // Mobile: just show the screen directly
                      : _screens.elementAt(state.selectedIndex),
                ),
              ],
            ),
            bottomNavigationBar: isDesktop
                ? null
                : BottomNavBar(
                    selectedIndex: state.selectedIndex,
                    currentIndex: state.selectedIndex,
                    onTabSelected: (index) {
                      provider.updateIndex(index);
                    },
                    items: [
                      for (final tabItem in BottomNavBarItem.items)
                        BottomNavBarItem(
                          text: tabItem.text,
                          icon: tabItem.icon,
                        ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
