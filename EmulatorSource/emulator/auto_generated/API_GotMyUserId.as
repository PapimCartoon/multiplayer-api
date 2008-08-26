package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*
	public  class API_GotMyUserId extends API_Message {
		public var myUserId:int;
		public static function create(myUserId:int):API_GotMyUserId {
			var res:API_GotMyUserId = new API_GotMyUserId();
			res.myUserId = myUserId;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.myUserId = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'myUserId=' + JSON.stringify(myUserId); }
		override public function toString():String { return '{API_GotMyUserId:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'gotMyUserId'; }
		override public function getMethodParameters():Array { return [myUserId]; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
