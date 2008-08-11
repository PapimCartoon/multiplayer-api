//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotMatchStarted extends API_Message {
		public var all_player_ids:Array/*int*/;
		public var finished_player_ids:Array/*int*/;
		public var extra_match_info:Object/*Serializable*/;
		public var match_started_time:Number;
		public var match_state:Array/*UserStateEntry*/;
		public function API_GotMatchStarted(all_player_ids:Array/*int*/, finished_player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:Number, match_state:Array/*UserStateEntry*/) { super('got_match_started',arguments); 
			this.all_player_ids = all_player_ids;
			this.finished_player_ids = finished_player_ids;
			this.extra_match_info = extra_match_info;
			this.match_started_time = match_started_time;
			this.match_state = match_state;
			for (var i:Number=0; i<match_state.length; i++) match_state[i] = UserStateEntry.object2UserStateEntry(match_state[i]);
		}
		/*override*/ public function toString():String { return '{API_GotMatchStarted' + ': all_player_ids=' + JSON.stringify(all_player_ids) + ': finished_player_ids=' + JSON.stringify(finished_player_ids) + ': extra_match_info=' + JSON.stringify(extra_match_info) + ': match_started_time=' + JSON.stringify(match_started_time) + ': match_state=' + JSON.stringify(match_state)+'}'; }
	}
