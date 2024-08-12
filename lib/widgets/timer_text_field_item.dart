import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:head_screen_shot/widgets/timer_control_buttons.dart';

typedef OnChanged = void Function(int value);

class TimerTextFieldItem extends StatefulWidget {
  final int defaultValue;
  final OnChanged onChanged;
  final String title;
  const TimerTextFieldItem(
      {super.key,
      this.defaultValue = 0,
      required this.onChanged,
      required this.title});

  @override
  State<TimerTextFieldItem> createState() => _TimerTextFieldItemState();
}

class _TimerTextFieldItemState extends State<TimerTextFieldItem> {
  late TextEditingController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = TextEditingController(text: widget.defaultValue.toString());
  }

  int get value => int.tryParse(_controller.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: textTheme.labelMedium?.copyWith(color: colorScheme.surface),
        ),
        Row(
          children: [
            SizedBox(
              width: 35,
              child: CupertinoTextField(
                placeholder: '00',
                controller: _controller,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.truncateAfterCompositionEnds),
                ],
                // decoration: BoxDecoration(
                //   color: colorScheme.secondaryContainer,
                // ),
              ),
            ),
            TimerControlButtons(
              onIncrement: () {
                var currentValue = value;
                if (currentValue >= 59) currentValue = -1;
                setState(() {
                  _controller.text = (currentValue + 1).toString();
                });
                widget.onChanged(currentValue + 1);
              },
              onDecrement: () {
                var currentValue = value;
                if (currentValue == 0) currentValue = 60;
                widget.onChanged(currentValue - 1);
                setState(() {
                  _controller.text = (currentValue - 1).toString();
                });
              },
            )
          ],
        ),
      ],
    );
  }
}
