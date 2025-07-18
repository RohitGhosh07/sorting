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

  @override
  Widget build(BuildContext context) {
    final double maxNumber = numbers.reduce((a, b) => a > b ? a : b).toDouble();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(numbers.length, (index) {
        final bool isHighlighted = highlightedIndices.contains(index);
        final double normalizedHeight =
            (numbers[index] / maxNumber) * maxHeight;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              height: normalizedHeight,
              decoration: BoxDecoration(
                color: isHighlighted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
