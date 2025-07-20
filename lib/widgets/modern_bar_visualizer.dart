import 'package:flutter/material.dart';

class ModernBarVisualizer extends StatelessWidget {
  final List<int> numbers;
  final Set<int> highlightedIndices;
  final double maxHeight;
  final Color? accentColor;
  final bool showComparison;

  const ModernBarVisualizer({
    super.key,
    required this.numbers,
    required this.highlightedIndices,
    required this.maxHeight,
    this.accentColor,
    this.showComparison = true,
  });

  double _calculateFontSize() {
    if (numbers.length <= 20) return 14;
    if (numbers.length <= 30) return 12;
    if (numbers.length <= 40) return 10;
    return 8;
  }

  Color _getBarColor(BuildContext context, bool isHighlighted, int index) {
    final theme = Theme.of(context);
    final baseColor = accentColor ?? theme.colorScheme.primary;

    if (isHighlighted) {
      return baseColor;
    }

    // Create gradient effect based on value
    final hsl = HSLColor.fromColor(baseColor);
    final progress = numbers[index] / numbers.reduce((a, b) => a > b ? a : b);
    
    // For light theme, we'll use a different gradient strategy
    return hsl
        .withLightness(((1 - progress) * 0.3 + 0.3).clamp(0.0, 1.0))
        .withSaturation(0.7)
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    final double maxNumber = numbers.reduce((a, b) => a > b ? a : b).toDouble();
    final double fontSize = _calculateFontSize();
    final bool isComparing = highlightedIndices.isNotEmpty && showComparison;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(numbers.length, (index) {
            final bool isHighlighted = highlightedIndices.contains(index);
            final double normalizedHeight =
                (numbers[index] / maxNumber) * maxHeight;

            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Value label
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: isHighlighted
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isHighlighted
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.onBackground.withOpacity(0.7),
                    ),
                    child: Text('${numbers[index]}'),
                  ),
                  const SizedBox(height: 4),
                  // Bar
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(begin: 0, end: normalizedHeight),
                    builder: (context, value, child) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      height: value,
                      decoration: BoxDecoration(
                        color: _getBarColor(context, isHighlighted, index),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                        boxShadow: isHighlighted
                            ? [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                  // Index indicator
                  if (isComparing)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2,
                      margin: const EdgeInsets.only(top: 4),
                      color: isHighlighted
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
