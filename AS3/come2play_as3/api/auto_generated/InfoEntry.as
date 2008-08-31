package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class InfoEntry extends API_Message {
		public var key:String;
		public var value:Object;
		public static function create(key:String, value:Object):InfoEntry {
			var res:InfoEntry = new InfoEntry();
			res.key = key;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.value = value;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.key = parameters[pos++];
			this.value = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value); }
		override public function toString():String { return '{InfoEntry:' +getParametersAsString() +'}'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodName():String { return 'InfoEntry'; }
		override public function getMethodParameters():Array { return [key, value]; }
	}
}
