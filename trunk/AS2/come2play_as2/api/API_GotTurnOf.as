//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotTurnOf extends API_Message {
		public var userId:Number;
		public function API_GotTurnOf(userId:Number) { super('gotTurnOf',arguments); 
			this.userId = userId;
		}
		/*override*/ public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId); }
	}
