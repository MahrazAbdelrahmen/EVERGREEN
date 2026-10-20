import '../BackEnd/DataBaseService/local_data_base_service.dart';
import '../player_box.dart';

/// Lock state of the 24 daily challenges for the child currently playing.
class ChallengeManagement {
  static const challengeCount = 24;

  DataBaseService dataBaseService =
      currentProfileIndex == 1 ? offlineProgress : onlineProgress;

  late final List<bool> locked = List.generate(
      challengeCount, (index) => dataBaseService.returnLockedState(index, 3));
}
