package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*
	public  class API_DoAllShuffleState extends API_Message {
		public var keys:Array/*String*/;
		public static function create(keys:Array/*String*/):API_DoAllShuffleState { 
			var res:API_DoAllShuffleState = new API_DoAllShuffleState();
			res.keys = keys;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.keys = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'keys=' + JSON.stringify(keys); }
		override public function toString():String { return '{API_DoAllShuffleState:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'doAllShuffleState'; }
		override public function getMethodParameters():Array { return [keys]; }
	}
}
