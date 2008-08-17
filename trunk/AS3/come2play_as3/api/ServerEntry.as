package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
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
			if (obj.key==null) throw new Error('Missing field "key" when creating ServerEntry from the object='+JSON.stringify(obj));
			if (obj.value==null) throw new Error('Missing field "value" when creating ServerEntry from the object='+JSON.stringify(obj));
			if (obj.storedByUserId==null) throw new Error('Missing field "storedByUserId" when creating ServerEntry from the object='+JSON.stringify(obj));
			if (obj.authorizedUserIds==null) throw new Error('Missing field "authorizedUserIds" when creating ServerEntry from the object='+JSON.stringify(obj));
			if (obj.changedTimeInMilliSeconds==null) throw new Error('Missing field "changedTimeInMilliSeconds" when creating ServerEntry from the object='+JSON.stringify(obj));
			return new ServerEntry(obj.key, obj.value, obj.storedByUserId, obj.authorizedUserIds, obj.changedTimeInMilliSeconds)
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value)+', storedByUserId=' + JSON.stringify(storedByUserId)+', authorizedUserIds=' + JSON.stringify(authorizedUserIds)+', changedTimeInMilliSeconds=' + JSON.stringify(changedTimeInMilliSeconds); }
		public function toString():String { return '{ServerEntry: ' + getParametersAsString() + '}'; }
	}
}
