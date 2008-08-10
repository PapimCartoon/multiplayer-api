import come2play_as2.api.*;
	class come2play_as2.api.EnumSecretLevel
	{
		public var id:Number;
		public var name:String
		public function EnumSecretLevel(id:Number, name:String) {
			this.name = name;
			this.id = id;
			allEnums[id] = this;
		}
		public function toString():String {
			return name;
		}

		private static var allEnums:Array = [];
		public static function getFromId(id:Number):EnumSecretLevel {
			return allEnums[id];
		}

		public static var PUBLIC:EnumSecretLevel = new EnumSecretLevel(0,"PUBLIC");	
		public function is_PUBLIC():Boolean { return this==PUBLIC; }
		public static var SECRET:EnumSecretLevel = new EnumSecretLevel(1,"SECRET");	
		public function is_SECRET():Boolean { return this==SECRET; }
		public static var TOPSECRET:EnumSecretLevel = new EnumSecretLevel(2,"TOPSECRET");
		public function is_TOPSECRET():Boolean { return this==TOPSECRET; }
	}
