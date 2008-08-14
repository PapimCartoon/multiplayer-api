//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.ServerEntry  {
		public var key:String;
		public var value:Object/*Serializable*/;
		public var storedByUserId:Number;
		public var authorizedUserIds:Array/*int*/;
		public var changedTimeInMilliSeconds:Number;
		public function ServerEntry(key:String, value:Object/*Serializable*/, storedByUserId:Number, authorizedUserIds:Array/*int*/, changedTimeInMilliSeconds:Number) {
			this.key = key;
			this.value = value;
			this.storedByUserId = storedByUserId;
			this.authorizedUserIds = authorizedUserIds;
			this.changedTimeInMilliSeconds = changedTimeInMilliSeconds;
		}
		public static function object2ServerEntry(obj:Object):ServerEntry {
			if (obj.key==null) throw new Error('Missing field key in creating object of type ServerEntry in object='+JSON.stringify(obj));
			if (obj.value==null) throw new Error('Missing field value in creating object of type ServerEntry in object='+JSON.stringify(obj));
			if (obj.storedByUserId==null) throw new Error('Missing field storedByUserId in creating object of type ServerEntry in object='+JSON.stringify(obj));
			if (obj.authorizedUserIds==null) throw new Error('Missing field authorizedUserIds in creating object of type ServerEntry in object='+JSON.stringify(obj));
			if (obj.changedTimeInMilliSeconds==null) throw new Error('Missing field changedTimeInMilliSeconds in creating object of type ServerEntry in object='+JSON.stringify(obj));
			return new ServerEntry(obj.key, obj.value, obj.storedByUserId, obj.authorizedUserIds, obj.changedTimeInMilliSeconds)
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value)+', storedByUserId=' + JSON.stringify(storedByUserId)+', authorizedUserIds=' + JSON.stringify(authorizedUserIds)+', changedTimeInMilliSeconds=' + JSON.stringify(changedTimeInMilliSeconds); }
		public function toString():String { return '{ServerEntry: ' + getParametersAsString() + '}'; }
	}
