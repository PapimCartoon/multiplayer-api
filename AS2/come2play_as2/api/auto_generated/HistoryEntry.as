//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.HistoryEntry extends API_Message {
		public var message:API_Message;
		public var gotTimeInMilliSeconds:Number;
		public static function create(message:API_Message, gotTimeInMilliSeconds:Number):HistoryEntry {
			var res:HistoryEntry = new HistoryEntry();
			res.message = message;

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

			res.gotTimeInMilliSeconds = gotTimeInMilliSeconds;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.message = parameters[pos++];
			this.gotTimeInMilliSeconds = parameters[pos++];
		}
		/*override*/ public function getFunctionId():Number { return -85; }
		/*override*/ public function getMethodName():String { return 'historyEntry'; }

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodParameters():Array { return [message, gotTimeInMilliSeconds]; }
		/*override*/ public function getMethodParametersNum():Number { return 2; }
	}
