package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	import come2play_as3.api.*
	public  class API_Got_match_over_waiting_others extends API_Message {
		public var white_score:int;
		public var black_score:int;
		public function API_Got_match_over_waiting_others(white_score:int, black_score:int) { super('got_match_over_waiting_others',arguments); 
			this.white_score = white_score;
			this.black_score = black_score;
		}
		override public function getParametersAsString():String { return 'white_score=' + JSON.stringify(white_score)+', black_score=' + JSON.stringify(black_score); }
	}
}
