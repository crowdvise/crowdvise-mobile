import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/widgets/page_header.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/account/presentation/manager/account_provider.dart';
import 'package:crowdvise/features/landing/presentation/screens/landing_screen.dart';
import 'package:crowdvise/features/session/presentation/manager/session_provider.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final pad = isDesktop ? 32.0 : 20.0;

    return ProviderWidget(
      provider: AccountProvider(),
      padding: pad,
      children: (provider, theme) {
        final userModel = provider.state.userModel;

        String fullName = 'Guest';
        String initial = 'G';
        if (userModel != null && userModel.email.isNotEmpty) {
          final namePart = userModel.email.split('@').first;
          fullName = namePart;
          initial = namePart[0].toUpperCase();
        }

        return [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(top: isDesktop ? 28 : 16, bottom: 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PageHeader(
                        eyebrow: 'Workspace',
                        title: 'Account',
                      ),
                      const Gap(24),
                      _Section(
                        title: 'Profile',
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: signal.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  fontFamily: 'Syne',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: signal,
                                ),
                              ),
                            ),
                            const Gap(14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fullName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const Gap(2),
                                  Text(
                                    userModel?.email ?? 'Not signed in',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: wsCardHover,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: hairline),
                              ),
                              child: Text(
                                (userModel?.role ?? 'User'),
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(16),
                      _Section(
                        title: 'Session',
                        padding: EdgeInsets.zero,
                        child: _Row(
                          label: 'Sign out',
                          description: 'You’ll return to the Crowdvise home page.',
                          trailing: ToolbarButton(
                            label: 'Sign out',
                            primary: false,
                            onTap: () async {
                              await provider.logout();
                              if (!context.mounted) return;
                              try {
                                context.read<SessionProvider>().reset();
                                context.read<HistoryProvider>().reset();
                              } catch (_) {}
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamedAndRemoveUntil(
                                LandingScreen.id,
                                (route) => false,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ];
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });
  final String title;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
        const Gap(10),
        Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: wsCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: hairline),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.description,
    required this.trailing,
  });
  final String label;
  final String description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const Gap(2),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12.5, color: textTertiary),
                ),
              ],
            ),
          ),
          const Gap(16),
          trailing,
        ],
      ),
    );
  }
}
