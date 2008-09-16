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
				gameTurns = gameTurns.slice(0,currentTurn);
			}
			currentTurn++
		}
		public function addDelta(ongoingPlayerIds:Array/*int*/,serverEntries:Array/*ServerEntry*/):void
		{
			checkIfTop();
			gameTurns.push(PlayerDelta.create(ongoingPlayerIds,serverEntries,null));
		}
		public function addPlayerMatchOver(ongoingPlayerIds:Array/*int*/,finishHistory:FinishHistory):void
		{
			checkIfTop();
			gameTurns.push(PlayerDelta.create(ongoingPlayerIds,[],finishHistory));
		}	
		public function getServerEntries(tillTurn:int):Array/*ServerEntry*/
		{
			currentTurn = tillTurn;
			var playerDelta:PlayerDelta;
			var serverEntries:Array/*ServerEntry*/ = new Array();
			for(var i:int;i<=tillTurn;i++)
			{
				playerDelta = gameTurns[i]
				serverEntries = serverEntries.concat(playerDelta.serverEntries);
			}
			return serverEntries;
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