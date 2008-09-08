package emulator
{
	import emulator.auto_copied.*;

	public class SavedGame extends SerializableClass
	{
		//public static const CLASS_VERSION_NUMBER:int = 3; 
		//public var classVersionNumberForSharedObject:int = CLASS_VERSION_NUMBER;
		public var serverState:ObjectDictionary
		public var players:Array;/*int*/
		public var finishedGames:Array;/*FinishHistory*/
		public var extra_match_info:Object;
		public var match_started_time:int;
		public var name:String;
		public var gameName:String;
		
		static public function create(serverState:ObjectDictionary,players:Array,finishedGames:Array,extra_match_info:Object,match_started_time:int,name:String,gameName:String):SavedGame
		{
			var res:SavedGame = new SavedGame();
			res.serverState = serverState;
			res.players = players.concat();
			res.finishedGames = finishedGames.concat();
			res.extra_match_info = extra_match_info;
			res.match_started_time = match_started_time;
			res.name = name;
			res.gameName = gameName;
			return res;
		}
	}
}