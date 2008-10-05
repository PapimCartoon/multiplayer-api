package emulator
{
	import emulator.auto_copied.SerializableClass;

	public class DeltaHistory extends SerializableClass
	{
		public var gameTurns:Array = new Array();
		public var currentTurn:int = 0;
		static public function create(gameTurns:Array/*Array*/,currentGameTurn:int):DeltaHistory
		{
			var res:DeltaHistory = new DeltaHistory();
			res.gameTurns = gameTurns;
			return res;
		}
		
		private function checkIfTop():void
		{
			if(currentTurn < gameTurns.length)
			{
				gameTurns = gameTurns.slice(0,currentTurn+1);
			}
			currentTurn++
		}
		public function getNextTime():int
		{
			var playerDelta:PlayerDelta = gameTurns[currentTurn];
			if(playerDelta != null)
				return playerDelta.changedTime;
			else
				return -1;
		}
		public function addDelta(ongoingPlayerIds:Array/*int*/,serverEntries:Array/*ServerEntry*/,changedTime:int):void
		{
			checkIfTop();
			gameTurns.push(PlayerDelta.create(ongoingPlayerIds,serverEntries,null,changedTime));
		}
		public function addPlayerMatchOver(ongoingPlayerIds:Array/*int*/,finishHistory:FinishHistory,changedTime:int):void
		{	
			checkIfTop();
			gameTurns.push(PlayerDelta.create(ongoingPlayerIds,[],finishHistory,changedTime));
		}	
		public function getDelta(deltaNum:int):PlayerDelta
		{
			currentTurn = deltaNum;
			return gameTurns[deltaNum];
		}
		public function getServerEntries(tillTurn:int):Array/*ServerEntry*/
		{
			currentTurn = tillTurn;
			var playerDelta:PlayerDelta;
			var serverEntries:Array/*ServerEntry*/ = new Array();
			for(var i:int=0;i<=tillTurn;i++)
			{
				playerDelta = gameTurns[i]
				serverEntries = serverEntries.concat(playerDelta.serverEntries);
			}
			return serverEntries;
		}
		public function getFinishedGames(tillTurn:int):Array/*FinishHistory*/
		{
			currentTurn = tillTurn;
			var playerDelta:PlayerDelta;
			var finishedHistory:Array/*FinishHistory*/ = new Array();
			for(var i:int=0;i<=tillTurn;i++)
			{
				playerDelta = gameTurns[i];
				if(playerDelta.serverEntries.length == 0)
					finishedHistory.push(playerDelta.finishHistory);
			}
			return finishedHistory;
		}
		public function getPlayers(tillTurn:int):Array/*int*/
		{
			var playerDelta:PlayerDelta = gameTurns[tillTurn]
			return playerDelta.playerIds;
		}	
		public function toString():String
		{
			var str:String ="";
			for each(var playerDelta:PlayerDelta in gameTurns)
			{
				str+= playerDelta.toString()+" \n ";
			}
			return str;
		}
		
	}
}