package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
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
		
		
		public function doFinishedCallback(callbackName:String):void { sendMessage( new API_DoFinishedCallback(callbackName) ); }
		public function doRegisterOnServer():void { sendMessage( new API_DoRegisterOnServer() ); }
		public function doTrace(name:String, message:Object/*Serializable*/):void { sendMessage( new API_DoTrace(name, message) ); }
		
		public function doStoreState(stateEntries:Array/*StateEntry*/):void { sendMessage( new API_DoStoreState(stateEntries) ); }
		public function gotStoredState(userId:int, stateEntries:Array/*StateEntry*/):void {}
		
		public function doAllEndMatch(finishedPlayers:Array/*PlayerMatchOver*/):void { sendMessage( new API_DoAllEndMatch(finishedPlayers) ); }
		
		// if userId==-1, then nobody has the turn.
		// if milliSecondsInTurn==-1 then the default time per turn is used,
		// and if milliSecondsInTurn==0 then the user should do some actions immediately.
		public function doAllSetTurn(userId:int, milliSecondsInTurn:int):void { sendMessage( new API_DoAllSetTurn(userId, milliSecondsInTurn) ); }
		public function gotTurnOf(userId:int):void {}
		
		
		// if userId of RevealEntry is -1, then the entry becomes PUBLIC
		public function doAllRevealState(revealEntries:Array/*RevealEntry*/):void { sendMessage( new API_DoAllRevealState(revealEntries) ); }
		public function doAllShuffleState(keys:Array/*String*/):void { sendMessage( new API_DoAllShuffleState(keys) ); }
		
		// if userId=-1, then it is a bug of the game developer
		public function doAllFoundHacker(userId:int, errorDescription:String):void { sendMessage( new API_DoAllFoundHacker(userId, errorDescription) ); }
		
		// doAllRequestStateCalculation is usually used to do a calculation
		// of an initial state that should be secret to all players.
		// (E.g., the initial board in multiplayer Sudoku or MineSweeper).
		// The server picks several random users,
		// and sends them gotRequestStateCalculation.
		// All these users must do the exact same call to doAllStoreStateCalculation,
		// i.e., the state calculation must be deterministic (you can use secretSeed to create the hidden board).
		public function doAllRequestStateCalculation(value:Object/*Serializable*/):void { sendMessage( new API_DoAllRequestStateCalculation(value) ); }
		public function gotRequestStateCalculation(secretSeed:int, value:Object/*Serializable*/):void {}
		public function doAllStoreStateCalculation(stateEntries:Array/*StateEntry*/):void { sendMessage( new API_DoAllStoreStateCalculation(stateEntries) ); }
		
	}
}
