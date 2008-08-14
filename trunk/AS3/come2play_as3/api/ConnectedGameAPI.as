package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	public  class ConnectedGameAPI extends BaseGameAPI {
		public function ConnectedGameAPI(someMovieClip:MovieClip) {
			super(someMovieClip);
		}
		public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void {}
		public function gotCustomInfo(entries:Array/*Entry*/):void {}
		public function gotUserInfo(userId:int, entries:Array/*Entry*/):void {}
		public function gotUserDisconnected(userId:int):void {}
		public function gotMyUserId(myUserId:int):void {}
		public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object/*Serializable*/, matchStartedTime:int, userStateEntries:Array/*UserStateEntry*/):void {}
		public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void {}
		
		public function doStoreState(stateEntries:Array/*StateEntry*/):void { sendMessage( new API_DoStoreState(stateEntries) ); }
		public function gotStoredState(userId:int, stateEntries:Array/*StateEntry*/):void {}
		
		public function doConnectedSetScore(score:int):void { sendMessage( new API_DoConnectedSetScore(score) ); }
		public function doConnectedEndMatch(didWin:Boolean):void { sendMessage( new API_DoConnectedEndMatch(didWin) ); }
		
		
		
		
		
	}
}
