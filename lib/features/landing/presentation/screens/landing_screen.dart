import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/domain/utils/utils.dart';
import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/theme/design_tokens.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';
import 'package:crowdvise/features/auth/presentation/screens/login.dart';
import 'package:crowdvise/features/auth/presentation/screens/register.dart';
import 'package:crowdvise/features/landing/presentation/data/landing_content.dart';
import 'package:crowdvise/features/landing/presentation/widgets/facet_backdrop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  static const id = '/landing';

  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _scroll = ScrollController();
  final _aboutKey = GlobalKey();
  final _servicesKey = GlobalKey();
  final _faqKey = GlobalKey();
  final _teamKey = GlobalKey();

  // Scroll-driven state lives in notifiers so only the hero backdrop and the
  // nav bar rebuild on scroll — never the whole CustomScrollView.
  final _offset = ValueNotifier<double>(0);
  final _navSolid = ValueNotifier<bool>(false);
  final _progress = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _markSeen();
  }

  Future<void> _markSeen() async {
    final prefs = await getIt.getAsync<SharedPreferences>();
    await prefs.setBool(onboardingKey, true);
  }

  void _onScroll() {
    final o = _scroll.offset;
    _navSolid.value = o > 48;
    // Parallax only matters while the hero is on screen.
    if (o < 1000) _offset.value = o;
    if (_scroll.hasClients) {
      final max = _scroll.position.maxScrollExtent;
      _progress.value = max <= 0 ? 0 : (o / max).clamp(0.0, 1.0);
    }
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _offset.dispose();
    _navSolid.dispose();
    _progress.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: 0.08,
    );
  }

  void _goLogin() => context.pushNamed(LoginScreen.id);
  void _goRegister() => context.pushNamed(RegisterScreen.id);

  @override
  Widget build(BuildContext context) {
    final wide = Responsive.isDesktop(context) || Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: ink,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scroll,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _Hero(
                  scrollOffset: _offset,
                  wide: wide,
                  onPrimary: _goRegister,
                  onSecondary: () => _scrollTo(_aboutKey),
                ),
              ),
              sliverSection(
                key: _aboutKey,
                child: _AboutLifecycle(wide: wide),
              ),
              sliverSection(
                key: _servicesKey,
                child: _ServicesSection(wide: wide),
              ),
              sliverSection(
                key: _faqKey,
                child: _FaqSection(wide: wide),
              ),
              sliverSection(
                key: _teamKey,
                child: _TeamSection(wide: wide),
              ),
              SliverToBoxAdapter(
                child: RepaintBoundary(
                  child: _ClosingCta(wide: wide, onStart: _goRegister),
                ),
              ),
              const SliverToBoxAdapter(child: _Footer()),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<bool>(
              valueListenable: _navSolid,
              builder: (_, solid, _) => _LandingNav(
                solid: solid,
                wide: wide,
                onLogo: () => _scroll.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                ),
                onAbout: () => _scrollTo(_aboutKey),
                onServices: () => _scrollTo(_servicesKey),
                onFaq: () => _scrollTo(_faqKey),
                onTeam: () => _scrollTo(_teamKey),
                onLogin: _goLogin,
                onStart: _goRegister,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: ValueListenableBuilder<double>(
                valueListenable: _progress,
                builder: (_, value, _) => Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: value,
                    child: const SizedBox(
                      height: 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [signal, Color(0xFFFFB38A)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Each section is a repaint boundary so scrolling re-composites cached
  /// layers instead of re-rasterizing text and custom painters every frame.
  Widget sliverSection({required GlobalKey key, required Widget child}) {
    return SliverToBoxAdapter(
      child: KeyedSubtree(
        key: key,
        child: RepaintBoundary(child: child),
      ),
    );
  }
}

// ── Nav ──────────────────────────────────────────────────────────────────────

class _LandingNav extends StatelessWidget {
  const _LandingNav({
    required this.solid,
    required this.wide,
    required this.onLogo,
    required this.onAbout,
    required this.onServices,
    required this.onFaq,
    required this.onTeam,
    required this.onLogin,
    required this.onStart,
  });

  final bool solid;
  final bool wide;
  final VoidCallback onLogo;
  final VoidCallback onAbout;
  final VoidCallback onServices;
  final VoidCallback onFaq;
  final VoidCallback onTeam;
  final VoidCallback onLogin;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: DesignTokens.animNormal,
      padding: EdgeInsets.symmetric(
        horizontal: wide ? 40 : 20,
        vertical: solid ? 12 : 18,
      ),
      decoration: BoxDecoration(
        color: solid ? ink.withValues(alpha: 0.92) : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: solid ? Colors.white.withValues(alpha: 0.06) : Colors.transparent,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DesignTokens.contentMaxWidth),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onLogo,
                  child: const SvgImage(
                    asset: crowdviseLogo,
                    height: 44,
                  ),
                ),
                const Spacer(),
                if (wide) ...[
                  _NavLink(label: 'Platform', onTap: onAbout),
                  _NavLink(label: 'Services', onTap: onServices),
                  _NavLink(label: 'FAQ', onTap: onFaq),
                  _NavLink(label: 'Team', onTap: onTeam),
                  const Gap(20),
                  TextButton(
                    onPressed: onLogin,
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Gap(8),
                  _PillButton(label: 'Get started', onTap: onStart, compact: true),
                ] else ...[
                  TextButton(
                    onPressed: onLogin,
                    child: const Text(
                      'Log in',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                  _PillButton(label: 'Start', onTap: onStart, compact: true),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white60,
          textStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _PillButton extends StatefulWidget {
  const _PillButton({
    required this.label,
    required this.onTap,
    this.compact = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool compact;

  @override
  State<_PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<_PillButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: DesignTokens.animFast,
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 16 : 22,
            vertical: widget.compact ? 10 : 14,
          ),
          decoration: BoxDecoration(
            color: _hover ? signalSoft : signal,
            borderRadius: BorderRadius.circular(10),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: signal.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: white,
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w700,
              fontSize: widget.compact ? 13 : 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _GhostButton extends StatefulWidget {
  const _GhostButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<_GhostButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: DesignTokens.animFast,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            color: _hover ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: white,
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Hero ─────────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  const _Hero({
    required this.scrollOffset,
    required this.wide,
    required this.onPrimary,
    required this.onSecondary,
  });

  final ValueListenable<double> scrollOffset;
  final bool wide;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final heroH = wide ? h.clamp(640.0, 900.0) : h.clamp(620.0, 820.0);

    return SizedBox(
      height: heroH,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        // Parallax Transform must stay clipped or facets bleed into
        // the next section and composite on top of the paper content.
        clipBehavior: Clip.hardEdge,
        children: [
          // Only the backdrop rebuilds on scroll; the copy below is static.
          RepaintBoundary(
            child: ValueListenableBuilder<double>(
              valueListenable: scrollOffset,
              builder: (_, o, _) => ParallaxFacetBackdrop(scrollOffset: o),
            ),
          ),
          // Soft left wash so type stays readable
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0x8C07080C), // ink @ 55%
                  Color(0x0007080C),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(wide ? 40 : 24, 88, wide ? 40 : 24, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      Text(
                        LandingContent.brand,
                        style: TextStyle(
                          fontFamily: 'Syne',
                          fontSize: wide ? 56 : 40,
                          fontWeight: FontWeight.w800,
                          color: white,
                          letterSpacing: -0.4,
                          height: 1,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 700.ms)
                          .slideY(begin: 0.12, curve: Curves.easeOutCubic),
                      const Gap(18),
                      Text(
                        LandingContent.tagline,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3.2,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                      ).animate().fadeIn(delay: 120.ms, duration: 600.ms),
                      const Gap(28),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${LandingContent.heroLead}\n',
                              style: TextStyle(
                                fontFamily: 'Syne',
                                fontSize: wide ? 40 : 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.92),
                                height: 1.2,
                                letterSpacing: 0,
                              ),
                            ),
                            TextSpan(
                              text: LandingContent.heroEmphasis,
                              style: TextStyle(
                                fontFamily: 'Syne',
                                fontSize: wide ? 40 : 28,
                                fontWeight: FontWeight.w800,
                                color: white,
                                height: 1.2,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(delay: 180.ms, duration: 700.ms)
                          .slideY(begin: 0.1, delay: 180.ms),
                      const Gap(20),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Text(
                          LandingContent.heroSupport,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: wide ? 17 : 15,
                            height: 1.55,
                            color: Colors.white.withValues(alpha: 0.58),
                          ),
                        ),
                      ).animate().fadeIn(delay: 280.ms, duration: 700.ms),
                      const Gap(36),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _PillButton(label: 'Start free research', onTap: onPrimary),
                          _GhostButton(label: 'See how it works', onTap: onSecondary),
                        ],
                      ).animate().fadeIn(delay: 380.ms, duration: 650.ms),
                      const Spacer(flex: 2),
                      _ScrollCue().animate().fadeIn(delay: 700.ms),
                      const Gap(20),
                    ],
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

class _ScrollCue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 22,
          height: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                width: 3,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(2),
                ),
              )
                  // Finite loop: an infinite animation keeps the raster
                  // thread busy for the lifetime of the page.
                  .animate(onPlay: (c) => c.repeat(count: 4))
                  .moveY(begin: 0, end: 8, duration: 900.ms, curve: Curves.easeInOut)
                  .then()
                  .fadeOut(duration: 200.ms)
                  .then()
                  .fadeIn(duration: 200.ms),
            ),
          ),
        ),
      ],
    );
  }
}

