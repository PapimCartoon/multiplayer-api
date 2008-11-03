//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.ClientGameAPI extends BaseGameAPI {
		public function ClientGameAPI(someMovieClip:MovieClip) {
			super(someMovieClip);
		}
		public function doRegisterOnServer():Void { sendMessage( API_DoRegisterOnServer.create() ); }
		public function doTrace(name:String, message:Object):Void { sendMessage( API_DoTrace.create(name, message) ); }

// This is a AUTOMATICALLY GENERATED! Do not change!

		
		public function gotKeyboardEvent(isKeyDown:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void {}
		public function gotCustomInfo(infoEntries:Array/*InfoEntry*/):Void {}
		public function gotUserInfo(userId:Number, infoEntries:Array/*InfoEntry*/):Void {}
		public function gotUserDisconnected(userId:Number):Void {}
		public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, serverEntries:Array/*ServerEntry*/):Void {}
		public function gotMatchEnded(finishedPlayerIds:Array/*int*/):Void {}
		
		public function gotStateChanged(serverEntries:Array/*ServerEntry*/):Void {}
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		public function doStoreState(userEntries:Array/*UserEntry*/):Void { sendMessage( API_DoStoreState.create(userEntries) ); }
		public function doAllStoreState(userEntries:Array/*UserEntry*/):Void { sendMessage( API_DoAllStoreState.create(userEntries) ); }
		
		public function doAllEndMatch(finishedPlayers:Array/*PlayerMatchOver*/):Void { sendMessage( API_DoAllEndMatch.create(finishedPlayers) ); }
		
		// if userId==-1, then nobody has the turn.
		// if milliSecondsInTurn==-1 then the default time per turn is used,
		// and if milliSecondsInTurn==0 then the user should do some actions immediately, i.e., without GUI intervention.
		// (The time given depends on the network delay).
		public function doAllSetTurn(userId:Number, milliSecondsInTurn:Number/*<InAS3> = -1 </InAS3>*/):Void { sendMessage( API_DoAllSetTurn.create(userId, milliSecondsInTurn) ); }

// This is a AUTOMATICALLY GENERATED! Do not change!

		
		// if userId of RevealEntry is -1, then the entry becomes PUBLIC
		public function doAllRevealState(revealEntries:Array/*RevealEntry*/):Void { sendMessage( API_DoAllRevealState.create(revealEntries) ); }
		
		public function doAllShuffleState(keys:Array/*Object*/):Void { sendMessage( API_DoAllShuffleState.create(keys) ); }
		
		public function doAllRequestRandomState(key:Object, isSecret:Boolean/*<InAS3> = false </InAS3>*/):Void { sendMessage( API_DoAllRequestRandomState.create(key, isSecret) ); }
		
		// if userId=-1, then it is a bug of the game developer
		public function doAllFoundHacker(userId:Number, errorDescription:String):Void { sendMessage( API_DoAllFoundHacker.create(userId, errorDescription) ); }

// This is a AUTOMATICALLY GENERATED! Do not change!

		
		// doAllRequestStateCalculation is usually used to do a calculation
		// of an initial state that should be secret to all players.
		// (E.g., the initial board in multiplayer Sudoku or MineSweeper).
		// The server picks several random users (that we will call "calculators"),
		// and sends them gotRequestStateCalculation.
		// All these calculators must do the exact same call to doAllStoreStateCalculation,
		// i.e., the state calculation must be deterministic (you can use doAllRequestRandomState to create a hidden seed for the calculators).
		// serverEntries are all public (because the calculators should see state that is secret to the users)
		public function doAllRequestStateCalculation(keys:Array/*Object*/):Void { sendMessage( API_DoAllRequestStateCalculation.create(keys) ); }

// This is a AUTOMATICALLY GENERATED! Do not change!

		public function gotRequestStateCalculation(requestId:Number, serverEntries:Array/*ServerEntry*/):Void {}
		public function doAllStoreStateCalculation(requestId:Number, userEntries:Array/*UserEntry*/):Void { sendMessage( API_DoAllStoreStateCalculation.create(requestId, userEntries) ); }
		
		
		
		
		public static var USER_INFO_KEY_name:String = "name";
		public static var USER_INFO_KEY_avatar_url:String = "avatar_url";
		public static var USER_INFO_KEY_supervisor:String = "supervisor";
		public static var USER_INFO_KEY_credibility:String = "credibility";

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static var USER_INFO_KEY_game_rating:String = "game_rating";
		public static var CUSTOM_INFO_KEY_logoFullUrl:String = "CONTAINER_logoFullUrl";
		public static var CUSTOM_INFO_KEY_secondsPerMatch:String = "CONTAINER_secondsPerMatch";
		public static var CUSTOM_INFO_KEY_secondsPerMove:String = "CONTAINER_secondsPerMove";
		public static var CUSTOM_INFO_KEY_gameStageX:String = "CONTAINER_gameStageX";
		public static var CUSTOM_INFO_KEY_gameStageY:String = "CONTAINER_gameStageY";
		public static var CUSTOM_INFO_KEY_gameHeight:String = "CONTAINER_gameHeight";
		public static var CUSTOM_INFO_KEY_gameWidth:String = "CONTAINER_gameWidth";
		public static var CUSTOM_INFO_KEY_gameFrameRate:String = "CONTAINER_gameFrameRate";
		public static var CUSTOM_INFO_KEY_myUserId:String = "CONTAINER_myUserId";

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
