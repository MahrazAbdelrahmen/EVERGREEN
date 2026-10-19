




import 'package:sorttrash/BackEnd/PlayerProgress/player.dart';

import '../../DataBaseService/local_data_base_service.dart';

class NewPlayerUtil {
  static PlayerProgress returnNewPlayer(){
    return PlayerProgress(0, [
      for (final game in DataBaseService.newGameDataPlayer)
        LevelsCompleted(game.id, game.levelsCompleted)
    ], DateTime.now(), 0, 'childsName', 'childGlobalUID', 'avatarProfileName', DateTime.now());
  }
}