// ── About / lifecycle ────────────────────────────────────────────────────────

class _AboutLifecycle extends StatefulWidget {
  const _AboutLifecycle({required this.wide});

  final bool wide;

  @override
  State<_AboutLifecycle> createState() => _AboutLifecycleState();
}

class _AboutLifecycleState extends State<_AboutLifecycle> {
  int stageIndex = 0;

  void onStage(int i) {
    if (i != stageIndex) setState(() => stageIndex = i);
  }

  @override
  Widget build(BuildContext context) {
    final wide = widget.wide;
    final stage = LandingContent.stages[stageIndex];

    return ColoredBox(
      color: paper,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned.fill(child: PaperTexture()),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: DesignTokens.contentMaxWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 40 : 24,
                  vertical: wide ? 96 : 64,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LandingContent.aboutEyebrow,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.8,
                        color: signal,
                      ),
                    ),
                    const Gap(16),
                    Text(
                      LandingContent.aboutTitle,
                      style: TextStyle(
                        fontFamily: 'Syne',
                        fontSize: wide ? 40 : 28,
                        fontWeight: FontWeight.w800,
                        color: slate,
                        height: 1.2,
                        // Syne ExtraBold collides with negative tracking.
                        letterSpacing: 0,
                      ),
                    ),
                    const Gap(16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Text(
                        LandingContent.aboutBody,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16,
                          height: 1.6,
                          color: slateMuted,
                        ),
                      ),
                    ),
                    const Gap(36),
                    _MetricsStrip(wide: wide),
                    const Gap(44),
                    // Stage rail
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var i = 0; i < LandingContent.stages.length; i++) ...[
                            if (i > 0)
                              Container(
                                width: 28,
                                height: 1,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                color: slate.withValues(alpha: 0.15),
                              ),
                            _StageChip(
                              label: LandingContent.stages[i].label,
                              selected: i == stageIndex,
                              onTap: () => onStage(i),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Gap(36),
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: _StageCopy(stage: stage)),
                          const Gap(40),
                          Expanded(flex: 6, child: _StagePreview(index: stageIndex)),
                        ],
                      )
                    else ...[
                      _StageCopy(stage: stage),
                      const Gap(28),
                      _StagePreview(index: stageIndex),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsStrip extends StatelessWidget {
  const _MetricsStrip({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final metrics = LandingContent.metrics;
    if (!wide) {
      return Wrap(
        spacing: 32,
        runSpacing: 24,
        children: [
          for (final metric in metrics)
            SizedBox(width: 150, child: _MetricTile(metric: metric)),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < metrics.length; i++) ...[
          if (i > 0)
            Container(
              width: 1,
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: slate.withValues(alpha: 0.12),
            ),
          Expanded(child: _MetricTile(metric: metrics[i])),
        ],
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric});

  final LandingMetric metric;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: metric.value.toDouble()),
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      builder: (_, value, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: value.round().toString()),
                if (metric.suffix.isNotEmpty)
                  TextSpan(
                    text: metric.suffix,
                    style: TextStyle(
                      fontSize: 18,
                      color: signal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            style: const TextStyle(
              fontFamily: 'Syne',
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: slate,
              height: 1,
            ),
          ),
          const Gap(8),
          Text(
            metric.label.toUpperCase(),
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: slateMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _StageChip extends StatelessWidget {
  const _StageChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: DesignTokens.animNormal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? slate : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? slate : slate.withValues(alpha: 0.18),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: selected ? white : slateMuted,
          ),
        ),
      ),
    );
  }
}

