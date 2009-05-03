package emulator
{
	import emulator.auto_copied.*;

	public class SavedGame extends SerializableClass
	{
		//public static const CLASS_VERSION_NUMBER:int = 3; 
		//public var classVersionNumberForSharedObject:int = CLASS_VERSION_NUMBER;
		public var serverState:ObjectDictionary;
		public var deltaHistory:DeltaHistory;
		public var players:Array;/*int*/
		public var finishedGames:Array;/*FinishHistory*/
		public var name:String;
		public var gameName:String;
		
		public function SavedGame()
		{
			super("SavedGame");
		}
		
		static public function create(serverState:ObjectDictionary,players:Array,finishedGames:Array,name:String,gameName:String,deltaHistory:DeltaHistory):SavedGame
		{
			var res:SavedGame = new SavedGame();
			res.deltaHistory = deltaHistory;
			res.serverState = serverState;
			res.players = players.concat();
			res.finishedGames = finishedGames.concat();
			res.name = name;
			res.gameName = gameName;
			return res;
		}
	}
}