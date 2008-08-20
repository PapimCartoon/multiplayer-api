package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*
	public  class API_DoAllSetTurn extends API_Message {
		public var userId:int;
		public var milliSecondsInTurn:int;
		public static function create(userId:int, milliSecondsInTurn:int):API_DoAllSetTurn { 
			var res:API_DoAllSetTurn = new API_DoAllSetTurn();
			res.userId = userId;
			res.milliSecondsInTurn = milliSecondsInTurn;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.userId = parameters[pos++];
			this.milliSecondsInTurn = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', milliSecondsInTurn=' + JSON.stringify(milliSecondsInTurn); }
		override public function toString():String { return '{API_DoAllSetTurn:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'doAllSetTurn'; }
		override public function getMethodParameters():Array { return [userId, milliSecondsInTurn]; }
	}
}
