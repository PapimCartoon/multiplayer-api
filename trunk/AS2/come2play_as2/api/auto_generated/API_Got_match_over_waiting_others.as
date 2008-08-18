//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_Got_match_over_waiting_others extends API_Message {
		public var white_score:Number;
		public var black_score:Number;
		public function API_Got_match_over_waiting_others(white_score:Number, black_score:Number) { super('got_match_over_waiting_others',arguments); 
			this.white_score = white_score;
			this.black_score = black_score;
		}
		/*override*/ public function getParametersAsString():String { return 'white_score=' + JSON.stringify(white_score)+', black_score=' + JSON.stringify(black_score); }
	}
