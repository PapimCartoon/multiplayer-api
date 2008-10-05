package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class ServerEntry extends API_Message {
		public var key:Object;
		public var value:Object;
		public var storedByUserId:int;
		public var visibleToUserIds:Array/*int*/;
		public var changedTimeInMilliSeconds:int;

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static function create(key:Object, value:Object, storedByUserId:int, visibleToUserIds:Array/*int*/, changedTimeInMilliSeconds:int):ServerEntry {
			var res:ServerEntry = new ServerEntry();
			res.key = key;
			res.value = value;
			res.storedByUserId = storedByUserId;
			res.visibleToUserIds = visibleToUserIds;
			res.changedTimeInMilliSeconds = changedTimeInMilliSeconds;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 

// This is a AUTOMATICALLY GENERATED! Do not change!

			var pos:int = 0;
			this.key = parameters[pos++];
			this.value = parameters[pos++];
			this.storedByUserId = parameters[pos++];
			this.visibleToUserIds = parameters[pos++];
			this.changedTimeInMilliSeconds = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value)+', storedByUserId=' + JSON.stringify(storedByUserId)+', visibleToUserIds=' + JSON.stringify(visibleToUserIds)+', changedTimeInMilliSeconds=' + JSON.stringify(changedTimeInMilliSeconds); }
		override public function getFunctionId():int { return -85; }
		override public function toString():String { return '{ServerEntry:' +getParametersAsString() +'}'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodName():String { return 'serverEntry'; }
		override public function getMethodParameters():Array { return [key, value, storedByUserId, visibleToUserIds, changedTimeInMilliSeconds]; }
		override public function getMethodParametersNum():int { return 5; }
	}
}
