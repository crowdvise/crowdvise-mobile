import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/clickable.dart';
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
            return Scaffold(
              backgroundColor: nearBlack,
              resizeToAvoidBottomInset: resizeInsets,
              appBar: appBarTitle == null
                  ? null
                  : AppBar(
                      forceMaterialTransparency: true,
                      backgroundColor: nearBlack,
                      elevation: 0,
                      centerTitle: true,
                      title: Text(
                        appBarTitle!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          color: white,
                        ),
                      ),
                      leading: leading != null || leading == true
                          ? GestureDetector(
                              onTap: () => context.pop(),
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white24,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            )
                          : null,
                      actions: actions,
                    ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children(provider, Theme.of(context)),
                  ),
                ),
              ),
              bottomNavigationBar: bottomSheet,
              floatingActionButton: floatingActionButton,
            );
          },
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
        builder: (_, provider, __) {
          return Scaffold(
            resizeToAvoidBottomInset: resizeInsets,
            backgroundColor: theme.colorScheme.surface,
            appBar: appBarTitle == null
                ? null
                : AppBar(
                    backgroundColor: theme.colorScheme.surface,
                    elevation: 0,
                    centerTitle: true,
                    title: Text(
                      appBarTitle!,
                      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                    ),
                    leading: leading != null || leading == true
                        ? Clickable(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.keyboard_arrow_left_rounded,
                              color: theme.colorScheme.onSurface,
                              size: 24,
                            ),
                          )
                        : null,
                  ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children(provider, Theme.of(context)),
                ),
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
