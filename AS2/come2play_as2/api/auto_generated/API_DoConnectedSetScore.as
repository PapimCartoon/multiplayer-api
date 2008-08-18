//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoConnectedSetScore extends API_Message {
		public var score:Number;
		public function API_DoConnectedSetScore(score:Number) { super('doConnectedSetScore',arguments); 
			this.score = score;
		}
		/*override*/ public function getParametersAsString():String { return 'score=' + JSON.stringify(score); }
	}
