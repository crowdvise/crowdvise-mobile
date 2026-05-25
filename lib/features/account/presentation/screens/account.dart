import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/account/presentation/manager/account_provider.dart';
import 'package:crowdvise/features/auth/presentation/screens/login.dart';
import 'package:crowdvise/features/session/presentation/manager/session_provider.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      provider: AccountProvider(),
      appBarTitle: 'Account',
      children: (provider, theme) {
        final userModel = provider.state.userModel;

        String fullName = 'Guest User';
        String initial = 'G';

        if (userModel != null) {
          final email = userModel.email;
          if (email.isNotEmpty) {
            final namePart = email.split('@').first;
            fullName = namePart;
            initial = namePart[0].toUpperCase();
          }
        }

        return [
          const Gap(40),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  // Profile Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131314),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: const Color(0xFF5B7FFF).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initial,
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF5B7FFF),
                            ),
                          ),
                        ),
                        const Gap(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName,
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                userModel?.email ?? 'No email',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 14,
                                  color: Colors.white54,
                                ),
                              ),
                              const Gap(8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  (userModel?.role ?? 'User').toUpperCase(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white70,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(40),
                  // Settings / Logout List
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF131314),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        _buildActionRow(
                          icon: Icons.logout,
                          label: 'Log out',
                          color: const Color(0xFFF24968),
                          onTap: () async {
                            await provider.logout();
                            if (context.mounted) {
                              try {
                                context.read<SessionProvider>().reset();
                                context.read<HistoryProvider>().reset();
                              } catch (_) {}
                              
                              // Use rootNavigator: true to ensure the dashboard shell is discarded
                              Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                                LoginScreen.id,
                                (route) => false,
                              );
                            }
                          },
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const Gap(16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
              ],
            ),
          ),
          if (showDivider)
            const Divider(color: Colors.white10, height: 1, indent: 56),
        ],
      ),
    );
  }
}
