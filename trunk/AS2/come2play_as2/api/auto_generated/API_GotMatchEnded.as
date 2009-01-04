//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotMatchEnded extends API_Message {
		public var msgNum:Number;
		public var finishedPlayerIds:Array/*int*/;
		public static function create(msgNum:Number, finishedPlayerIds:Array/*int*/):API_GotMatchEnded {
			var res:API_GotMatchEnded = new API_GotMatchEnded();
			res.msgNum = msgNum;

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

			res.finishedPlayerIds = finishedPlayerIds;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.msgNum = parameters[pos++];
			this.finishedPlayerIds = parameters[pos++];
		}
		/*override*/ public function getFunctionId():Number { return -120; }
		/*override*/ public function getMethodName():String { return 'gotMatchEnded'; }

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodParameters():Array { return [msgNum, finishedPlayerIds]; }
		/*override*/ public function getMethodParametersNum():Number { return 2; }
	}
