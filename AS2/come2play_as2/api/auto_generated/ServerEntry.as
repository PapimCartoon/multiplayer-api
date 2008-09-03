//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.ServerEntry extends API_Message {
		public var key:String;
		public var value/*any type*/;
		public var storedByUserId:Number;
		public var visibleToUserIds:Array/*int*/;
		public var changedTimeInMilliSeconds:Number;

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static function create(key:String, value/*any type*/, storedByUserId:Number, visibleToUserIds:Array/*int*/, changedTimeInMilliSeconds:Number):ServerEntry {
			var res:ServerEntry = new ServerEntry();
			res.key = key;
			res.value = value;
			res.storedByUserId = storedByUserId;
			res.visibleToUserIds = visibleToUserIds;
			res.changedTimeInMilliSeconds = changedTimeInMilliSeconds;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 

// This is a AUTOMATICALLY GENERATED! Do not change!

			var pos:Number = 0;
			this.key = parameters[pos++];
			this.value = parameters[pos++];
			this.storedByUserId = parameters[pos++];
			this.visibleToUserIds = parameters[pos++];
			this.changedTimeInMilliSeconds = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value)+', storedByUserId=' + JSON.stringify(storedByUserId)+', visibleToUserIds=' + JSON.stringify(visibleToUserIds)+', changedTimeInMilliSeconds=' + JSON.stringify(changedTimeInMilliSeconds); }
		/*override*/ public function toString():String { return '{ServerEntry:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'ServerEntry'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodParameters():Array { return [key, value, storedByUserId, visibleToUserIds, changedTimeInMilliSeconds]; }
	}
