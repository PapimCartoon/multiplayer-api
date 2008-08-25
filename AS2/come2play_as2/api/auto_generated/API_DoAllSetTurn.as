//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllSetTurn extends API_Message {
		public var userId:Number;
		public var milliSecondsInTurn:Number;
		public static function create(userId:Number, milliSecondsInTurn:Number):API_DoAllSetTurn { 

// This is a AUTOMATICALLY GENERATED! Do not change!

			var res:API_DoAllSetTurn = new API_DoAllSetTurn();
			res.userId = userId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.milliSecondsInTurn = milliSecondsInTurn;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;

// This is a AUTOMATICALLY GENERATED! Do not change!

			this.userId = parameters[pos++];
			this.milliSecondsInTurn = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', milliSecondsInTurn=' + JSON.stringify(milliSecondsInTurn); }
		/*override*/ public function toString():String { return '{API_DoAllSetTurn:' +getParametersAsString() +'}'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodName():String { return 'doAllSetTurn'; }
		/*override*/ public function getMethodParameters():Array { return [userId, milliSecondsInTurn]; }

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
