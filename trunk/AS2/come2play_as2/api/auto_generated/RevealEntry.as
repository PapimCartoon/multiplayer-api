//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.RevealEntry  {
		public var key:String;
		public var userIds:Array/*int*/;
		public function RevealEntry(key:String, userIds:Array/*int*/) {
			this.key = key;
			this.userIds = userIds;
		}
		public static function object2RevealEntry(obj:Object):RevealEntry {
			if (obj['key']===undefined) throw new Error('Missing field "key" when creating RevealEntry from the object='+JSON.stringify(obj));
			if (obj['userIds']===undefined) throw new Error('Missing field "userIds" when creating RevealEntry from the object='+JSON.stringify(obj));
			return new RevealEntry(obj.key, obj.userIds)
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', userIds=' + JSON.stringify(userIds); }
		public function toString():String { return '{RevealEntry: ' + getParametersAsString() + '}'; }
	}
