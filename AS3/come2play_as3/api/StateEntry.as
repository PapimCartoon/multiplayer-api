package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	public  class StateEntry  {
		public var key:String;
		public var value:Object/*Serializable*/;
		public var isSecret:Boolean;
		public function StateEntry(key:String, value:Object/*Serializable*/, isSecret:Boolean) {
			this.key = key;
			this.value = value;
			this.isSecret = isSecret;
		}
		public static function object2StateEntry(obj:Object):StateEntry {
			if (obj.key==null) throw new Error('Missing field key in creating object of type StateEntry in object='+JSON.stringify(obj));
			if (obj.value==null) throw new Error('Missing field value in creating object of type StateEntry in object='+JSON.stringify(obj));
			if (obj.isSecret==null) throw new Error('Missing field isSecret in creating object of type StateEntry in object='+JSON.stringify(obj));
			return new StateEntry(obj.key, obj.value, obj.isSecret)
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value)+', isSecret=' + JSON.stringify(isSecret); }
		public function toString():String { return '{StateEntry: ' + getParametersAsString() + '}'; }
	}
}
