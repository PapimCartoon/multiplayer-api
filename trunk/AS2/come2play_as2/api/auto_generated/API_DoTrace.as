//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoTrace extends API_Message {
		public var name:String;
		public var message:Object/*Serializable*/;
		public static function create(name:String, message:Object/*Serializable*/):API_DoTrace {
			var res:API_DoTrace = new API_DoTrace();
			res.name = name;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.message = message;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.name = parameters[pos++];
			this.message = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'name=' + JSON.stringify(name)+', message=' + JSON.stringify(message); }
		/*override*/ public function toString():String { return '{API_DoTrace:' +getParametersAsString() +'}'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodName():String { return 'doTrace'; }
		/*override*/ public function getMethodParameters():Array { return [name, message]; }
	}
