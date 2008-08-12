//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.ClientGameAPI extends BaseGameAPI {
		public function ClientGameAPI(someMovieClip:MovieClip) {
			super(someMovieClip);
		}
		public function gotKeyboardEvent(isKeyDown:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void {}
		public function gotCustomInfo(entries:Array/*Entry*/):Void {}
		public function gotUserInfo(userId:Number, entries:Array/*Entry*/):Void {}
		public function gotUserDisconnected(userId:Number):Void {}
		public function gotMyUserId(myUserId:Number):Void {}
		public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object/*Serializable*/, matchStartedTime:Number, userStateEntries:Array/*UserStateEntry*/):Void {}
		public function gotMatchEnded(finishedPlayerIds:Array/*int*/):Void {}
		
		
		public function doFinishedCallback(callbackName:String):Void { sendDoOperation('doFinishedCallback', arguments); }
		public function doRegisterOnServer():Void { sendDoOperation('doRegisterOnServer', arguments); }
		public function doTrace(name:String, message:Object/*Serializable*/):Void { sendDoOperation('doTrace', arguments); }
		
		public function doStoreState(stateEntries:Array/*StateEntry*/):Void { sendDoOperation('doStoreState', arguments); }
		public function gotStoredState(userId:Number, stateEntries:Array/*StateEntry*/):Void {}
		
		public function doAllEndMatch(finishedPlayers:Array/*PlayerMatchOver*/):Void { sendDoOperation('doAllEndMatch', arguments); }
		
		// if userId==-1, then nobody has the turn.
		// if milliSecondsInTurn==-1 then the default time per turn is used,
		// and if milliSecondsInTurn==0 then the user should do some actions immediately.
		public function doAllSetTurn(userId:Number, milliSecondsInTurn:Number):Void { sendDoOperation('doAllSetTurn', arguments); }
		public function gotTurnOf(userId:Number):Void {}
		
		
		// if userId of RevealEntry is -1, then the entry becomes PUBLIC
		public function doAllRevealState(revealEntries:Array/*RevealEntry*/):Void { sendDoOperation('doAllRevealState', arguments); }
		public function doAllShuffleState(keys:Array/*String*/):Void { sendDoOperation('doAllShuffleState', arguments); }
		
		// if userId=-1, then it is a bug of the game developer
		public function doAllFoundHacker(userId:Number, errorDescription:String):Void { sendDoOperation('doAllFoundHacker', arguments); }
		
		// doAllRequestStateCalculation is usually used to do a calculation
		// of an initial state that should be secret to all players.
		// (E.g., the initial board in multiplayer Sudoku or MineSweeper).
		// The server picks several random users,
		// and sends them gotRequestStateCalculation.
		// All the users must do the exact same calls to doStoreState
		public function doAllRequestStateCalculation(value:Object/*Serializable*/):Void { sendDoOperation('doAllRequestStateCalculation', arguments); }
		public function gotRequestStateCalculation(secretSeed:Number, value:Object/*Serializable*/):Void {}
		
	}
