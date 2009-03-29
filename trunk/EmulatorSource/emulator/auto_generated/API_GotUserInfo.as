package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*;
	public  class API_GotUserInfo extends API_Message {
		public var userId:int;
		public var infoEntries:Array/*InfoEntry*/;
		public static function create(userId:int, infoEntries:Array/*InfoEntry*/):API_GotUserInfo {
			var res:API_GotUserInfo = new API_GotUserInfo();
			res.userId = userId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.infoEntries = infoEntries;
			return res;
		}
		public static var FUNCTION_ID:int = -123;
		public static var METHOD_NAME:String = 'gotUserInfo';
		public static var METHOD_PARAMS:Array = ['userId', 'infoEntries'];
	}
}
