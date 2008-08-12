package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class Entry  {
		public var key:String;
		public var value:Object/*Serializable*/;
		public function Entry(key:String, value:Object/*Serializable*/) {
			this.key = key;
			this.value = value;
		}
		public static function object2Entry(obj:Object):Entry {
			if (obj.key==null) throw new Error('Missing field key in creating object of type Entry in object='+JSON.stringify(obj));
			if (obj.value==null) throw new Error('Missing field value in creating object of type Entry in object='+JSON.stringify(obj));
			return new Entry(obj.key, obj.value)
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value); }
		public function toString():String { return '{Entry: ' + getParametersAsString() + '}'; }
	}
}
