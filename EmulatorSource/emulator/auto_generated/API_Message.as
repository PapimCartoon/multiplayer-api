package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*;
	public  class API_Message extends SerializableClass {
		public function toString():String { 
			var fieldNames:Array = getFieldNames();
			var res:Array = [];
			for each (var key:String in fieldNames) {
				res.push( key + ":" + JSON.stringify(this[key]) ); 
			}
			return "{ $"+getClassName()+"$ " + res.join(" , ") + "}"; // see JSON.parse
		}
		public function getClassName():String { throw new Error("You must subclass API_Message!"); return null; }
		public function getParametersAsString():String { throw new Error("You must subclass API_Message!"); return null; }
		public function getFunctionId():int { throw new Error("You must subclass API_Message!"); return 0; }
		public function getMethodName():String { throw new Error("You must subclass API_Message!"); return null; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		public function setMethodParameters(parameters:Array):void { throw new Error("You must subclass API_Message!"); }
		public function getMethodParameters():Array { throw new Error("You must subclass API_Message!"); return null; }
		public function getFieldNames():Array { throw new Error("You must subclass API_Message!"); return null; }
		public function getMethodParametersNum():int { throw new Error("You must subclass API_Message!"); return -1; }
		public static const USER_INFO_KEY_name:String = "name";
		public static const USER_INFO_KEY_avatar_url:String = "avatar_url";
		public static const USER_INFO_KEY_supervisor:String = "supervisor";
		public static const USER_INFO_KEY_credibility:String = "credibility";
		public static const USER_INFO_KEY_game_rating:String = "game_rating";
		public static const CUSTOM_INFO_KEY_logoFullUrl:String = "CONTAINER_logoFullUrl";

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static const CUSTOM_INFO_KEY_secondsPerMatch:String = "CONTAINER_secondsPerMatch";
		public static const CUSTOM_INFO_KEY_secondsPerMove:String = "CONTAINER_secondsPerMove";
		public static const CUSTOM_INFO_KEY_gameStageX:String = "CONTAINER_gameStageX";
		public static const CUSTOM_INFO_KEY_gameStageY:String = "CONTAINER_gameStageY";
		public static const CUSTOM_INFO_KEY_gameHeight:String = "CONTAINER_gameHeight";
		public static const CUSTOM_INFO_KEY_gameWidth:String = "CONTAINER_gameWidth";
		public static const CUSTOM_INFO_KEY_gameFrameRate:String = "CONTAINER_gameFrameRate";
	}
}
