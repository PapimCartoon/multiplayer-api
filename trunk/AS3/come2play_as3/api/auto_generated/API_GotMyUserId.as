package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

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
		override public function getFunctionId():int { return -121; }
		override public function getClassName():String { return 'API_GotMyUserId'; }
		override public function getMethodName():String { return 'gotMyUserId'; }
		override public function getFieldNames():Array { return ['myUserId']; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [myUserId]; }
		override public function getMethodParametersNum():int { return 1; }
	}
}
