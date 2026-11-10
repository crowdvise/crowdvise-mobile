import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';
import 'package:crowdvise/features/landing/presentation/widgets/facet_backdrop.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Split-layout shell shared by login and register.
///
/// Left: a static brand panel reusing the landing geometry. Right: the form
/// on the plain canvas. On mobile the brand collapses to a single row.
class AuthScreenLayout extends StatelessWidget {
  const AuthScreenLayout({
    super.key,
    required this.form,
    this.heroTagline =
        'Put a product in front of a synthetic customer panel before you put it in front of real ones.',
    this.heroPills = const [],
    this.showBackButton = false,
    this.onBack,
  });

  final Widget form;
  final String heroTagline;
  final List<String> heroPills;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    if (isDesktop || isTablet) {
      return Row(
        children: [
          Expanded(
            flex: isTablet ? 5 : 6,
            child: RepaintBoundary(
              child: AuthHeroPanel(tagline: heroTagline, pills: heroPills),
            ),
          ),
          const VerticalDivider(width: 1, color: hairline),
          Expanded(
            flex: isTablet ? 6 : 5,
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 56,
                  vertical: 40,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showBackButton) ...[
                        _BackLink(onTap: onBack),
                        const Gap(28),
                      ],
                      form,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showBackButton) ...[
                _BackButton(onTap: onBack),
                const Gap(12),
              ],
              const AuthMobileBrand(),
            ],
          ),
          const Gap(32),
          form,
        ],
      ),
    );
  }
}

/// Left panel on desktop / tablet.
class AuthHeroPanel extends StatelessWidget {
  const AuthHeroPanel({super.key, required this.tagline, this.pills = const []});

  final String tagline;
  final List<String> pills;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ink,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          const FacetBackdrop(intensity: 0.8),
          SingleChildScrollView(
            padding: const EdgeInsets.all(48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _BrandRow(),
                const Gap(48),
                Text(
                  tagline,
                  style: const TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    height: 1.15,
                    letterSpacing: 0,
                  ),
                ),
                const Gap(20),
                const Text(
                  'Describe the product, review the journey, run the panel. Results in minutes, with every persona’s reasoning on record.',
                  style: TextStyle(
                    fontSize: 15,
                    color: textSecondary,
                    height: 1.6,
                  ),
                ),
                if (pills.isNotEmpty) ...[
                  const Gap(28),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [for (final p in pills) _HeroPill(label: p)],
                  ),
                ],
                const Gap(48),
                const Text(
                  '© Crowdvise',
                  style: TextStyle(fontSize: 12, color: textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandRow extends StatelessWidget {
  const _BrandRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SvgImage(
          asset: crowdviseLogo,
          height: 44,
        ),
      ],
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: inkElevated,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: hairline),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Compact brand header shown on mobile auth screens.
class AuthMobileBrand extends StatelessWidget {
  const AuthMobileBrand({super.key});

  @override
  Widget build(BuildContext context) => const _BrandRow();
}

/// Kept for call-site compatibility; the form now sits directly on the canvas.
class AuthFormCard extends StatelessWidget {
  const AuthFormCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// Sentence-case field label.
class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    );
  }
}

/// Group of fields with a quiet section heading.
class AuthFormSection extends StatelessWidget {
  const AuthFormSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = title.trim();
    final label = t.isEmpty
        ? t
        : t[0].toUpperCase() + t.substring(1).toLowerCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textTertiary,
              ),
            ),
            const Gap(10),
            const Expanded(child: Divider(height: 1, color: hairline)),
          ],
        ),
        const Gap(16),
        ...children,
      ],
    );
  }
}

/// Footer link for switching between login / register.
class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: prompt,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          color: textSecondary,
          fontSize: 13.5,
        ),
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onTap,
                child: Text(
                  action,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                    decoration: TextDecoration.underline,
                    decorationColor: hairlineStrong,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackLink extends StatelessWidget {
  const _BackLink({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap ?? () => Navigator.of(context).maybePop(),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_rounded, size: 14, color: textTertiary),
            Gap(6),
            Text(
              'Back to Crowdvise',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: wsCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: hairline),
        ),
        child: const Icon(Icons.chevron_left_rounded, color: textSecondary, size: 18),
      ),
    );
  }
}

/// Auth screen heading block.
class AuthHeading extends StatelessWidget {
  const AuthHeading({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Syne',
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.15,
          ),
        ),
        const Gap(8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
