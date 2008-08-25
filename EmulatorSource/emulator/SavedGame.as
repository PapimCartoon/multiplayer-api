package emulator
{
	import emulator.auto_copied.SerializableClass;

	public class SavedGame extends SerializableClass
	{
		public static const CLASS_VERSION_NUMBER:int = 3; 
		public var classVersionNumberForSharedObject:int = CLASS_VERSION_NUMBER;
		public var entries:Array;/*serverEntries*/
		public var players:Array;
		public var finishedGames:Array;/*FinishHistory*/
		public var extra_match_info:Object;
		public var match_started_time:int;
		public var playersNum:int;
		public var curTurn:int;
		public var name:String;
		public var gameName:String;
		
	}
}