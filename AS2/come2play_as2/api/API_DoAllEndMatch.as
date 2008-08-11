//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoAllEndMatch extends API_Message {
		public var finished_players:Array/*PlayerMatchOver*/;
		public function API_DoAllEndMatch(finished_players:Array/*PlayerMatchOver*/) { super('do_all_end_match',arguments); 
			this.finished_players = finished_players;
			for (var i:Number=0; i<finished_players.length; i++) finished_players[i] = PlayerMatchOver.object2PlayerMatchOver(finished_players[i]);
		}
		/*override*/ public function toString():String { return '{API_DoAllEndMatch' + ': finished_players=' + JSON.stringify(finished_players)+'}'; }
	}
