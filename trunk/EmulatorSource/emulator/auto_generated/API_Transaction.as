package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*;
	public  class API_Transaction extends API_Message {
		public var callback:API_DoFinishedCallback;
		public var messages:Array/*API_Message*/;
		public static function create(callback:API_DoFinishedCallback, messages:Array/*API_Message*/):API_Transaction {
			var res:API_Transaction = new API_Transaction();
			res.callback = callback;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.messages = messages;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.callback = parameters[pos++];
			this.messages = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'callback=' + JSON.stringify(callback)+', messages=' + JSON.stringify(messages); }
		override public function toString():String { return '{API_Transaction:' +getParametersAsString() +'}'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodName():String { return 'API_Transaction'; }
		override public function getMethodParameters():Array { return [callback, messages]; }
	}
}
