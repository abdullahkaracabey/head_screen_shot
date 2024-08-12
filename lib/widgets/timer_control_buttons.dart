import 'package:flutter/material.dart';

class TimerControlButtons extends StatelessWidget {
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  const TimerControlButtons({super.key, this.onIncrement, this.onDecrement});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.loose(const Size(40, 20)),
            onPressed: onIncrement,
            icon: Icon(Icons.arrow_drop_up, color: colorScheme.inversePrimary)),
        IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.loose(const Size(40, 20)),
            onPressed: onDecrement,
            icon: Icon(
              Icons.arrow_drop_down,
              color: colorScheme.inversePrimary,
            ))
      ],
    );
  }
}
