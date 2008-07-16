package come2play_as3.api {
	public class PlayerMatchOver {
		public var player_id:int;
		public var score:int;
		public var pot_percentage:int; //pot_percentage is between -1 and 100. -1 means to return the stakes (e.g., in case of a tie/draw)
		public function PlayerMatchOver(player_id:int, score:int, pot_percentage:int) {
			this.player_id = player_id;
			this.score = score;
			this.pot_percentage = pot_percentage;
		}
		public function toString():String {
			return "[PlayerMatchOver: player_id="+player_id+" score="+score+" pot_percentage="+pot_percentage+"]";
		}
		public static function isInArr(finished_players:Array/*PlayerMatchOver*/, player_id:int):Boolean {
			for each (var finished_player:PlayerMatchOver in finished_players)
				if (finished_player.player_id==player_id) return true;
			return false;
		}
	}
}