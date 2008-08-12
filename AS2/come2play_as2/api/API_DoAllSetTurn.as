//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoAllSetTurn extends API_Message {
		public var userId:Number;
		public var milliSecondsInTurn:Number;
		public function API_DoAllSetTurn(userId:Number, milliSecondsInTurn:Number) { super('doAllSetTurn',arguments); 
			this.userId = userId;
			this.milliSecondsInTurn = milliSecondsInTurn;
		}
		/*override*/ public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', milliSecondsInTurn=' + JSON.stringify(milliSecondsInTurn); }
	}
