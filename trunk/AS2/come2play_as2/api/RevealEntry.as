//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.RevealEntry  {
		public var key:String;
		public var userId:Number;
		public function RevealEntry(key:String, userId:Number) {
			this.key = key;
			this.userId = userId;
		}
		public static function object2RevealEntry(obj:Object):RevealEntry {
			if (obj.key==null) throw new Error('Missing field key in creating object of type RevealEntry in object='+JSON.stringify(obj));
			if (obj.userId==null) throw new Error('Missing field userId in creating object of type RevealEntry in object='+JSON.stringify(obj));
			return new RevealEntry(obj.key, obj.userId)
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', userId=' + JSON.stringify(userId); }
		public function toString():String { return '{RevealEntry: ' + getParametersAsString() + '}'; }
	}
