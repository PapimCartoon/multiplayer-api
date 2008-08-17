//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.ClientGameAPI extends BaseGameAPI {
		public function ClientGameAPI(someMovieClip:MovieClip) {
			super(someMovieClip);
		}
		public function gotKeyboardEvent(isKeyDown:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void {}
		public function gotCustomInfo(infoEntries:Array/*InfoEntry*/):Void {}
		public function gotUserInfo(userId:Number, infoEntries:Array/*InfoEntry*/):Void {}
		public function gotUserDisconnected(userId:Number):Void {}
		public function gotMyUserId(myUserId:Number):Void {}
		public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object/*Serializable*/, matchStartedTime:Number, serverEntries:Array/*ServerEntry*/):Void {}
		public function gotMatchEnded(finishedPlayerIds:Array/*int*/):Void {}
		
		public function doFinishedCallback(callbackName:String):Void { sendMessage( new API_DoFinishedCallback(callbackName) ); }
		public function doRegisterOnServer():Void { sendMessage( new API_DoRegisterOnServer() ); }
		public function doTrace(name:String, message:Object/*Serializable*/):Void { sendMessage( new API_DoTrace(name, message) ); }
		
		public function gotStateChanged(serverEntries:Array/*ServerEntry*/):Void {}
		
		public function doStoreState(userEntries:Array/*UserEntry*/):Void { sendMessage( new API_DoStoreState(userEntries) ); }
		
		public function doAllEndMatch(finishedPlayers:Array/*PlayerMatchOver*/):Void { sendMessage( new API_DoAllEndMatch(finishedPlayers) ); }
		
		// if userId==-1, then nobody has the turn.
		// if milliSecondsInTurn==-1 then the default time per turn is used,
		// and if milliSecondsInTurn==0 then the user should do some actions immediately.
		public function doAllSetTurn(userId:Number, milliSecondsInTurn:Number):Void { sendMessage( new API_DoAllSetTurn(userId, milliSecondsInTurn) ); }
		
		// if userId of RevealEntry is -1, then the entry becomes PUBLIC
		public function doAllRevealState(revealEntries:Array/*RevealEntry*/):Void { sendMessage( new API_DoAllRevealState(revealEntries) ); }
		
		public function doAllShuffleState(keys:Array/*String*/):Void { sendMessage( new API_DoAllShuffleState(keys) ); }
		
		public function doAllRequestRandomState(key:String, isSecret:Boolean):Void { sendMessage( new API_DoAllRequestRandomState(key, isSecret) ); }
		
		// if userId=-1, then it is a bug of the game developer
		public function doAllFoundHacker(userId:Number, errorDescription:String):Void { sendMessage( new API_DoAllFoundHacker(userId, errorDescription) ); }
		
		// doAllRequestStateCalculation is usually used to do a calculation
		// of an initial state that should be secret to all players.
		// (E.g., the initial board in multiplayer Sudoku or MineSweeper).
		// The server picks several random users (that we will call "calculators"),
		// and sends them gotRequestStateCalculation.
		// All these calculators must do the exact same call to doAllStoreStateCalculation,
		// i.e., the state calculation must be deterministic (you can use doAllRequestRandomState to create a hidden seed for the calculators).
		// serverEntries are all public (because the calculators should see state that is secret to the users)
		public function doAllRequestStateCalculation(keys:Array/*String*/):Void { sendMessage( new API_DoAllRequestStateCalculation(keys) ); }
		public function gotRequestStateCalculation(serverEntries:Array/*ServerEntry*/):Void {}
		public function doAllStoreStateCalculation(userEntries:Array/*UserEntry*/):Void { sendMessage( new API_DoAllStoreStateCalculation(userEntries) ); }
		
	}
