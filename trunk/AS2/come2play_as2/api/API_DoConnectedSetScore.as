//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoConnectedSetScore extends API_Message {
		public var score:Number;
		public function API_DoConnectedSetScore(score:Number) { super('do_connected_set_score',arguments); 
			this.score = score;
		}
		/*override*/ public function toString():String { return '{API_DoConnectedSetScore' + ': score=' + JSON.stringify(score)+'}'; }
	}
