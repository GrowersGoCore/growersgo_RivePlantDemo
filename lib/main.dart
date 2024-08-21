import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Rive Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plant animation in Rive'),
        ),
        body: const CustomRiveAnimation(),
      ),
    );
  }
}

class CustomRiveAnimation extends StatefulWidget {
  const CustomRiveAnimation({super.key});

  @override
  CustomRiveAnimationState createState() => CustomRiveAnimationState();
}

class CustomRiveAnimationState extends State<CustomRiveAnimation> {
  Artboard? _artboard;
  Artboard? _facesArtboard;
  SMIInput<double>? _growInput;
  SMIInput<bool>? _happy;
  SMIInput<bool>? _regular;

  Future<void> _loadRiveFile() async {
    final file = await RiveFile.asset('assets/rive/tomato.riv');
    final facefile = await RiveFile.asset('assets/rive/faces.riv');
    var mainartboardname = 'Tomato';
    const progressImputName = 'growmain';
    const happyInputName = 'happy';
    const regularInputName = 'regular';
    final artboard = file.artboardByName(mainartboardname)?.instance();
    if (artboard != null) {
      final controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
      );
      if (controller != null) {
        artboard.addController(controller);
        _growInput = controller.findInput<double>(progressImputName);
        // _happy = controller.findInput<bool>(happyInputName);
        // _regular = controller.findInput<bool>(regularInputName);
      }
      setState(() {
        _artboard = artboard;
      });
    }

    var overlayArtboardName = 'MainFaces';
    final overlayArtboard = facefile.artboardByName(overlayArtboardName)?.instance();
    if (overlayArtboard != null) {
      final controller = StateMachineController.fromArtboard(
        overlayArtboard,
        'State Machine 1',
      );
      if (controller != null) {
        overlayArtboard.addController(controller);
        _happy = controller.findInput<bool>(happyInputName);
        _regular = controller.findInput<bool>(regularInputName);
      }
      setState(() {
        _facesArtboard = overlayArtboard;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_artboard != null)
          Rive(
            artboard: _artboard!,
            useArtboardSize: true,
            fit: BoxFit.cover,
          ),
        if (_facesArtboard != null)
          Rive(
            artboard: _facesArtboard!,
            useArtboardSize: true,
            fit: BoxFit.cover,
          ),
        Column(
          children: [
            Expanded(child: Container()),
            Slider(
              value: _growInput?.value ?? 0,
              min: 0,
              max: 150,
              onChanged: (value) {
                setState(() {
                  _growInput?.value = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _happy?.value = true;
                      _regular?.value = false;
                    });
                  },
                  child: const Text('Happy'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _happy?.value = false;
                      _regular?.value = true;
                    });
                  },
                  child: const Text('Regular'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
