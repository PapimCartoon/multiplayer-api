package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	import come2play_as3.api.*
	public  class UserEntry  {
		public var key:String;
		public var value:Object/*Serializable*/;
		public var isSecret:Boolean;
		public function UserEntry(key:String, value:Object/*Serializable*/, isSecret:Boolean) {
			this.key = key;
			this.value = value;
			this.isSecret = isSecret;
		}
		public static function object2UserEntry(obj:Object):UserEntry {
			if (obj['key']===undefined) throw new Error('Missing field "key" when creating UserEntry from the object='+JSON.stringify(obj));
			if (obj['value']===undefined) throw new Error('Missing field "value" when creating UserEntry from the object='+JSON.stringify(obj));
			if (obj['isSecret']===undefined) throw new Error('Missing field "isSecret" when creating UserEntry from the object='+JSON.stringify(obj));
			return new UserEntry(obj.key, obj.value, obj.isSecret)
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value)+', isSecret=' + JSON.stringify(isSecret); }
		public function toString():String { return '{UserEntry: ' + getParametersAsString() + '}'; }
	}
}
