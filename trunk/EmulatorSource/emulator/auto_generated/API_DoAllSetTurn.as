package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import emulator.JSON;
	
	import flash.display.*;
	import flash.utils.*;
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
