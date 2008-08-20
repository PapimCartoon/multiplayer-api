package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*
	public  class ServerEntry extends SerializableClass {
		public var key:String;
		public var value:*;
		public var storedByUserId:int;
		public var authorizedUserIds:Array/*int*/;
		public var changedTimeInMilliSeconds:int;
		public static function create(key:String, value:*, storedByUserId:int, authorizedUserIds:Array/*int*/, changedTimeInMilliSeconds:int):ServerEntry {
			var res:ServerEntry = new ServerEntry();
			res.key = key;
			res.value = value;
			res.storedByUserId = storedByUserId;
			res.authorizedUserIds = authorizedUserIds;
			res.changedTimeInMilliSeconds = changedTimeInMilliSeconds;
			return res;
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value)+', storedByUserId=' + JSON.stringify(storedByUserId)+', authorizedUserIds=' + JSON.stringify(authorizedUserIds)+', changedTimeInMilliSeconds=' + JSON.stringify(changedTimeInMilliSeconds); }
		public function toString():String { return '{ServerEntry: ' + getParametersAsString() + '}'; }
	}
}
