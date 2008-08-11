package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class UserStateEntry  {
		public var user_id:int;
		public var key:String;
		public var value:Object/*Serializable*/;
		public var is_secret:Boolean;
		public function UserStateEntry(user_id:int, key:String, value:Object/*Serializable*/, is_secret:Boolean) {
			this.user_id = user_id;
			this.key = key;
			this.value = value;
			this.is_secret = is_secret;
		}
		public static function object2UserStateEntry(obj:Object):UserStateEntry {
			if (obj.user_id==null) throw new Error('Missing field user_id in creating object of type UserStateEntry in object='+JSON.stringify(obj));
			if (obj.key==null) throw new Error('Missing field key in creating object of type UserStateEntry in object='+JSON.stringify(obj));
			if (obj.value==null) throw new Error('Missing field value in creating object of type UserStateEntry in object='+JSON.stringify(obj));
			if (obj.is_secret==null) throw new Error('Missing field is_secret in creating object of type UserStateEntry in object='+JSON.stringify(obj));
			return new UserStateEntry(obj.user_id, obj.key, obj.value, obj.is_secret)
		}
		public function toString():String { return '{UserStateEntry' + ': user_id=' + JSON.stringify(user_id) + ': key=' + JSON.stringify(key) + ': value=' + JSON.stringify(value) + ': is_secret=' + JSON.stringify(is_secret) + '}'; }
	}
}
