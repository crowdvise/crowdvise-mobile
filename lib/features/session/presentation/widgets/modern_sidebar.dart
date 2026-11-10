import 'package:crowdvise/core/presentation/res/drawables.dart' hide user;
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/theme/design_tokens.dart';
import 'package:crowdvise/core/presentation/widgets/bottom_nav_bar.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';
import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/domain/utils/utils.dart';
import 'package:crowdvise/features/landing/presentation/screens/landing_screen.dart';
import 'package:crowdvise/features/session/presentation/manager/session_provider.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Flat workspace sidebar. No blur, no gradients — a solid rail with
/// hairline dividers, so it composites in one pass and reads as a tool,
/// not a marketing surface.
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

  void _toggleCollapse() => setState(() => _isCollapsed = !_isCollapsed);

  Future<void> _logout() async {
    accessToken = '';
    userType = '';
    currentRole = null;
    final pref = await getIt.getAsync<SharedPreferences>();
    await pref.remove(tokenKey);
    await pref.remove(user);
    await pref.remove(currentEmail);
    await pref.remove(userRoleKey);

    if (!mounted) return;
    try {
      context.read<SessionProvider>().reset();
      context.read<HistoryProvider>().reset();
    } catch (_) {}

    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      LandingScreen.id,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = BottomNavBarItem.items;
    final width = _isCollapsed
        ? DesignTokens.sidebarCollapsedWidth
        : DesignTokens.sidebarWidth;

    return RepaintBoundary(
      child: AnimatedContainer(
        duration: DesignTokens.animNormal,
        curve: Curves.easeOutCubic,
        width: width,
        decoration: const BoxDecoration(
          color: wsSidebar,
          border: Border(right: BorderSide(color: hairline)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Brand + collapse
            SizedBox(
              height: 60,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _isCollapsed ? 0 : 16,
                ),
                child: Row(
                  mainAxisAlignment: _isCollapsed
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    _BrandMark(collapsed: _isCollapsed),
                    if (!_isCollapsed) ...[
                      _IconButton(
                        icon: Icons.keyboard_double_arrow_left_rounded,
                        onTap: _toggleCollapse,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: hairline),

            if (_isCollapsed)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: _IconButton(
                    icon: Icons.keyboard_double_arrow_right_rounded,
                    onTap: _toggleCollapse,
                  ),
                ),
              ),

            const Gap(12),

            if (!_isCollapsed)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'WORKSPACE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                    color: textTertiary,
                  ),
                ),
              ),

            // Navigation
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: _isCollapsed ? 10 : 10,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isActive = widget.selectedIndex == index;
                  return _NavRow(
                    label: item.text,
                    icon: item.icon!,
                    active: isActive,
                    collapsed: _isCollapsed,
                    onTap: () => widget.onDestinationSelected(index),
                  );
                },
              ),
            ),

            // Footer
            const Divider(height: 1, color: hairline),
            _NavRow(
              label: 'Sign out',
              iconData: Icons.logout_rounded,
              active: false,
              collapsed: _isCollapsed,
              muted: true,
              onTap: _logout,
            ),
            const Gap(8),
          ],
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.collapsed});

  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    if (collapsed) {
      return const SvgImage(
        asset: crowdviseSymbol,
        width: 28,
        height: 28,
      );
    }
    return const SvgImage(
      asset: crowdviseLogo,
      height: 40,
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 18, color: textTertiary),
      ),
    );
  }
}

class _NavRow extends StatefulWidget {
  const _NavRow({
    required this.label,
    required this.active,
    required this.collapsed,
    required this.onTap,
    this.icon,
    this.iconData,
    this.muted = false,
  });

  final String label;
  final String? icon;
  final IconData? iconData;
  final bool active;
  final bool collapsed;
  final bool muted;
  final VoidCallback onTap;

  @override
  State<_NavRow> createState() => _NavRowState();
}

class _NavRowState extends State<_NavRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final fg = widget.active
        ? textPrimary
        : widget.muted
            ? textTertiary
            : textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Tooltip(
            message: widget.collapsed ? widget.label : '',
            waitDuration: const Duration(milliseconds: 400),
            child: Container(
              height: 38,
              padding: EdgeInsets.symmetric(
                horizontal: widget.collapsed ? 0 : 10,
              ),
              decoration: BoxDecoration(
                color: widget.active
                    ? Colors.white.withValues(alpha: 0.06)
                    : _hover
                        ? Colors.white.withValues(alpha: 0.035)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: widget.collapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  if (widget.active && !widget.collapsed)
                    Container(
                      width: 2,
                      height: 16,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: signal,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  if (widget.icon != null)
                    SvgImage(
                      asset: widget.icon!,
                      color: fg,
                      width: 18,
                      height: 18,
                    )
                  else
                    Icon(widget.iconData, size: 18, color: fg),
                  if (!widget.collapsed) ...[
                    const Gap(10),
                    Expanded(
                      child: Text(
                        widget.label,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13.5,
                          color: fg,
                          fontWeight: widget.active
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
