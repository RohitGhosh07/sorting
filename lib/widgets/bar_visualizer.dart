import 'package:flutter/material.dart';

class BarVisualizer extends StatelessWidget {
  final List<int> numbers;
  final Set<int> highlightedIndices;
  final double maxHeight;

  const BarVisualizer({
    super.key,
    required this.numbers,
    required this.highlightedIndices,
    required this.maxHeight,
  });

  double _calculateFontSize() {
    if (numbers.length <= 20) return 12;
    if (numbers.length <= 30) return 10;
    if (numbers.length <= 40) return 8;
    return 6;
  }

  @override
  Widget build(BuildContext context) {
    final double maxNumber = numbers.reduce((a, b) => a > b ? a : b).toDouble();
    final double fontSize = _calculateFontSize();

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
              // Number label
              Text(
                '${numbers[index]}',
                style: TextStyle(
                  fontSize: fontSize,
                  color: isHighlighted
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                          context,
                        ).colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 2),
              // Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 50),
                  height: normalizedHeight,
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.7),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
