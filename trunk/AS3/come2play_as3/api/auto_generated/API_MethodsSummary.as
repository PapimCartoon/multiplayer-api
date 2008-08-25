package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class API_MethodsSummary  {
		public var methodName:String;
		public var parameterNames:Array/*String*/;
		public var parameterTypes:Array/*String*/;
		public function API_MethodsSummary(methodName:String, parameterNames:Array/*String*/, parameterTypes:Array/*String*/) {
			this.methodName = methodName;

// This is a AUTOMATICALLY GENERATED! Do not change!

			this.parameterNames = parameterNames;
			this.parameterTypes = parameterTypes;
		}
		public static var SUMMARY_API:Array/*API_MethodsSummary*/ = [
		 new API_MethodsSummary('doFinishedCallback', ['callbackName'], ['String'] )
		, new API_MethodsSummary('doRegisterOnServer', [], [] )
		, new API_MethodsSummary('doTrace', ['name', 'message'], ['String', 'Object/*Serializable*/'] )
		, new API_MethodsSummary('gotKeyboardEvent', ['isKeyDown', 'charCode', 'keyCode', 'keyLocation', 'altKey', 'ctrlKey', 'shiftKey'], ['Boolean', 'int', 'int', 'int', 'Boolean', 'Boolean', 'Boolean'] )
		, new API_MethodsSummary('gotCustomInfo', ['infoEntries'], ['Array/*InfoEntry*/'] )
		, new API_MethodsSummary('gotUserInfo', ['userId', 'infoEntries'], ['int', 'Array/*InfoEntry*/'] )

// This is a AUTOMATICALLY GENERATED! Do not change!

		, new API_MethodsSummary('gotUserDisconnected', ['userId'], ['int'] )
		, new API_MethodsSummary('gotMyUserId', ['myUserId'], ['int'] )
		, new API_MethodsSummary('gotMatchStarted', ['allPlayerIds', 'finishedPlayerIds', 'extraMatchInfo', 'matchStartedTime', 'serverEntries'], ['Array/*int*/', 'Array/*int*/', 'Object/*Serializable*/', 'int', 'Array/*ServerEntry*/'] )
		, new API_MethodsSummary('gotMatchEnded', ['finishedPlayerIds'], ['Array/*int*/'] )
		, new API_MethodsSummary('gotStateChanged', ['serverEntries'], ['Array/*ServerEntry*/'] )
		, new API_MethodsSummary('doStoreState', ['userEntries'], ['Array/*UserEntry*/'] )
		, new API_MethodsSummary('doAllStoreState', ['userEntries'], ['Array/*UserEntry*/'] )
		, new API_MethodsSummary('doAllEndMatch', ['finishedPlayers'], ['Array/*PlayerMatchOver*/'] )
		, new API_MethodsSummary('doAllSetTurn', ['userId', 'milliSecondsInTurn'], ['int', 'int'] )
		, new API_MethodsSummary('doAllRevealState', ['revealEntries'], ['Array/*RevealEntry*/'] )

// This is a AUTOMATICALLY GENERATED! Do not change!

		, new API_MethodsSummary('doAllShuffleState', ['keys'], ['Array/*String*/'] )
		, new API_MethodsSummary('doAllRequestRandomState', ['key', 'isSecret'], ['String', 'Boolean'] )
		, new API_MethodsSummary('doAllFoundHacker', ['userId', 'errorDescription'], ['int', 'String'] )
		, new API_MethodsSummary('doAllRequestStateCalculation', ['keys'], ['Array/*String*/'] )
		, new API_MethodsSummary('gotRequestStateCalculation', ['serverEntries'], ['Array/*ServerEntry*/'] )
		, new API_MethodsSummary('doAllStoreStateCalculation', ['userEntries'], ['Array/*UserEntry*/'] )
		, new API_MethodsSummary('doConnectedSetScore', ['score'], ['int'] )
		, new API_MethodsSummary('doConnectedEndMatch', ['didWin'], ['Boolean'] )
		];
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
