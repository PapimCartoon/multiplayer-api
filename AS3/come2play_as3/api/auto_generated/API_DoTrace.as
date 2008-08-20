package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class API_DoTrace extends API_Message {
		public var name:String;
		public var message:Object/*Serializable*/;
		public static function create(name:String, message:Object/*Serializable*/):API_DoTrace { 
			var res:API_DoTrace = new API_DoTrace();
			res.name = name;
			res.message = message;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.name = parameters[pos++];
			this.message = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'name=' + JSON.stringify(name)+', message=' + JSON.stringify(message); }
		override public function toString():String { return '{API_DoTrace:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'doTrace'; }
		override public function getMethodParameters():Array { return [name, message]; }
	}
}
