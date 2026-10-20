

import 'package:sorttrash/BackEnd/PlayerProgress/player.dart';

class PlayerStatsUtil{
  PlayerStatsUtil({required this.playerProgress});
  late PlayerProgress playerProgress;
  int countNumberOfOnesInAString(int len) {
    int count = 0;
    if ( len < 0 || len >= playerProgress.gamesData.length){
      return 0;
    }
    for (int i = 0; i < playerProgress.gamesData[len].levelsCompleted.length; i++) {
      if (playerProgress.gamesData[len].levelsCompleted[i] == '1') {
        count++;
      }
    }
    return count;
  }
  int calculateTotal(){
    int i = 0;
    int count = 0;
    while( i < playerProgress.gamesData.length - 1){
      count += countNumberOfOnesInAString(i);
      i++;
    }
    return count;
  }
}