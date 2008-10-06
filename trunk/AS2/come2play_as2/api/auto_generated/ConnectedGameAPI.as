//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.ConnectedGameAPI extends BaseGameAPI {
		public function ConnectedGameAPI(someMovieClip:MovieClip) {
			super(someMovieClip);
		}
		public function doRegisterOnServer():Void { sendMessage( API_DoRegisterOnServer.create() ); }
		public function doTrace(name:String, message/*:Object*/):Void { sendMessage( API_DoTrace.create(name, message) ); }

// This is a AUTOMATICALLY GENERATED! Do not change!

		
		public function gotKeyboardEvent(isKeyDown:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void {}
		public function gotCustomInfo(infoEntries:Array/*InfoEntry*/):Void {}
		public function gotUserInfo(userId:Number, infoEntries:Array/*InfoEntry*/):Void {}
		public function gotUserDisconnected(userId:Number):Void {}
		public function gotMyUserId(myUserId:Number):Void {}
		public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, serverEntries:Array/*ServerEntry*/):Void {}
		public function gotMatchEnded(finishedPlayerIds:Array/*int*/):Void {}
		
		public function doStoreState(userEntries:Array/*UserEntry*/):Void { sendMessage( API_DoStoreState.create(userEntries) ); }

// This is a AUTOMATICALLY GENERATED! Do not change!

		public function gotStateChanged(serverEntries:Array/*ServerEntry*/):Void {}
		
		public function doConnectedSetScore(score:Number):Void { sendMessage( API_DoConnectedSetScore.create(score) ); }
		public function doConnectedEndMatch(didWin:Boolean):Void { sendMessage( API_DoConnectedEndMatch.create(didWin) ); }
		
		
		
		
		
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

