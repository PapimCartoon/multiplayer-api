package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class StateEntry  {
		public var key:String;
		public var value:Object/*Serializable*/;
		public var is_secret:Boolean;
		public function StateEntry(key:String, value:Object/*Serializable*/, is_secret:Boolean) {
			this.key = key;
			this.value = value;
			this.is_secret = is_secret;
		}
		public static function object2StateEntry(obj:Object):StateEntry {
			if (obj.key==null) throw new Error('Missing field key in creating object of type StateEntry in object='+JSON.stringify(obj));
			if (obj.value==null) throw new Error('Missing field value in creating object of type StateEntry in object='+JSON.stringify(obj));
			if (obj.is_secret==null) throw new Error('Missing field is_secret in creating object of type StateEntry in object='+JSON.stringify(obj));
			return new StateEntry(obj.key, obj.value, obj.is_secret)
		}
		public function toString():String { return '{StateEntry' + ': key=' + JSON.stringify(key) + ': value=' + JSON.stringify(value) + ': is_secret=' + JSON.stringify(is_secret) + '}'; }
	}
}
