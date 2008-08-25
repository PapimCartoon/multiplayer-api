//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.ServerEntry extends SerializableClass {
		public var key:String;
		public var value/*any type*/;
		public var storedByUserId:Number;

// This is a AUTOMATICALLY GENERATED! Do not change!

		public var authorizedUserIds:Array/*int*/;
		public var changedTimeInMilliSeconds:Number;

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static function create(key:String, value/*any type*/, storedByUserId:Number, authorizedUserIds:Array/*int*/, changedTimeInMilliSeconds:Number):ServerEntry {
			var res:ServerEntry = new ServerEntry();
			res.key = key;
			res.value = value;
			res.storedByUserId = storedByUserId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.authorizedUserIds = authorizedUserIds;
			res.changedTimeInMilliSeconds = changedTimeInMilliSeconds;
			return res;
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value)+', storedByUserId=' + JSON.stringify(storedByUserId)+', authorizedUserIds=' + JSON.stringify(authorizedUserIds)+', changedTimeInMilliSeconds=' + JSON.stringify(changedTimeInMilliSeconds); }

// This is a AUTOMATICALLY GENERATED! Do not change!

		public function toString():String { return '{ServerEntry: ' + getParametersAsString() + '}'; }
	}
