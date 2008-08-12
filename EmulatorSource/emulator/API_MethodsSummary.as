package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class API_MethodsSummary  {
		public static var SUMMARY_API:Array = [
		['gotKeyboardEvent', [['isKeyDown','boolean'], ['charCode','int'], ['keyCode','int'], ['keyLocation','int'], ['altKey','boolean'], ['ctrlKey','boolean'], ['shiftKey','boolean']] ]
		,['gotCustomInfo', [['entries','null']] ]
		,['gotUserInfo', [['userId','int'], ['entries','null']] ]
		,['gotUserDisconnected', [['userId','int']] ]
		,['gotMyUserId', [['myUserId','int']] ]
		,['gotMatchStarted', [['allPlayerIds','int[]'], ['finishedPlayerIds','int[]'], ['extraMatchInfo','Object'], ['matchStartedTime','int'], ['userStateEntries','null']] ]
		,['gotMatchEnded', [['finishedPlayerIds','int[]']] ]
		,['doFinishedCallback', [['callbackName','String']] ]
		,['doRegisterOnServer', [] ]
		,['doTrace', [['name','String'], ['message','Object']] ]
		,['doStoreState', [['stateEntries','null']] ]
		,['gotStoredState', [['userId','int'], ['stateEntries','null']] ]
		,['doAllEndMatch', [['finishedPlayers','null']] ]
		,['doAllSetTurn', [['userId','int'], ['milliSecondsInTurn','int']] ]
		,['gotTurnOf', [['userId','int']] ]
		,['doAllRevealState', [['revealEntries','null']] ]
		,['doAllShuffleState', [['keys','String[]']] ]
		,['doAllFoundHacker', [['userId','int'], ['errorDescription','String']] ]
		,['doAllRequestStateCalculation', [['value','Object']] ]
		,['gotRequestStateCalculation', [['secretSeed','int'], ['value','Object']] ]
		,['doConnectedSetScore', [['score','int']] ]
		,['doConnectedMatchOver', [['didWin','boolean']] ]
		];
	}
}
