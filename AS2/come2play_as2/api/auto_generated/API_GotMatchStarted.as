//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotMatchStarted extends API_Message {
		public var allPlayerIds:Array/*int*/;
		public var finishedPlayerIds:Array/*int*/;
		public var extraMatchInfo:Object/*Serializable*/;
		public var matchStartedTime:Number;
		public var serverEntries:Array/*ServerEntry*/;
		public static function create(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object/*Serializable*/, matchStartedTime:Number, serverEntries:Array/*ServerEntry*/):API_GotMatchStarted { 
			var res:API_GotMatchStarted = new API_GotMatchStarted();
			res.allPlayerIds = allPlayerIds;
			res.finishedPlayerIds = finishedPlayerIds;
			res.extraMatchInfo = extraMatchInfo;
			res.matchStartedTime = matchStartedTime;
			res.serverEntries = serverEntries;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.allPlayerIds = parameters[pos++];
			this.finishedPlayerIds = parameters[pos++];
			this.extraMatchInfo = parameters[pos++];
			this.matchStartedTime = parameters[pos++];
			this.serverEntries = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'allPlayerIds=' + JSON.stringify(allPlayerIds)+', finishedPlayerIds=' + JSON.stringify(finishedPlayerIds)+', extraMatchInfo=' + JSON.stringify(extraMatchInfo)+', matchStartedTime=' + JSON.stringify(matchStartedTime)+', serverEntries=' + JSON.stringify(serverEntries); }
		/*override*/ public function toString():String { return '{API_GotMatchStarted:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'gotMatchStarted'; }
		/*override*/ public function getMethodParameters():Array { return [allPlayerIds, finishedPlayerIds, extraMatchInfo, matchStartedTime, serverEntries]; }
	}
