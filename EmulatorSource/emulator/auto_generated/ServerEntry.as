package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import emulator.JSON;
	
	import flash.display.*;
	import flash.utils.*;
	public  class ServerEntry  {
		public var key:String;
		public var value:Object/*Serializable*/;
		public var storedByUserId:int;
		public var authorizedUserIds:Array/*int*/;
		public var changedTimeInMilliSeconds:int;
		public function ServerEntry(key:String, value:Object/*Serializable*/, storedByUserId:int, authorizedUserIds:Array/*int*/, changedTimeInMilliSeconds:int) {
			this.key = key;
			this.value = value;
			this.storedByUserId = storedByUserId;
			this.authorizedUserIds = authorizedUserIds;
			this.changedTimeInMilliSeconds = changedTimeInMilliSeconds;
		}
		public static function object2ServerEntry(obj:Object):ServerEntry {
			if (obj['key']===undefined) throw new Error('Missing field "key" when creating ServerEntry from the object='+JSON.stringify(obj));
			if (obj['value']===undefined) throw new Error('Missing field "value" when creating ServerEntry from the object='+JSON.stringify(obj));
			if (obj['storedByUserId']===undefined) throw new Error('Missing field "storedByUserId" when creating ServerEntry from the object='+JSON.stringify(obj));
			if (obj['authorizedUserIds']===undefined) throw new Error('Missing field "authorizedUserIds" when creating ServerEntry from the object='+JSON.stringify(obj));
			if (obj['changedTimeInMilliSeconds']===undefined) throw new Error('Missing field "changedTimeInMilliSeconds" when creating ServerEntry from the object='+JSON.stringify(obj));
			return new ServerEntry(obj.key, obj.value, obj.storedByUserId, obj.authorizedUserIds, obj.changedTimeInMilliSeconds)
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value)+', storedByUserId=' + JSON.stringify(storedByUserId)+', authorizedUserIds=' + JSON.stringify(authorizedUserIds)+', changedTimeInMilliSeconds=' + JSON.stringify(changedTimeInMilliSeconds); }
		public function toString():String { return '{ServerEntry: ' + getParametersAsString() + '}'; }
	}
}
