//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotMatchStarted extends API_Message {
		public var allPlayerIds:Array/*int*/;
		public var finishedPlayerIds:Array/*int*/;
		public var extraMatchInfo:Object/*Serializable*/;
		public var matchStartedTime:Number;
		public var userStateEntries:Array/*UserStateEntry*/;
		public function API_GotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object/*Serializable*/, matchStartedTime:Number, userStateEntries:Array/*UserStateEntry*/) { super('gotMatchStarted',arguments); 
			this.allPlayerIds = allPlayerIds;
			this.finishedPlayerIds = finishedPlayerIds;
			this.extraMatchInfo = extraMatchInfo;
			this.matchStartedTime = matchStartedTime;
			this.userStateEntries = userStateEntries;
			for (var i:Number=0; i<userStateEntries.length; i++) userStateEntries[i] = UserStateEntry.object2UserStateEntry(userStateEntries[i]);
		}
		/*override*/ public function getParametersAsString():String { return 'allPlayerIds=' + JSON.stringify(allPlayerIds)+', finishedPlayerIds=' + JSON.stringify(finishedPlayerIds)+', extraMatchInfo=' + JSON.stringify(extraMatchInfo)+', matchStartedTime=' + JSON.stringify(matchStartedTime)+', userStateEntries=' + JSON.stringify(userStateEntries); }
	}
