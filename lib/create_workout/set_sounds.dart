import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../main.dart';
import '../workout_data_type/workout_type.dart';
import '../database/database_manager.dart';

const List<String> soundsList = <String>[
  'short-whistle',
  'long-whistle',
  'short-rest-beep',
  'long-rest-beep',
  'short-halfway-beep',
  'long-halfway-beep',
  'harsh-beep',
  'harsh-beep-sequence',
  'halfway-beep2',
  'horn',
  'long-bell',
  'ding',
  'ding-sequence',
  'thunk',
  'none',
];

const List<String> countdownSounds = <String>[
  'countdown-beep',
  'short-rest-beep',
  'none',
];

class Sounds extends StatelessWidget {
  const Sounds({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Sounds'),
      ),
      body: const Center(
        child: SetSounds(),
      ),
    );
  }
}

class SetSounds extends StatefulWidget {
  const SetSounds({super.key});

  @override
  State<SetSounds> createState() => _SetSoundsState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SetSoundsState extends State<SetSounds> {
  String _workSound = "short-whistle";
  String _restSound = "short-rest-beep";
  String _halfwaySound = "short-halfway-beep";
  String _completeSound = "long-bell";
  String _countdownSound = "countdown-beep";

  bool _workSoundChanged = false;
  bool _restSoundChanged = false;
  bool _halfwaySoundChanged = false;
  bool _completeSoundChanged = false;
  bool _countdownSoundChanged = false;

  void pushHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (route) => false);
  }

  void submitWorkout(Workout workoutArgument) async {
    workoutArgument.workSound = _workSound;
    workoutArgument.restSound = _restSound;
    workoutArgument.halfwaySound = _halfwaySound;
    workoutArgument.completeSound = _completeSound;
    workoutArgument.countdownSound = _countdownSound;

    if (workoutArgument.id == "") {
      // Set the workout ID
      workoutArgument.id = const Uuid().v1();

      Database database = await DatabaseManager().initDB();
      await DatabaseManager()
          .insertList(workoutArgument, database)
          .then((value) {
        pushHome();
      });
    } else {
      Database database = await DatabaseManager().initDB();
      await DatabaseManager()
          .updateList(workoutArgument, database)
          .then((value) {
        pushHome();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SoundpoolOptions soundpoolOptions = const SoundpoolOptions();

    Soundpool pool = Soundpool.fromOptions(options: soundpoolOptions);

    var soundIdMap = {};

    for (final sound in soundsList) {
      soundIdMap[sound] = loadSound(sound, pool);
    }

    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    if (workoutArgument.workSound != "") {
      if (!_workSoundChanged) {
        _workSound = workoutArgument.workSound;
      }
      if (!_restSoundChanged) {
        _restSound = workoutArgument.restSound;
      }
      if (!_halfwaySoundChanged) {
        _halfwaySound = workoutArgument.halfwaySound;
      }
      if (!_completeSoundChanged) {
        _completeSound = workoutArgument.completeSound;
      }
      if (!_countdownSoundChanged) {
        _countdownSound = workoutArgument.countdownSound;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Text(
                    "Work sound:",
                  ),
                ),
                DropdownButton<String>(
                  value: _workSound,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await pool.play(await soundIdMap[value]);
                    }
                    setState(() {
                      _workSound = value!;
                      _workSoundChanged = true;
                    });
                  },
                  items:
                      soundsList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Text(
                    "Rest sound:",
                  ),
                ),
                DropdownButton<String>(
                  value: _restSound,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await pool.play(await soundIdMap[value]);
                    }
                    setState(() {
                      _restSound = value!;
                      _restSoundChanged = true;
                    });
                  },
                  items:
                      soundsList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Text(
                    "Halfway sound:",
                  ),
                ),
                DropdownButton<String>(
                  value: _halfwaySound,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await pool.play(await soundIdMap[value]);
                    }
                    setState(() {
                      _halfwaySound = value!;
                      _halfwaySoundChanged = true;
                    });
                  },
                  items:
                      soundsList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Text(
                    "Complete sound:",
                  ),
                ),
                DropdownButton<String>(
                  value: _completeSound,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await pool.play(await soundIdMap[value]);
                    }
                    setState(() {
                      _completeSound = value!;
                      _completeSoundChanged = true;
                    });
                  },
                  items:
                      soundsList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Text(
                    "Countdown sound:",
                  ),
                ),
                DropdownButton<String>(
                  value: _countdownSound,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await pool.play(await soundIdMap[value]);
                    }
                    setState(() {
                      _countdownSound = value!;
                      _countdownSoundChanged = true;
                    });
                  },
                  items: countdownSounds
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                submitWorkout(workoutArgument);
              },
              child: const Text('Submit'),
            ),
          ),
        ),
      ],
    );
  }

  static Future<int> loadSound(String sound, Soundpool pool) async {
    if (sound != "none") {
      return await rootBundle
          .load("packages/background_timer/lib/assets/audio/$sound.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
    }
    return -1;
  }
}
