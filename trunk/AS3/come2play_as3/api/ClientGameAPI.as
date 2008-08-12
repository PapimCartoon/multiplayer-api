package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class ClientGameAPI extends BaseGameAPI {
		public function ClientGameAPI(someMovieClip:MovieClip) {
			super(someMovieClip);
		}
		public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void {}
		public function gotCustomInfo(entries:Array/*Entry*/):void {}
		public function gotUserInfo(userId:int, entries:Array/*Entry*/):void {}
		public function gotUserDisconnected(userId:int):void {}
		public function gotMyUserId(myUserId:int):void {}
		public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object/*Serializable*/, matchStartedTime:int, userStateEntries:Array/*UserStateEntry*/):void {}
		public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void {}
		
		
		public function doFinishedCallback(callbackName:String):void { sendDoOperation('doFinishedCallback', arguments); }
		public function doRegisterOnServer():void { sendDoOperation('doRegisterOnServer', arguments); }
		public function doTrace(name:String, message:Object/*Serializable*/):void { sendDoOperation('doTrace', arguments); }
		
		public function doStoreState(stateEntries:Array/*StateEntry*/):void { sendDoOperation('doStoreState', arguments); }
		public function gotStoredState(userId:int, stateEntries:Array/*StateEntry*/):void {}
		
		public function doAllEndMatch(finishedPlayers:Array/*PlayerMatchOver*/):void { sendDoOperation('doAllEndMatch', arguments); }
		
		// if userId==-1, then nobody has the turn.
		// if milliSecondsInTurn==-1 then the default time per turn is used,
		// and if milliSecondsInTurn==0 then the user should do some actions immediately.
		public function doAllSetTurn(userId:int, milliSecondsInTurn:int):void { sendDoOperation('doAllSetTurn', arguments); }
		public function gotTurnOf(userId:int):void {}
		
		
		// if userId of RevealEntry is -1, then the entry becomes PUBLIC
		public function doAllRevealState(revealEntries:Array/*RevealEntry*/):void { sendDoOperation('doAllRevealState', arguments); }
		public function doAllShuffleState(keys:Array/*String*/):void { sendDoOperation('doAllShuffleState', arguments); }
		
		// if userId=-1, then it is a bug of the game developer
		public function doAllFoundHacker(userId:int, errorDescription:String):void { sendDoOperation('doAllFoundHacker', arguments); }
		
		// doAllRequestStateCalculation is usually used to do a calculation
		// of an initial state that should be secret to all players.
		// (E.g., the initial board in multiplayer Sudoku or MineSweeper).
		// The server picks several random users,
		// and sends them gotRequestStateCalculation.
		// All the users must do the exact same calls to doStoreState
		public function doAllRequestStateCalculation(value:Object/*Serializable*/):void { sendDoOperation('doAllRequestStateCalculation', arguments); }
		public function gotRequestStateCalculation(secretSeed:int, value:Object/*Serializable*/):void {}
		
	}
}
