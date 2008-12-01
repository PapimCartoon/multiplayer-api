package emulator
{
	import emulator.auto_copied.SerializableClass;
	
	import flash.net.SharedObject;

	public class ServerData extends SerializableClass
	{
		public var come2PlayData:Array;
		public var savedGamesData:Array;
		static public function create(come2PlayData:Array,savedGamesData:Array):ServerData
		{
			var res:ServerData = new ServerData();
			res.come2PlayData = come2PlayData;
			res.savedGamesData = savedGamesData;
			return res;
		}
		
	}
}