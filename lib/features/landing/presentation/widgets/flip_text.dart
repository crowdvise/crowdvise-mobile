import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A restrained 3D word flip for landing headlines.
///
/// Words rotate in around the X axis with a short stagger. One controller
/// drives the whole line, so the cost stays flat regardless of word count.
class FlipText extends StatefulWidget {
  const FlipText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.left,
    this.duration = const Duration(milliseconds: 620),
    this.stagger = const Duration(milliseconds: 32),
    this.animateOnMount = true,
  });

  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final Duration duration;
  final Duration stagger;
  final bool animateOnMount;

  @override
  State<FlipText> createState() => _FlipTextState();
}

class _FlipTextState extends State<FlipText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.animateOnMount) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant FlipText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Text(
        widget.text,
        style: widget.style,
        textAlign: widget.textAlign,
      );
    }

    final lines = widget.text.split('\n');
    final wordCount = lines.fold<int>(
      0,
      (sum, line) => sum + line.split(' ').where((w) => w.isNotEmpty).length,
    );
    final stagger = wordCount <= 1
        ? 0.0
        : (widget.stagger.inMilliseconds / widget.duration.inMilliseconds)
            .clamp(0.0, 0.2);
    final span = (1 - stagger * (wordCount - 1)).clamp(0.2, 1.0);

    final crossAxisAlignment = switch (widget.textAlign) {
      TextAlign.center => CrossAxisAlignment.center,
      TextAlign.right || TextAlign.end => CrossAxisAlignment.end,
      _ => CrossAxisAlignment.start,
    };
    final wrapAlignment = switch (widget.textAlign) {
      TextAlign.center => WrapAlignment.center,
      TextAlign.right || TextAlign.end => WrapAlignment.end,
      _ => WrapAlignment.start,
    };

    return Semantics(
      label: widget.text,
      container: true,
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            var index = 0;
            return Column(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final line in lines)
                  Wrap(
                    alignment: wrapAlignment,
                    spacing: (widget.style.fontSize ?? 16) * 0.26,
                    children: [
                      for (final word
                          in line.split(' ').where((w) => w.isNotEmpty))
                        _FlipWord(
                          word: word,
                          progress: _progressFor(
                            index++,
                            wordCount,
                            stagger,
                            span,
                          ),
                          style: widget.style,
                        ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  double _progressFor(
    int index,
    int total,
    double stagger,
    double span,
  ) {
    if (total <= 1) {
      return Curves.easeOutCubic.transform(_controller.value);
    }
    final start = index * stagger;
    final raw = ((_controller.value - start) / span).clamp(0.0, 1.0);
    return Curves.easeOutCubic.transform(raw);
  }
}

class _FlipWord extends StatelessWidget {
  const _FlipWord({
    required this.word,
    required this.progress,
    required this.style,
  });

  final String word;
  final double progress;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final angle = (1 - progress) * -math.pi / 2;
    final matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.0015)
      ..rotateX(angle);

    return Transform(
      alignment: Alignment.center,
      transform: matrix,
      child: Opacity(
        opacity: progress.clamp(0.0, 1.0),
        child: Text(word, style: style),
      ),
    );
  }
}
