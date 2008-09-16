package emulator
{
	import emulator.auto_copied.SerializableClass;

	public class DeltaHistory extends SerializableClass
	{
		public var gameTurns:Array = new Array();
		public var currentGameTurn:int = 0;
		public var detaLength:int;
		
		static public function create(gameTurns:Array/*Array*/,currentGameTurn:int):DeltaHistory
		{
			var res:DeltaHistory = new DeltaHistory();
			res.currentGameTurn = currentGameTurn;
			res.gameTurns = gameTurns;
			return res;
		}
		public function addPlayerDelta(playerDelta:PlayerDelta):void
		{
			if(gameTurns[currentGameTurn] == null)
				gameTurns[currentGameTurn] = new Array();
			var currentTurn:Array/*PlayerDelta*/ = gameTurns[currentGameTurn];
			for each(var pastPlayerDelta:PlayerDelta in currentTurn)
			{
				if(playerDelta.playerId == pastPlayerDelta.playerId){
					return;
				}
			}
			currentTurn.push(playerDelta);
		}
		public function nextTurn():void
		{
			currentGameTurn++;
			if(detaLength < currentGameTurn)
				detaLength = currentGameTurn;
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
					str+=playerDelta.toString()+"\n";
				}
				str+="\n";
			}
			return str;
		}
		public function getTurnString(turnNum:int):String
		{
			var str:String = "";
			var currentTurn:Array/*PlayerDelta*/ = gameTurns[turnNum];
			for each(var playerDelta:PlayerDelta in currentTurn)
				str+=playerDelta.toString()+"\n";
			return str;	
		}
		public function getTurnForPrint(turnNum:int):Array/*String*/
		{
			var dataToPrint:Array = new Array
			var currentTurn:Array/*PlayerDelta*/ = gameTurns[turnNum];
			dataToPrint[0] = "";
			dataToPrint[1] = "";
			for each(var playerDelta:PlayerDelta in currentTurn)
			{
				dataToPrint[0]+= String(playerDelta.playerId) + ",";
				dataToPrint[1]+= playerDelta.serverEntries.toString();
			}
			return dataToPrint;	
			
		}
		public function addFullDelta(serverEntries:Array/*ServerEntry*/,ongoingPlayers:Array):void
		{
			for each(var playerId:int in ongoingPlayers)
				addPlayerDelta(PlayerDelta.create(playerId,serverEntries));
			nextTurn();
		}
		
		public function getDeltaLength():int
		{
			return gameTurns.length;
		}
		
	}
}