package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class API_GotMatchStarted extends API_Message {
		public var allPlayerIds:Array/*int*/;
		public var finishedPlayerIds:Array/*int*/;
		public var extraMatchInfo:Object;
		public var matchStartedTime:int;
		public var serverEntries:Array/*ServerEntry*/;

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static function create(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object, matchStartedTime:int, serverEntries:Array/*ServerEntry*/):API_GotMatchStarted {
			var res:API_GotMatchStarted = new API_GotMatchStarted();
			res.allPlayerIds = allPlayerIds;
			res.finishedPlayerIds = finishedPlayerIds;
			res.extraMatchInfo = extraMatchInfo;
			res.matchStartedTime = matchStartedTime;
			res.serverEntries = serverEntries;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 

// This is a AUTOMATICALLY GENERATED! Do not change!

			var pos:int = 0;
			this.allPlayerIds = parameters[pos++];
			this.finishedPlayerIds = parameters[pos++];
			this.extraMatchInfo = parameters[pos++];
			this.matchStartedTime = parameters[pos++];
			this.serverEntries = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'allPlayerIds=' + JSON.stringify(allPlayerIds)+', finishedPlayerIds=' + JSON.stringify(finishedPlayerIds)+', extraMatchInfo=' + JSON.stringify(extraMatchInfo)+', matchStartedTime=' + JSON.stringify(matchStartedTime)+', serverEntries=' + JSON.stringify(serverEntries); }
		override public function toString():String { return '{API_GotMatchStarted:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'gotMatchStarted'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [allPlayerIds, finishedPlayerIds, extraMatchInfo, matchStartedTime, serverEntries]; }
	}
}
