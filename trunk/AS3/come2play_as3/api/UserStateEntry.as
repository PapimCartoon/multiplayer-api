package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class UserStateEntry  {
		public var userId:int;
		public var key:String;
		public var value:Object/*Serializable*/;
		public var isSecret:Boolean;
		public function UserStateEntry(userId:int, key:String, value:Object/*Serializable*/, isSecret:Boolean) {
			this.userId = userId;
			this.key = key;
			this.value = value;
			this.isSecret = isSecret;
		}
		public static function object2UserStateEntry(obj:Object):UserStateEntry {
			if (obj.userId==null) throw new Error('Missing field userId in creating object of type UserStateEntry in object='+JSON.stringify(obj));
			if (obj.key==null) throw new Error('Missing field key in creating object of type UserStateEntry in object='+JSON.stringify(obj));
			if (obj.value==null) throw new Error('Missing field value in creating object of type UserStateEntry in object='+JSON.stringify(obj));
			if (obj.isSecret==null) throw new Error('Missing field isSecret in creating object of type UserStateEntry in object='+JSON.stringify(obj));
			return new UserStateEntry(obj.userId, obj.key, obj.value, obj.isSecret)
		}
		public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', key=' + JSON.stringify(key)+', value=' + JSON.stringify(value)+', isSecret=' + JSON.stringify(isSecret); }
		public function toString():String { return '{UserStateEntry: ' + getParametersAsString() + '}'; }
	}
}
