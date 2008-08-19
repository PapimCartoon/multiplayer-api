package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import emulator.JSON;
	
	import flash.display.*;
	import flash.utils.*;
	public  class InfoEntry  {
		public var key:String;
		public var value:Object/*Serializable*/;
		public function InfoEntry(key:String, value:Object/*Serializable*/) {
			this.key = key;
			this.value = value;
		}
		public static function object2InfoEntry(obj:Object):InfoEntry {
			if (obj['key']===undefined) throw new Error('Missing field "key" when creating InfoEntry from the object='+JSON.stringify(obj));
			if (obj['value']===undefined) throw new Error('Missing field "value" when creating InfoEntry from the object='+JSON.stringify(obj));
			return new InfoEntry(obj.key, obj.value)
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value); }
		public function toString():String { return '{InfoEntry: ' + getParametersAsString() + '}'; }
	}
}
