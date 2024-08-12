import 'package:camera_macos/camera_macos_arguments.dart';
import 'package:camera_macos/camera_macos_controller.dart';
import 'package:camera_macos/camera_macos_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:head_screen_shot/screenshot.dart';
import 'package:head_screen_shot/widgets/timer_text_field_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool? hasCameraPermission;
  late CountdownTimerController _countdownController;
  CameraMacOSController? _cameraController;

  String? deviceId;

  var _isCaptureAllowed = false;
  var _min = 0;
  var _sec = 0;
  Uint8List? _screenShot;
  Uint8List? _headShot;

  void _onChangedMinutes(int value) {
    debugPrint('Value: $value');
    _min = value;
  }

  void _onChangedSeconds(int value) {
    debugPrint('Value: $value');
    _sec = value;
  }

  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    _countdownController = CountdownTimerController(
        endTime: DateTime.now().millisecondsSinceEpoch);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Screenshot.isAvailable().then((value) {
        setState(() {
          _isCaptureAllowed = value;
        });
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.

    _countdownController.dispose();

    super.dispose();
  }

  void _startTimer() {
    debugPrint('Timer started for $_min minutes');

    _endTime = DateTime.now().add(Duration(minutes: _min, seconds: _sec));

    _countdownController = CountdownTimerController(
        vsync: this,
        endTime: _endTime!.millisecondsSinceEpoch,
        onEnd: () {
          debugPrint('Timer ended');

          _cameraController?.takePicture().then((value) {
            _headShot = value?.bytes;
          });

          Screenshot.capture().then((Uint8List path) {
            debugPrint('Screenshot captured at $path');

            setState(() {
              _screenShot = path;
            });
          }).onError((error, stackTrace) {
            debugPrint('Error: $error');
            final String message;
            if (error is PlatformException) {
              debugPrint('Error: ${error.message}');
              message = error.message ?? 'Unknown error';
            } else {
              message = error.toString();
            }
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Error: $message')));
          });
        });

    _countdownController.start();

    setState(() {});
  }

  void _onCreateTimer() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          final colorScheme = Theme.of(context).colorScheme;
          return SizedBox(
            height: 310,
            child: Column(
              children: [
                Container(
                  color: colorScheme.secondaryContainer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        child: Text('Cancel',
                            style: Theme.of(context).textTheme.bodyMedium),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoButton(
                        child: Text('Done',
                            style: Theme.of(context).textTheme.bodyMedium),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _startTimer();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: ColoredBox(
                  color: colorScheme.tertiary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TimerTextFieldItem(
                            onChanged: _onChangedMinutes,
                            title: "Minutes",
                          ),
                          const SizedBox(width: 8),
                          TimerTextFieldItem(
                              onChanged: _onChangedSeconds, title: "Seconds")
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          );
        });
  }

  double get _widthOfImages =>
      (MediaQuery.of(context).size.width - (16 * 4)) / 2;

  _timePartText(int? timePart) {
    debugPrint("_timePartText, $timePart");
    if (timePart == null) {
      return "00";
    }

    if (timePart < 10) {
      return "0$timePart";
    }

    return timePart;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Head-Screen-Shot'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text('Welcome to the Home Screen!'),
          ),
          if (!_isCaptureAllowed)
            const Text(
                'Screenshot is not allowed! Please go Security & Privacy / Screen Recording and enable the app.'),
          Center(
              child: SizedBox(
            height: _widthOfImages / 2,
            child: CameraMacOSView(
              cameraMode: CameraMacOSMode.photo,
              onCameraInizialized: (CameraMacOSController controller) {
                _cameraController = controller;
              },
            ),
          )),
          CountdownTimer(
            controller: _countdownController,
            widgetBuilder: (_, CurrentRemainingTime? time) {
              if (time == null) {
                return const SizedBox.shrink();
              }
              return Text(
                '${_timePartText(time.min)}:${_timePartText(time.sec)}',
                style: Theme.of(context).textTheme.bodyLarge,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (_screenShot != null)
                  Image.memory(
                    _screenShot!,
                    width: _widthOfImages,
                  ),
                const SizedBox(width: 16),
                if (_headShot != null)
                  Image.memory(
                    _headShot!,
                    width: _widthOfImages,
                  ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: !_isCaptureAllowed
          ? null
          : FloatingActionButton(
              onPressed: _onCreateTimer,
              tooltip: 'Create a new Timer',
              child: const Icon(Icons.add),
            ),
    );
  }
}
