//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotMatchStarted extends API_Message {
		public var msgNum:Number;
		public var allPlayerIds:Array/*int*/;
		public var finishedPlayerIds:Array/*int*/;
		public var serverEntries:Array/*ServerEntry*/;
		public static function create(msgNum:Number, allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, serverEntries:Array/*ServerEntry*/):API_GotMatchStarted {

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

			var res:API_GotMatchStarted = new API_GotMatchStarted();
			res.msgNum = msgNum;
			res.allPlayerIds = allPlayerIds;
			res.finishedPlayerIds = finishedPlayerIds;
			res.serverEntries = serverEntries;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.msgNum = parameters[pos++];

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

			this.allPlayerIds = parameters[pos++];
			this.finishedPlayerIds = parameters[pos++];
			this.serverEntries = parameters[pos++];
		}
		/*override*/ public function getFunctionId():Number { return -121; }
		/*override*/ public function getMethodName():String { return 'gotMatchStarted'; }
		/*override*/ public function getMethodParameters():Array { return [msgNum, allPlayerIds, finishedPlayerIds, serverEntries]; }
		/*override*/ public function getMethodParametersNum():Number { return 4; }
	}
