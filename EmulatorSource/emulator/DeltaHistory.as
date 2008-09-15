package emulator
{
	import emulator.auto_copied.SerializableClass;

	public class DeltaHistory extends SerializableClass
	{
		public var gameTurns:Array = new Array();
		public var currentGameTurn:int = 0;
		
		static public function create(gameTurns:Array/*Array*/,currentGameTurn:int):DeltaHistory
		{
			var res:DeltaHistory = new DeltaHistory();
			res.currentGameTurn = currentGameTurn;
			res.gameTurns = gameTurns;
			return res;
		}
		public function addPlayerDelta(playerDelta:PlayerDelta):void
		{
			var currentTurn:Array/*PlayerDelta*/ = gameTurns[currentTurn];
			for each(var pastPlayerDelta:PlayerDelta in currentTurn)
				if(playerDelta.playerId == pastPlayerDelta.playerId)
					return;
			currentTurn.push(playerDelta);
		}
		public function nextTurn():void
		{
			currentGameTurn++;
		}
		public function goToTurn(turnNum:int):void
		{
			currentGameTurn = turnNum;
		}
		public function toString():String
		{
			var str:String ="";
			for each(var tempTurn:Array in gameTurns)
			{
				for each(var playerDelta:PlayerDelta in tempTurn)
				{
					str+=playerDelta.toString()+"/n";
				}
				str+="/n";
			}
			return str;
		}
		public function getTurnString(turnNum:int):String
		{
			var str:String = "";
			var currentTurn:Array/*PlayerDelta*/ = gameTurns[turnNum];
			for each(var playerDelta:PlayerDelta in currentTurn)
				str+=playerDelta.toString()+"/n";
			return str;	
		}
		public function  addFullDelta(playerDeltas:Array/*PlayerDelta*/):void
		{
			for each(var playerdelta:PlayerDelta in playerDeltas)
				addPlayerDelta(playerdelta);
			nextTurn();
		}
		
	}
}