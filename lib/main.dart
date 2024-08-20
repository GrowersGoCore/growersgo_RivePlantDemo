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
  //_artboard is the artboard we are going to display in this section
  //_growInput is the artboard controller input used to progress the plat grow
  //_happy is the artboard controller input used to set the face happy
  //_regular is the artboard controller input used to set the face regular
  Artboard? _artboard;
  SMIInput<double>? _growInput;
  SMIInput<bool>? _happy;
  SMIInput<bool>? _regular;

  Future<void> _loadRiveFile() async {
    // get the rive file
    final file = await RiveFile.asset('assets/rive/tomato.riv');

    // get the main plant artboard'
    var mainartboardname = 'MainTomato';//in the file are multiples artboards we use MainThePlantWeNeed to display it
    //all the Main plant artboards need to have this inputs in the rive file to work and the same names
    const progressImputName = 'growmain';
    const happyInputName = 'happy';
    const regularInputName='regular';
    final artboard = file.artboardByName(mainartboardname)?.instance();
    if (artboard != null) {
      final controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
      );
      if (controller != null) {
        artboard.addController(controller);
        _growInput = controller.findInput<double>(progressImputName);
        _happy = controller.findInput<bool>(happyInputName);
        _regular = controller.findInput<bool>(regularInputName);
      }
      setState(() {
        _artboard = artboard;
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
    return Column(
      children: [
        Expanded(
          child: Rive(
            artboard: _artboard!,
            useArtboardSize: true,
          ),
        ),
        // Slider to controll the plant grow value
        Slider(
          value: _growInput?.value ?? 0,
          min: 0,
          max: 60,
          onChanged: (value) {
            setState(() {
              _growInput?.value = value;
            });
          },
        ),
        // buttons to change faces states
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
    );
  }
}