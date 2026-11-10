import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/widgets/app_background.dart';
import 'package:crowdvise/core/presentation/widgets/bottom_nav_bar.dart';
import 'package:crowdvise/features/account/presentation/screens/account.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
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

/// Switches the dashboard to [index] without a page transition and without
/// rebuilding the tab's state. Pops any detail screens pushed on the inner
/// navigator so the tab root is visible.
void switchDashboardTab(BuildContext context, int index) {
  try {
    context.read<DashboardProvider>().updateIndex(index);
  } catch (_) {
    final inner = dashboardNavigatorKey.currentContext;
    if (inner != null) {
      Provider.of<DashboardProvider>(inner, listen: false).updateIndex(index);
    }
  }
  dashboardNavigatorKey.currentState?.popUntil((r) => r.isFirst);

  // Home and History read the shared provider; refresh when either becomes
  // visible so a run completed elsewhere is reflected immediately.
  if (index == 0 || index == 1) {
    try {
      context.read<HistoryProvider>().fetchHistory();
    } catch (_) {
      // Provider not mounted yet (e.g. during early navigation).
    }
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardProvider(),
      child: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          final isDesktop = Responsive.isDesktop(context);

          return Scaffold(
            backgroundColor: wsCanvas,
            resizeToAvoidBottomInset: false,
            body: AppBackground(
              child: Row(
                children: [
                  if (isDesktop)
                    ModernSidebar(
                      selectedIndex: provider.selectedIndex,
                      onDestinationSelected: (index) =>
                          switchDashboardTab(context, index),
                    ),
                  Expanded(
                    child: isDesktop
                        ? Navigator(
                            key: dashboardNavigatorKey,
                            onGenerateRoute: (_) => PageRouteBuilder(
                              pageBuilder: (_, _, _) => const _TabHost(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          )
                        : const _TabHost(),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: isDesktop
                ? null
                : BottomNavBar(
                    selectedIndex: provider.selectedIndex,
                    currentIndex: provider.selectedIndex,
                    onTabSelected: (index) => switchDashboardTab(context, index),
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

/// Root of the dashboard: all three tabs stay mounted so switching is
/// instant and no tab refetches or re-animates.
class _TabHost extends StatelessWidget {
  const _TabHost();

  @override
  Widget build(BuildContext context) {
    final index = context.select<DashboardProvider, int>((p) => p.selectedIndex);
    return IndexedStack(
      index: index,
      children: const [HomeScreen(), HistoryScreen(), AccountScreen()],
    );
  }
}
