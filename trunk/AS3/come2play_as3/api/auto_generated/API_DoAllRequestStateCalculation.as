package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class API_DoAllRequestStateCalculation extends API_Message {
		public var keys:Array/*String*/;
		public static function create(keys:Array/*String*/):API_DoAllRequestStateCalculation { 
			var res:API_DoAllRequestStateCalculation = new API_DoAllRequestStateCalculation();
			res.keys = keys;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.keys = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'keys=' + JSON.stringify(keys); }
		override public function toString():String { return '{API_DoAllRequestStateCalculation:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'doAllRequestStateCalculation'; }
		override public function getMethodParameters():Array { return [keys]; }
	}
}
