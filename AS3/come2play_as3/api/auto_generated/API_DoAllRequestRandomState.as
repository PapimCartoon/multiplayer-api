package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class API_DoAllRequestRandomState extends API_Message {
		public var key:String;
		public var isSecret:Boolean;
		public static function create(key:String, isSecret:Boolean):API_DoAllRequestRandomState { 
			var res:API_DoAllRequestRandomState = new API_DoAllRequestRandomState();
			res.key = key;
			res.isSecret = isSecret;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.key = parameters[pos++];
			this.isSecret = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', isSecret=' + JSON.stringify(isSecret); }
		override public function toString():String { return '{API_DoAllRequestRandomState:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'doAllRequestRandomState'; }
		override public function getMethodParameters():Array { return [key, isSecret]; }
	}
}
