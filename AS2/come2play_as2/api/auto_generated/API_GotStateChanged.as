//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotStateChanged extends API_Message {
		public var msgNum:Number;
		public var serverEntries:Array/*ServerEntry*/;
		public static function create(msgNum:Number, serverEntries:Array/*ServerEntry*/):API_GotStateChanged {
			var res:API_GotStateChanged = new API_GotStateChanged();
			res.msgNum = msgNum;

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

			res.serverEntries = serverEntries;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.msgNum = parameters[pos++];
			this.serverEntries = parameters[pos++];
		}
		/*override*/ public function getFunctionId():Number { return -119; }
		/*override*/ public function getMethodName():String { return 'gotStateChanged'; }

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodParameters():Array { return [msgNum, serverEntries]; }
		/*override*/ public function getMethodParametersNum():Number { return 2; }
	}
