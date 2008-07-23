	import come2play_as2.api.*;
import come2play_as2.api.*;
	class come2play_as2.api.PlayerMatchOver {
		public var player_id:Number;
		public var score:Number;
		public var pot_percentage:Number; //pot_percentage ranges between -1 and 100. -1 means to return the stakes (e.g., in case of a tie/draw)
		public function PlayerMatchOver(player_id:Number, score:Number, pot_percentage:Number) {
			this.player_id = player_id;
			this.score = score;
			this.pot_percentage = pot_percentage;
		}
		public function toString():String {
			return "[PlayerMatchOver: player_id="+player_id+" score="+score+" pot_percentage="+pot_percentage+"]";
		}
		public static function isInArr(finished_players:Array/*PlayerMatchOver*/, player_id:Number):Boolean {
			for (var i15:Number=0; i15<finished_players.length; i15++) { var finished_player:PlayerMatchOver = finished_players[i15]; 
				if (finished_player.player_id==player_id) return true;
			}
			return false;
		}
	}
