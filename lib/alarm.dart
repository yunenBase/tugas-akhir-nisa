import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _audioPlayer = AudioPlayer();

Future<void> playAlarm() async {
  try {
    await _audioPlayer.play(AssetSource('sounds/alarm.wav'));
    print("Alarm sound played.");
  } catch (e) {
    print("Error playing alarm: $e");
  }
}

Future<void> stopAlarm() async {
  try {
    await _audioPlayer.stop();
    print("Alarm stopped.");
  } catch (e) {
    print("Error stopping alarm: $e");
  }
}
