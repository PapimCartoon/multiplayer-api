package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
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
		
		public function doStoreState(stateEntries:Array/*StateEntry*/):void { sendDoOperation('doStoreState', arguments); }
		public function gotStoredState(userId:int, stateEntries:Array/*StateEntry*/):void {}
		
		public function doConnectedSetScore(score:int):void { sendDoOperation('doConnectedSetScore', arguments); }
		public function doConnectedMatchOver(didWin:Boolean):void { sendDoOperation('doConnectedMatchOver', arguments); }
		
		
		
		
	}
}
