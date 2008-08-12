package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_MethodsSummary  {
		public var methodName:String;
		public var parameterNames:Array/*String*/;
		public var parameterTypes:Array/*String*/;
		public function API_MethodsSummary(methodName:String, parameterNames:Array/*String*/, parameterTypes:Array/*String*/) {
			this.methodName = methodName;
			this.parameterNames = parameterNames;
			this.parameterTypes = parameterTypes;
		}
		public static var SUMMARY_API:Array/*API_MethodsSummary*/ = [
		 new API_MethodsSummary('gotKeyboardEvent', ['isKeyDown', 'charCode', 'keyCode', 'keyLocation', 'altKey', 'ctrlKey', 'shiftKey'], ['Boolean', 'int', 'int', 'int', 'Boolean', 'Boolean', 'Boolean'] )
		, new API_MethodsSummary('gotCustomInfo', ['entries'], ['Array/*Entry*/'] )
		, new API_MethodsSummary('gotUserInfo', ['userId', 'entries'], ['int', 'Array/*Entry*/'] )
		, new API_MethodsSummary('gotUserDisconnected', ['userId'], ['int'] )
		, new API_MethodsSummary('gotMyUserId', ['myUserId'], ['int'] )
		, new API_MethodsSummary('gotMatchStarted', ['allPlayerIds', 'finishedPlayerIds', 'extraMatchInfo', 'matchStartedTime', 'userStateEntries'], ['Array/*int*/', 'Array/*int*/', 'Object/*Serializable*/', 'int', 'Array/*UserStateEntry*/'] )
		, new API_MethodsSummary('gotMatchEnded', ['finishedPlayerIds'], ['Array/*int*/'] )
		, new API_MethodsSummary('doFinishedCallback', ['callbackName'], ['String'] )
		, new API_MethodsSummary('doRegisterOnServer', [], [] )
		, new API_MethodsSummary('doTrace', ['name', 'message'], ['String', 'Object/*Serializable*/'] )
		, new API_MethodsSummary('doStoreState', ['stateEntries'], ['Array/*StateEntry*/'] )
		, new API_MethodsSummary('gotStoredState', ['userId', 'stateEntries'], ['int', 'Array/*StateEntry*/'] )
		, new API_MethodsSummary('doAllEndMatch', ['finishedPlayers'], ['Array/*PlayerMatchOver*/'] )
		, new API_MethodsSummary('doAllSetTurn', ['userId', 'milliSecondsInTurn'], ['int', 'int'] )
		, new API_MethodsSummary('gotTurnOf', ['userId'], ['int'] )
		, new API_MethodsSummary('doAllRevealState', ['revealEntries'], ['Array/*RevealEntry*/'] )
		, new API_MethodsSummary('doAllShuffleState', ['keys'], ['Array/*String*/'] )
		, new API_MethodsSummary('doAllFoundHacker', ['userId', 'errorDescription'], ['int', 'String'] )
		, new API_MethodsSummary('doAllRequestStateCalculation', ['value'], ['Object/*Serializable*/'] )
		, new API_MethodsSummary('gotRequestStateCalculation', ['secretSeed', 'value'], ['int', 'Object/*Serializable*/'] )
		, new API_MethodsSummary('doConnectedSetScore', ['score'], ['int'] )
		, new API_MethodsSummary('doConnectedMatchOver', ['didWin'], ['Boolean'] )
		];
	}
}
