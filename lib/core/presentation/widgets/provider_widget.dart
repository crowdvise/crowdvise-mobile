import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:crowdvise/core/presentation/manager/custom_provider.dart';
import 'package:provider/provider.dart';

class ProviderWidget<T extends CustomProvider> extends StatelessWidget {
  const ProviderWidget({
    required this.provider,
    required this.children,
    this.padding = 20,
    this.lazy,
    this.resizeInsets,
    super.key,
    this.canPop = true,
    this.onPop,
    this.bottomSheet,
    this.floatingActionButton,
    this.leading,
    this.appBarTitle,
    this.actions,
  });

  final List<Widget> Function(T, ThemeData) children;

  final double padding;

  final bool? lazy;
  final String? appBarTitle;
  final bool? resizeInsets;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;
  final bool? leading;
  final List<Widget>? actions;

  final bool canPop;

  final void Function(bool)? onPop;

  final T provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (value, _) {
        onPop?.call(value);
      },
      child: ChangeNotifierProvider(
        create: (BuildContext context) => provider,
        lazy: lazy,
        child: Consumer<T>(
          builder: (_, provider, _) {
            return ScreenShell(
              appBarTitle: appBarTitle,
              leading: leading,
              actions: actions,
              padding: padding,
              resizeInsets: resizeInsets,
              bottomSheet: bottomSheet,
              floatingActionButton: floatingActionButton,
              children: children(provider, theme),
            );
          },
        ),
      ),
    );
  }
}

/// Screen chrome without a provider: canvas, optional toolbar, body column.
/// Use directly when a screen shares a provider owned by a parent route.
class ScreenShell extends StatelessWidget {
  const ScreenShell({
    super.key,
    required this.children,
    this.appBarTitle,
    this.leading,
    this.actions,
    this.padding = 20,
    this.resizeInsets,
    this.bottomSheet,
    this.floatingActionButton,
  });

  final List<Widget> children;
  final String? appBarTitle;
  final bool? leading;
  final List<Widget>? actions;
  final double padding;
  final bool? resizeInsets;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: resizeInsets,
      body: AppBackground(
        child: Column(
          children: [
            if (appBarTitle != null)
              _AppBar(
                title: appBarTitle!,
                theme: Theme.of(context),
                leading: leading,
                actions: actions,
              ),
            Expanded(
              child: SafeArea(
                top: appBarTitle == null,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomSheet,
      floatingActionButton: floatingActionButton,
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.title,
    required this.theme,
    this.leading,
    this.actions,
  });

  final String title;
  final ThemeData theme;
  final bool? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1000;
    // Toolbar-style header: back chevron + left-aligned title + actions,
    // with a hairline underneath. Reads as a tool, not a mobile app bar.
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: hairline)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: wide ? 24 : 12),
            child: Row(
              children: [
                if (leading == true)
                  _BackChip(onTap: () => context.pop()),
                if (leading == true) const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackChip extends StatefulWidget {
  const _BackChip({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_BackChip> createState() => _BackChipState();
}

class _BackChipState extends State<_BackChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: _hover ? wsCardHover : wsCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: hairline),
          ),
          child: const Icon(
            Icons.chevron_left_rounded,
            color: textSecondary,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class ConsumerWidget<T extends CustomProvider> extends StatelessWidget {
  final List<Widget> Function(T, ThemeData) children;

  final double padding;
  final bool? resizeInsets;
  final String? appBarTitle;
  final T provider;
  final bool canPop;
  final bool? leading;
  final Widget? bottomSheet;
  final void Function(bool)? onPop;
  final Widget? floatingActionButton;

  const ConsumerWidget({
    super.key,
    required this.provider,
    required this.children,
    this.padding = 20,
    this.resizeInsets,
    this.canPop = true,
    this.appBarTitle,
    this.onPop,
    this.leading,
    this.bottomSheet,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (value, _) {
        onPop?.call(value);
      },
      child: Consumer<T>(
        builder: (_, provider, _) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: resizeInsets,
            body: AppBackground(
              child: Column(
                children: [
                  if (appBarTitle != null)
                    _AppBar(
                      title: appBarTitle!,
                      theme: theme,
                      leading: leading,
                    ),
                  Expanded(
                    child: SafeArea(
                      top: appBarTitle == null,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children(provider, Theme.of(context)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: bottomSheet,
            floatingActionButton: floatingActionButton,
          );
        },
      ),
    );
  }
}
