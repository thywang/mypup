import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/widgets/3d_button.dart';

class ClickerPage extends StatefulWidget {
  const ClickerPage({Key? key}) : super(key: key);

  @override
  State<ClickerPage> createState() => _ClickerPageState();
}

class _ClickerPageState extends State<ClickerPage> {
  AudioPlayer? _player;

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  void _play() {
    _player?.dispose();
    _player = AudioPlayer()..play(AssetSource('click.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainAppColor,
      body: Align(
        child: Container(
          height: 420,
          width: 250,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.elliptical(150, 200)),
            boxShadow: [
              const BoxShadow(
                color: Colors.black54,
                blurRadius: 10,
                spreadRadius: -5,
                offset: Offset(5, 5),
              ),
              BoxShadow(
                color: clickerInnerShadow,
                offset: const Offset(-3, -3),
              ),
              BoxShadow(
                color: clickerColor,
                spreadRadius: -6,
                blurRadius: 6,
              ),
            ],
          ),
          child: AppButton(
            text: '',
            onPressed: _play,
            textColor: Colors.white,
            backgroundColor: healthColor,
            shadowColor: Colors.brown.shade900,
            child: const Icon(
              Icons.pets,
              color: Colors.white,
              size: 70,
            ),
          ),
        ),
      ),
    );
  }
}
