package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class API_DoStoreState extends API_Message {
		public var userEntries:Array/*UserEntry*/;
		public static function create(userEntries:Array/*UserEntry*/):API_DoStoreState { 
			var res:API_DoStoreState = new API_DoStoreState();
			res.userEntries = userEntries;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.userEntries = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'userEntries=' + JSON.stringify(userEntries); }
		override public function toString():String { return '{API_DoStoreState:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'doStoreState'; }
		override public function getMethodParameters():Array { return [userEntries]; }
	}
}
