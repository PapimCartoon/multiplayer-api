package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class RevealEntry  {
		public var key:String;
		public var user_id:int;
		public function RevealEntry(key:String, user_id:int) {
			this.key = key;
			this.user_id = user_id;
		}
		public static function object2RevealEntry(obj:Object):RevealEntry {
			if (obj.key==null) throw new Error('Missing field key in creating object of type RevealEntry in object='+JSON.stringify(obj));
			if (obj.user_id==null) throw new Error('Missing field user_id in creating object of type RevealEntry in object='+JSON.stringify(obj));
			return new RevealEntry(obj.key, obj.user_id)
		}
		public function toString():String { return '{RevealEntry' + ': key=' + JSON.stringify(key) + ': user_id=' + JSON.stringify(user_id) + '}'; }
	}
}
