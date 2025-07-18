import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sorting_provider.dart';
import '../widgets/bar_visualizer.dart';
import '../algorithms/sorting_algorithms.dart';

class SortingScreen extends StatefulWidget {
  const SortingScreen({super.key});

  @override
  State<SortingScreen> createState() => _SortingScreenState();
}

class _SortingScreenState extends State<SortingScreen> {
  final ValueNotifier<bool> _isPaused = ValueNotifier(false);

  Future<void> startSorting(SortingProvider provider) async {
    if (provider.state == SortingState.sorting ||
        provider.state == SortingState.paused)
      return;

    provider.setState(SortingState.sorting);
    _isPaused.value = false;

    final algorithm = provider.selectedAlgorithm;
    final numbers = List<int>.from(provider.numbers);

    try {
      if (algorithm == SortingAlgorithm.bubble) {
        await SortingAlgorithms.bubbleSort(
          numbers: numbers,
          onUpdate: provider.updateNumbers,
          onHighlight: provider.setHighlightedIndices,
          isPaused: _isPaused,
          delay: 50,
        );
      } else {
        await SortingAlgorithms.mergeSort(
          numbers: numbers,
          onUpdate: provider.updateNumbers,
          onHighlight: provider.setHighlightedIndices,
          isPaused: _isPaused,
          delay: 50,
        );
      }
      provider.setState(SortingState.completed);
    } catch (e) {
      debugPrint('Error during sorting: $e');
      provider.setState(SortingState.idle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SortingProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Algorithm Selection and Controls
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Algorithm Dropdown
                        DropdownButton<SortingAlgorithm>(
                          value: provider.selectedAlgorithm,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          items: SortingAlgorithm.values.map((algorithm) {
                            return DropdownMenuItem(
                              value: algorithm,
                              child: Text(
                                algorithm.name.toUpperCase(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                          onChanged: provider.state == SortingState.idle
                              ? (algorithm) {
                                  if (algorithm != null) {
                                    provider.setAlgorithm(algorithm);
                                  }
                                }
                              : null,
                        ),
                        const SizedBox(height: 16),
                        // Control Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ControlButton(
                              icon: Icons.shuffle,
                              onPressed: provider.state == SortingState.idle
                                  ? provider.generateRandomArray
                                  : null,
                              tooltip: 'Shuffle',
                            ),
                            _ControlButton(
                              icon: Icons.play_arrow,
                              onPressed:
                                  provider.state == SortingState.idle ||
                                      provider.state == SortingState.paused
                                  ? () {
                                      if (provider.state ==
                                          SortingState.paused) {
                                        _isPaused.value = false;
                                        provider.resume();
                                      } else {
                                        startSorting(provider);
                                      }
                                    }
                                  : null,
                              tooltip: 'Start',
                            ),
                            _ControlButton(
                              icon: Icons.pause,
                              onPressed: provider.state == SortingState.sorting
                                  ? () {
                                      _isPaused.value = true;
                                      provider.pause();
                                    }
                                  : null,
                              tooltip: 'Pause',
                            ),
                            _ControlButton(
                              icon: Icons.refresh,
                              onPressed: provider.state != SortingState.sorting
                                  ? provider.reset
                                  : null,
                              tooltip: 'Reset',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Visualization Area
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return BarVisualizer(
                            numbers: provider.numbers,
                            highlightedIndices: provider.highlightedIndices,
                            maxHeight: constraints.maxHeight,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: onPressed != null
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
        ),
      ),
    );
  }
}
