package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class ClientGameAPI extends BaseGameAPI {
		public function ClientGameAPI(someMovieClip:MovieClip) {
			super(someMovieClip);
		}
		public function doRegisterOnServer():void { sendMessage( API_DoRegisterOnServer.create() ); }
		public function doTrace(name:String, message:Object/*Serializable*/):void { sendMessage( API_DoTrace.create(name, message) ); }
		
		public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void {}
		public function gotCustomInfo(infoEntries:Array/*InfoEntry*/):void {}
		public function gotUserInfo(userId:int, infoEntries:Array/*InfoEntry*/):void {}
		public function gotUserDisconnected(userId:int):void {}
		public function gotMyUserId(myUserId:int):void {}
		public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object/*Serializable*/, matchStartedTime:int, serverEntries:Array/*ServerEntry*/):void {}
		public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void {}
		
		public function gotStateChanged(serverEntries:Array/*ServerEntry*/):void {}
		
		public function doStoreState(userEntries:Array/*UserEntry*/):void { sendMessage( API_DoStoreState.create(userEntries) ); }
		public function doAllStoreState(userEntries:Array/*UserEntry*/):void { sendMessage( API_DoAllStoreState.create(userEntries) ); }
		
		public function doAllEndMatch(finishedPlayers:Array/*PlayerMatchOver*/):void { sendMessage( API_DoAllEndMatch.create(finishedPlayers) ); }
		
		// if userId==-1, then nobody has the turn.
		// if milliSecondsInTurn==-1 then the default time per turn is used,
		// and if milliSecondsInTurn==0 then the user should do some actions immediately.
		public function doAllSetTurn(userId:int, milliSecondsInTurn:int):void { sendMessage( API_DoAllSetTurn.create(userId, milliSecondsInTurn) ); }
		
		// if userId of RevealEntry is -1, then the entry becomes PUBLIC
		public function doAllRevealState(revealEntries:Array/*RevealEntry*/):void { sendMessage( API_DoAllRevealState.create(revealEntries) ); }
		
		public function doAllShuffleState(keys:Array/*String*/):void { sendMessage( API_DoAllShuffleState.create(keys) ); }
		
		public function doAllRequestRandomState(key:String, isSecret:Boolean):void { sendMessage( API_DoAllRequestRandomState.create(key, isSecret) ); }
		
		// if userId=-1, then it is a bug of the game developer
		public function doAllFoundHacker(userId:int, errorDescription:String):void { sendMessage( API_DoAllFoundHacker.create(userId, errorDescription) ); }
		
		// doAllRequestStateCalculation is usually used to do a calculation
		// of an initial state that should be secret to all players.
		// (E.g., the initial board in multiplayer Sudoku or MineSweeper).
		// The server picks several random users (that we will call "calculators"),
		// and sends them gotRequestStateCalculation.
		// All these calculators must do the exact same call to doAllStoreStateCalculation,
		// i.e., the state calculation must be deterministic (you can use doAllRequestRandomState to create a hidden seed for the calculators).
		// serverEntries are all public (because the calculators should see state that is secret to the users)
		public function doAllRequestStateCalculation(keys:Array/*String*/):void { sendMessage( API_DoAllRequestStateCalculation.create(keys) ); }
		public function gotRequestStateCalculation(serverEntries:Array/*ServerEntry*/):void {}
		public function doAllStoreStateCalculation(userEntries:Array/*UserEntry*/):void { sendMessage( API_DoAllStoreStateCalculation.create(userEntries) ); }
		
		
		
		
	}
}
