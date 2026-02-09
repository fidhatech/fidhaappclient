import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

import 'employee_voice_state.dart';

class EmployeeVoiceCubit extends Cubit<EmployeeVoiceState> {
  final String selectedLanguage;

  EmployeeVoiceCubit({required this.selectedLanguage})
    : super(EmployeeVoiceInitial());

  // String getVoiceText() {
  //   // Map of language to text
  //   // Using simple mapping or if-else
  //   // Current options: "Malayalam മലയാളം", "Tamil தமிழ்", "Kannada ಕನ್ನಡ", "Hindi हिन्दी"

  //   if (selectedLanguage.contains("Malayalam")) {
  //     return "“ ഒരുമിച്ചുണ്ടായിരുന്ന രാത്രികൾ\nഇല്ലയെന്നു കരുതാം... പക്ഷേ,\nഓർക്കാതെയിരുന്ന രാത്രികൾ\nഉണ്ടാവില്ല... ”";
  //   } else if (selectedLanguage.contains("Tamil")) {
  //     return "“ சேர்ந்து இருந்த இரவுகள்\nஇல்லை என்று நினைக்கலாம்... ஆனால்,\nநினைக்காத இரவுகள்\nஇல்லை... ”";
  //   } else if (selectedLanguage.contains("Kannada")) {
  //     return "“ ಜೊತೆಯಾಗಿದ್ದ ರಾತ್ರಿಗಳು\nಇಲ್ಲವೆಂದು ಭಾವಿಸಬಹುದು... ಆದರೆ,\nನೆನಪಾಗದ ರಾತ್ರಿಗಳು\nಇರುವುದಿಲ್ಲ... ”";
  //   } else if (selectedLanguage.contains("Hindi")) {
  //     return "“ साथ बिताईं वो रातें\nशायद न हों... लेकिन,\nयाद न आने वाली रातें\nनहीं होंगी... ”";
  //   } else {
  //     return "“ Reading text not available for this language. ”";
  //   }
  // }

  final AudioRecorder _audioRecorder = AudioRecorder();

  Future<void> startRecording() async {
    try {
      log("Start recording requested");
      // Request permission explicitly
      final status = await Permission.microphone.request();
      log("Microphone permission status: $status");

      if (status.isGranted) {
        final Directory appDocumentsDir =
            await getApplicationDocumentsDirectory();
        final String filePath =
            '${appDocumentsDir.path}/voice_auth_${DateTime.now().millisecondsSinceEpoch}.m4a';

        log("Starting recording to: $filePath");
        await _audioRecorder.start(const RecordConfig(), path: filePath);
        log("Recording started");
        emit(EmployeeVoiceRecording());
      } else {
        log("Microphone permission denied");
        emit(const EmployeeVoiceError(message: "Microphone permission denied"));
      }
    } catch (e) {
      log("Error starting recording: $e");
      emit(EmployeeVoiceError(message: "Failed to start recording: $e"));
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      if (path != null) {
        emit(EmployeeVoiceRecorded(audioPath: path));
      } else {
        emit(EmployeeVoiceInitial()); // Canceled or failed
      }
    } catch (e) {
      emit(EmployeeVoiceError(message: "Failed to stop recording: $e"));
    }
  }

  void reset() {
    emit(EmployeeVoiceInitial());
  }

  @override
  Future<void> close() {
    _audioRecorder.dispose();
    return super.close();
  }
}
