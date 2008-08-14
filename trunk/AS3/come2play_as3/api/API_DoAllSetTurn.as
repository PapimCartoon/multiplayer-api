package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	public  class API_DoAllSetTurn extends API_Message {
		public var userId:int;
		public var milliSecondsInTurn:int;
		public function API_DoAllSetTurn(userId:int, milliSecondsInTurn:int) { super('doAllSetTurn',arguments); 
			this.userId = userId;
			this.milliSecondsInTurn = milliSecondsInTurn;
		}
		override public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', milliSecondsInTurn=' + JSON.stringify(milliSecondsInTurn); }
	}
}
