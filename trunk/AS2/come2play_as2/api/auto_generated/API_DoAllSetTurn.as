//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllSetTurn extends API_Message {
		public var userId:Number;
		public var milliSecondsInTurn:Number;
		public static function create(userId:Number, milliSecondsInTurn:Number/*<InAS3> = -1 </InAS3>*/):API_DoAllSetTurn {
			var res:API_DoAllSetTurn = new API_DoAllSetTurn();
			res.userId = userId;

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

			/*<InAS2>*/ if (milliSecondsInTurn==null) milliSecondsInTurn = -1;/*</InAS2>*/
			res.milliSecondsInTurn = milliSecondsInTurn;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.userId = parameters[pos++];
			this.milliSecondsInTurn = parameters[pos++];
		}
		/*override*/ public function getFunctionId():Number { return -115; }

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodName():String { return 'doAllSetTurn'; }
		/*override*/ public function getMethodParameters():Array { return [userId, milliSecondsInTurn]; }
		/*override*/ public function getMethodParametersNum():Number { return 2; }
	}
