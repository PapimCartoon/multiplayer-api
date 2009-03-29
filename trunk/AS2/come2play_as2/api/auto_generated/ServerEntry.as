//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.ServerEntry extends API_Message {
		public var key/*any type*/;
		public var value/*any type*/;
		public var storedByUserId:Number;
		public var visibleToUserIds:Array/*int*/;
		public var changedTimeInMilliSeconds:Number;

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static function create(key/*any type*/, value/*any type*/, storedByUserId:Number, visibleToUserIds:Array/*int*/, changedTimeInMilliSeconds:Number):ServerEntry {
			var res:ServerEntry = new ServerEntry();
			res.key = key;
			res.value = value;
			res.storedByUserId = storedByUserId;
			res.visibleToUserIds = visibleToUserIds;
			res.changedTimeInMilliSeconds = changedTimeInMilliSeconds;
			return res;
		}
		public static var FUNCTION_ID:Number = -86;

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static var METHOD_NAME:String = 'serverEntry';
		public static var METHOD_PARAMS:Array = ['key', 'value', 'storedByUserId', 'visibleToUserIds', 'changedTimeInMilliSeconds'];
	}
