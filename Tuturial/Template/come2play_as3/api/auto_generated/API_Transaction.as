package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

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
		override public function getFunctionId():int { return -85; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getClassName():String { return 'API_Transaction'; }
		override public function getMethodName():String { return 'aPI_Transaction'; }
		override public function getFieldNames():Array { return ['callback', 'messages']; }
		override public function getMethodParameters():Array { return [callback, messages]; }
		override public function getMethodParametersNum():int { return 2; }
	}
}
