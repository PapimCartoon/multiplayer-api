package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_GotMatchOver extends API_Message {
		public var finished_player_ids:Array/*int*/;
		public function API_GotMatchOver(finished_player_ids:Array/*int*/) { super('got_match_over',arguments); 
			this.finished_player_ids = finished_player_ids;
		}
		override public function toString():String { return '{API_GotMatchOver' + ': finished_player_ids=' + JSON.stringify(finished_player_ids)+'}'; }
	}
}