class _StageCopy extends StatelessWidget {
  const _StageCopy({required this.stage});
  final LandingStage stage;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: DesignTokens.animNormal,
      child: Column(
        key: ValueKey(stage.id),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stage.title,
            style: const TextStyle(
              fontFamily: 'Syne',
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: slate,
              height: 1.25,
            ),
          ),
          const Gap(14),
          Text(
            stage.body,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 15,
              height: 1.65,
              color: slateMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _StagePreview extends StatelessWidget {
  const _StagePreview({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: DesignTokens.animSlow,
      child: Container(
        key: ValueKey(index),
        height: 280,
        decoration: BoxDecoration(
          color: ink,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: slate.withValues(alpha: 0.18),
              blurRadius: 40,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            const Positioned.fill(
              child: FacetBackdrop(intensity: 0.7, fillBottom: false),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: switch (index) {
                0 => const _PreviewDescribe(),
                1 => const _PreviewAssemble(),
                2 => const _PreviewSimulate(),
                _ => const _PreviewDecide(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewDescribe extends StatelessWidget {
  const _PreviewDescribe();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PRODUCT BRIEF',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        const Gap(14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: const Text(
            'A B2B expense card for remote teams. Instant virtual cards, receipt capture, and weekly spend digests for finance.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
              fontFamily: 'PlusJakartaSans',
            ),
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: signal,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Generate journey →',
              style: TextStyle(
                color: white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PreviewAssemble extends StatelessWidget {
  const _PreviewAssemble();

  @override
  Widget build(BuildContext context) {
    final faces = ['CF', 'AM', 'JL', 'RK', 'TP', 'NS'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PANEL · 24 PERSONAS',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        const Gap(18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final f in faces)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                alignment: Alignment.center,
                child: Text(
                  f,
                  style: const TextStyle(
                    color: white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const Spacer(),
        Text(
          'Finance leads · Startups · Mid-market ops',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _PreviewSimulate extends StatelessWidget {
  const _PreviewSimulate();

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Converted', statusReady, '“Weekly digests sell me.”'),
      ('Hesitant', statusWarning, '“Need SSO before I trust it.”'),
      ('Dropped', statusDanger, '“Pricing unclear on step 2.”'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LIVE REACTIONS',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        const Gap(14),
        for (final r in rows) ...[
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: r.$2, shape: BoxShape.circle),
                ),
                const Gap(10),
                Text(
                  r.$1,
                  style: const TextStyle(
                    color: white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    r.$3,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _PreviewDecide extends StatelessWidget {
  const _PreviewDecide();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ADOPTION SCORE',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        const Gap(20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              '72',
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 64,
                fontWeight: FontWeight.w800,
                color: white,
                height: 0.9,
              ),
            ),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '/ 100',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const Gap(8),
        Text(
          'Ready with fixes',
          style: TextStyle(
            color: statusReady,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Text(
          '1. Clarify pricing on step 2\n2. Add SSO mention in hero\n3. Shorten receipt onboarding',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ── Services ─────────────────────────────────────────────────────────────────

class _ServicesSection extends StatelessWidget {
  const _ServicesSection({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ink,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DesignTokens.contentMaxWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: wide ? 40 : 24,
              vertical: wide ? 96 : 64,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SERVICES',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.8,
                    color: signal,
                  ),
                ),
                const Gap(14),
                Text(
                  'What we provide.',
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: wide ? 40 : 28,
                    fontWeight: FontWeight.w800,
                    color: white,
                    letterSpacing: 0,
                  ),
                ),
                const Gap(48),
                for (var i = 0; i < LandingContent.services.length; i++) ...[
                  _ServiceRow(
                    service: LandingContent.services[i],
                    wide: wide,
                    reverse: wide && i.isOdd,
                  ),
                  if (i < LandingContent.services.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36),
                      child: Divider(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.service,
    required this.wide,
    required this.reverse,
  });

  final LandingService service;
  final bool wide;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              service.number,
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: signal,
              ),
            ),
            const Gap(12),
            Text(
              service.eyebrow,
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2.4,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
        const Gap(16),
        Text(
          service.title,
          style: TextStyle(
            fontFamily: 'Syne',
            fontSize: wide ? 28 : 22,
            fontWeight: FontWeight.w700,
            color: white,
            height: 1.2,
          ),
        ),
        const Gap(12),
        Text(
          service.body,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 15,
            height: 1.6,
            color: Colors.white.withValues(alpha: 0.55),
          ),
        ),
      ],
    );

    final visual = Container(
      height: wide ? 200 : 160,
      decoration: BoxDecoration(
        color: inkElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: CustomPaint(
        painter: _ServiceMarkPainter(index: int.parse(service.number) - 1),
        child: const SizedBox.expand(),
      ),
    );

    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          copy,
          const Gap(20),
          visual,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: reverse
          ? [
              Expanded(child: visual),
              const Gap(48),
              Expanded(child: copy),
            ]
          : [
              Expanded(child: copy),
              const Gap(48),
              Expanded(child: visual),
            ],
    );
  }
}

class _ServiceMarkPainter extends CustomPainter {
  _ServiceMarkPainter({required this.index});
  final int index;

  @override
  void paint(Canvas canvas, Size size) {
    final accent = Paint()..color = signal.withValues(alpha: 0.7);
    final mute = Paint()..color = Colors.white.withValues(alpha: 0.08);

    switch (index) {
      case 0:
        for (var i = 0; i < 5; i++) {
          canvas.drawCircle(
            Offset(size.width * (0.25 + i * 0.12), size.height * 0.5),
            18 - i * 1.5,
            i == 2 ? accent : mute,
          );
        }
      case 1:
        final path = Path()
          ..moveTo(size.width * 0.15, size.height * 0.7)
          ..lineTo(size.width * 0.35, size.height * 0.45)
          ..lineTo(size.width * 0.55, size.height * 0.55)
          ..lineTo(size.width * 0.85, size.height * 0.25);
        canvas.drawPath(
          path,
          Paint()
            ..color = signal
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
      case 2:
        for (var i = 0; i < 3; i++) {
          final rect = RRect.fromRectAndRadius(
            Rect.fromLTWH(
              size.width * 0.18,
              size.height * (0.22 + i * 0.22),
              size.width * 0.64,
              28,
            ),
            const Radius.circular(8),
          );
          canvas.drawRRect(rect, i == 1 ? accent : mute);
        }
      default:
        canvas.drawCircle(
          Offset(size.width * 0.5, size.height * 0.5),
          46,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.06)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 10,
        );
        canvas.drawArc(
          Rect.fromCircle(
            center: Offset(size.width * 0.5, size.height * 0.5),
            radius: 46,
          ),
          -1.4,
          4.2,
          false,
          Paint()
            ..color = signal
            ..style = PaintingStyle.stroke
            ..strokeWidth = 10
            ..strokeCap = StrokeCap.round,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _ServiceMarkPainter oldDelegate) =>
      oldDelegate.index != index;
}

// ── FAQ ──────────────────────────────────────────────────────────────────────

class _FaqSection extends StatefulWidget {
  const _FaqSection({required this.wide});

  final bool wide;

  @override
  State<_FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<_FaqSection> {
  int? openIndex;

  void onToggle(int i) {
    setState(() => openIndex = openIndex == i ? null : i);
  }

  @override
  Widget build(BuildContext context) {
    final wide = widget.wide;
    return ColoredBox(
      color: paper,
      child: Stack(
        children: [
          const Positioned.fill(child: PaperTexture()),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 40 : 24,
                  vertical: wide ? 96 : 64,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR QUESTIONS, ANSWERED',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.8,
                        color: signal,
                      ),
                    ),
                    const Gap(14),
                    Text(
                      'FAQ',
                      style: TextStyle(
                        fontFamily: 'Syne',
                        fontSize: wide ? 40 : 28,
                        fontWeight: FontWeight.w800,
                        color: slate,
                        letterSpacing: 0,
                      ),
                    ),
                    const Gap(36),
                    for (var i = 0; i < LandingContent.faqs.length; i++)
                      _FaqTile(
                        faq: LandingContent.faqs[i],
                        open: openIndex == i,
                        onTap: () => onToggle(i),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.faq,
    required this.open,
    required this.onTap,
  });

  final LandingFaq faq;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    faq.question,
                    style: const TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: slate,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: open ? 0.125 : 0,
                  duration: DesignTokens.animNormal,
                  child: const Icon(Icons.add, color: slateMuted, size: 22),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Text(
              faq.answer,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 15,
                height: 1.6,
                color: slateMuted,
              ),
            ),
          ),
          crossFadeState:
              open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: DesignTokens.animNormal,
        ),
        Divider(height: 1, color: slate.withValues(alpha: 0.12)),
      ],
    );
  }
}

// ── Team ─────────────────────────────────────────────────────────────────────

class _TeamSection extends StatelessWidget {
  const _TeamSection({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ink,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DesignTokens.contentMaxWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: wide ? 40 : 24,
              vertical: wide ? 96 : 64,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THE TEAM',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.8,
                    color: signal,
                  ),
                ),
                const Gap(14),
                Text(
                  'Two people. One obsession.',
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: wide ? 40 : 28,
                    fontWeight: FontWeight.w800,
                    color: white,
                    letterSpacing: 0,
                  ),
                ),
                const Gap(12),
                Text(
                  'Making customer research fast enough for how products actually ship.',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const Gap(48),
                if (wide)
                  Row(
                    children: [
                      for (var i = 0; i < LandingContent.team.length; i++) ...[
                        if (i > 0) const Gap(24),
                        Expanded(child: _TeamCard(member: LandingContent.team[i])),
                      ],
                    ],
                  )
                else
                  Column(
                    children: [
                      for (var i = 0; i < LandingContent.team.length; i++) ...[
                        if (i > 0) const Gap(16),
                        _TeamCard(member: LandingContent.team[i]),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({required this.member});
  final LandingTeamMember member;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: inkElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  signal.withValues(alpha: 0.9),
                  const Color(0xFF2A3142),
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              member.initials,
              style: const TextStyle(
                fontFamily: 'Syne',
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: white,
              ),
            ),
          ),
          const Gap(20),
          Text(
            member.name,
            style: const TextStyle(
              fontFamily: 'Syne',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: white,
            ),
          ),
          const Gap(4),
          Text(
            member.role,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: signal,
            ),
          ),
          const Gap(14),
          Text(
            member.bio,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              height: 1.55,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Closing + footer ─────────────────────────────────────────────────────────

class _ClosingCta extends StatelessWidget {
  const _ClosingCta({required this.wide, required this.onStart});
  final bool wide;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: paper,
      child: Stack(
        children: [
          const Positioned.fill(child: PaperTexture()),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: wide ? 100 : 72,
              ),
              child: Column(
                children: [
                  Text(
                    'Test the product\nbefore the market does.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Syne',
                      fontSize: wide ? 44 : 30,
                      fontWeight: FontWeight.w800,
                      color: slate,
                      height: 1.2,
                      letterSpacing: 0,
                    ),
                  ),
                  const Gap(28),
                  _PillButton(label: 'Get started free', onTap: onStart),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ink,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DesignTokens.contentMaxWidth),
            child: Row(
              children: [
                const Text(
                  'CrowdVise',
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontWeight: FontWeight.w700,
                    color: white,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '© ${DateTime.now().year}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
