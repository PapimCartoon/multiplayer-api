package come2play_as3.api
{
	public final class EnumSecretLevel
	{
		public var id:int;
		public var name:String
		public function EnumSecretLevel(id:int, name:String) {
			this.name = name;
			this.id = id;
			allEnums[id] = this;
		}
		public function toString():String {
			return name;
		}

		private static var allEnums:Array = [];
		public static function getFromId(id:int):EnumSecretLevel {
			return allEnums[id];
		}

		public static const PUBLIC:EnumSecretLevel = new EnumSecretLevel(0,"PUBLIC");	
		public function is_PUBLIC():Boolean { return this==PUBLIC; }
		public static const SECRET:EnumSecretLevel = new EnumSecretLevel(1,"SECRET");	
		public function is_SECRET():Boolean { return this==SECRET; }
		public static const TOPSECRET:EnumSecretLevel = new EnumSecretLevel(2,"TOPSECRET");
		public function is_TOPSECRET():Boolean { return this==TOPSECRET; }
	}
}