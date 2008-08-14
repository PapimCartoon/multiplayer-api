//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.ConnectedGameAPI extends BaseGameAPI {
		public function ConnectedGameAPI(someMovieClip:MovieClip) {
			super(someMovieClip);
		}
		public function gotKeyboardEvent(isKeyDown:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void {}
		public function gotCustomInfo(entries:Array/*Entry*/):Void {}
		public function gotUserInfo(userId:Number, entries:Array/*Entry*/):Void {}
		public function gotUserDisconnected(userId:Number):Void {}
		public function gotMyUserId(myUserId:Number):Void {}
		public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object/*Serializable*/, matchStartedTime:Number, userStateEntries:Array/*UserStateEntry*/):Void {}
		public function gotMatchEnded(finishedPlayerIds:Array/*int*/):Void {}
		
		public function doStoreState(stateEntries:Array/*StateEntry*/):Void { sendMessage( new API_DoStoreState(stateEntries) ); }
		public function gotStoredState(userId:Number, stateEntries:Array/*StateEntry*/):Void {}
		
		public function doConnectedSetScore(score:Number):Void { sendMessage( new API_DoConnectedSetScore(score) ); }
		public function doConnectedEndMatch(didWin:Boolean):Void { sendMessage( new API_DoConnectedEndMatch(didWin) ); }
		
		
		
		
		
	}
