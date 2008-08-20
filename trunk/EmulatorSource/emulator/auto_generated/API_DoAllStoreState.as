package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*
	public  class API_DoAllStoreState extends API_Message {
		public var userEntries:Array/*UserEntry*/;
		public static function create(userEntries:Array/*UserEntry*/):API_DoAllStoreState { 
			var res:API_DoAllStoreState = new API_DoAllStoreState();
			res.userEntries = userEntries;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.userEntries = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'userEntries=' + JSON.stringify(userEntries); }
		override public function toString():String { return '{API_DoAllStoreState:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'doAllStoreState'; }
		override public function getMethodParameters():Array { return [userEntries]; }
	}
}
