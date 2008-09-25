package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class API_Transaction extends API_Message {
		public var messages:Array/*API_Message*/;
		public static function create(messages:Array/*API_Message*/):API_Transaction {
			var res:API_Transaction = new API_Transaction();
			res.messages = messages;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.messages = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'messages=' + JSON.stringify(messages); }
		override public function toString():String { return '{API_Transaction:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'API_Transaction'; }
		override public function getMethodParameters():Array { return [messages]; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
