//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotMatchEnded extends API_Message {
		public var finishedPlayerIds:Array/*int*/;
		public static function create(finishedPlayerIds:Array/*int*/):API_GotMatchEnded {
			var res:API_GotMatchEnded = new API_GotMatchEnded();
			res.finishedPlayerIds = finishedPlayerIds;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.finishedPlayerIds = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'finishedPlayerIds=' + JSON.stringify(finishedPlayerIds); }
		/*override*/ public function toString():String { return '{API_GotMatchEnded:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'gotMatchEnded'; }
		/*override*/ public function getMethodParameters():Array { return [finishedPlayerIds]; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

