package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	public  class RevealEntry  {
		public var key:String;
		public var userIds:Array/*int*/;
		public function RevealEntry(key:String, userIds:Array/*int*/) {
			this.key = key;
			this.userIds = userIds;
		}
		public static function object2RevealEntry(obj:Object):RevealEntry {
			if (obj.key==null) throw new Error('Missing field key in creating object of type RevealEntry in object='+JSON.stringify(obj));
			if (obj.userIds==null) throw new Error('Missing field userIds in creating object of type RevealEntry in object='+JSON.stringify(obj));
			return new RevealEntry(obj.key, obj.userIds)
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', userIds=' + JSON.stringify(userIds); }
		public function toString():String { return '{RevealEntry: ' + getParametersAsString() + '}'; }
	}
}
