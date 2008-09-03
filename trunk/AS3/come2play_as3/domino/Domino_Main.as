package come2play_as3.domino
{
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	
	public class Domino_Main extends ClientGameAPI
	{
		private static var cubeMaxValue:int = 7;
		private var currentTurn:int;
		
		private var domino_Logic:Domino_Logic;
		private var myUserId:int; //my user id
		private var users:Array; // information about all users
		private var players:Array; //playing user ids
		public var gameEnded:Boolean;
	/** 
	 * Written by: Ofir Vainshtein (ofirvins@yahoo.com)
 	**/
		public function Domino_Main(graphics:MovieClip)
		{ 
			super(graphics); 
			users = new Array(); 
			domino_Logic  = new Domino_Logic(this,graphics);
			setTimeout(doRegisterOnServer,100);
		}
		
		private function getTurnOf():int
		{
			return players[currentTurn%players.length];	
		}
		public function sendPlayerMove(playerMove:PlayerMove):void
		{
			doStoreState([UserEntry.create("Move_"+playerMove.key,playerMove,false)])
			//currentTurn++;
		}
		public function endGame(playerMatchOverArr:Array):void
		{
			doAllEndMatch(playerMatchOverArr);
		}
		public function refreshTurn(playerPos:int):void
		{
			currentTurn=playerPos;
		}
		public function setNextTurn():void
		{
			currentTurn++;
			doAllSetTurn(getTurnOf(),-1);
		}
		public function noMoves():void
		{
			doStoreState([UserEntry.create("player_"+myUserId,NoMoves.create(myUserId),false)]);
			var userEntry:RevealEntry = domino_Logic.nextDomino(myUserId);
			if(userEntry != null)
				doAllRevealState([userEntry]);
			setNextTurn();
			
		}
		public function foundHacker(playerId:int):void
		{
			doAllFoundHacker(playerId,"player does not have this key");	
		}
		public function revealHands(revealEntries:Array/*RevealEntry*/):void
		{
			gameEnded = true;
			doAllRevealState(revealEntries);
		}
		//override functions
		
		override public function gotCustomInfo(infoEntries:Array):void
		{
				
		}
		override public function gotMyUserId(myUserId:int):void
		{
			this.myUserId = myUserId;
		}
		override public function gotUserInfo(userId:int, entries:Array/*InfoEntry*/):void 
		{
			users.push({userId:userId,entries:entries});
		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, extraMatchInfo:Object, matchStartedTime:int, serverEntries:Array):void
		{
			domino_Logic.newGame(allPlayerIds,myUserId);
			players=allPlayerIds;
			gameEnded = false;
			currentTurn = 0;	
			if(serverEntries.length == 0)
			{
				doAllStoreState(domino_Logic.getCubesArray(cubeMaxValue));
				doAllShuffleState(domino_Logic.getDominoKeysArray());
				doAllRevealState(domino_Logic.getFirstDevision());
			}
			else
			{
				var middleDomino:String = "domino_"+((allPlayerIds.length + finishedPlayerIds.length)*7+1);
				var playerMoves:Array = new Array();
				for each(var serverEntry:ServerEntry in serverEntries)
				{
					if(serverEntry.key ==middleDomino)
						domino_Logic.addDominoMiddle(serverEntry.value as DominoCube,serverEntry.key);
					else if(serverEntry.value is DominoCube)
						domino_Logic.addDominoCube(serverEntry.value as DominoCube,serverEntry.key)						
					else
						playerMoves.push(serverEntry);
				}
				domino_Logic.loadBoard();
				for each(serverEntry in playerMoves)
				{
					if(serverEntry.value is PlayerMove)
					{
					
						var playerMove:PlayerMove = serverEntry.value as PlayerMove;
						domino_Logic.loadPlayerDominoCube(playerMove,playerMove.playerId);
						currentTurn++;					
					}
					else if(serverEntry.value is NoMoves)
					{
						var noMoves:NoMoves = serverEntry.value as NoMoves;
						domino_Logic.addLodedDominoKey(noMoves.userId)
						currentTurn++;
					}

				}
				currentTurn--;
				if(players.indexOf(myUserId) != -1)
				{	
					setNextTurn();
					if(myUserId == getTurnOf())
					{
						domino_Logic.allowTurn();
					}
				}
				
			}
		}
		override public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void 
		{
			domino_Logic.playing =false;
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			var serverEntry:ServerEntry = serverEntries[0]
			if(gameEnded)
			{
				if(serverEntry.value is DominoCube)
				{
					if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,"user stored on entries he shouldn't touch");
					var finishedPlayers:Array = domino_Logic.calculateHands(serverEntries);
					doAllEndMatch(finishedPlayers);
				}
				return;
			}
			
			if(serverEntries.length == (players.length * 7 +1))
			{
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+"tried to fake a board");
				for each(serverEntry in serverEntries)
				{
					if (serverEntry.value is DominoCube)
					{
						if(serverEntry.visibleToUserIds != null)
							domino_Logic.addDominoCube(serverEntry.value as DominoCube,serverEntry.key);
						else
							domino_Logic.addDominoMiddle(serverEntry.value as DominoCube,serverEntry.key);
					}
				}
				domino_Logic.makeBoard();
				doAllSetTurn(getTurnOf(),-1);
				if(myUserId == getTurnOf())
				{
					domino_Logic.allowTurn();
				}
			}
			else if(serverEntry.value is PlayerMove)
			{
				if(serverEntry.storedByUserId == myUserId) return;
				if (serverEntry.storedByUserId != getTurnOf()) doAllFoundHacker(serverEntry.storedByUserId,"the user tried to play in someone elses turn");
				var playerMove:PlayerMove = serverEntry.value as PlayerMove;
				domino_Logic.addPlayerDominoCube(playerMove,getTurnOf());
				//todo: test if domino is correct
				if(myUserId == getTurnOf())
				{
					domino_Logic.allowTurn();
				}
			}
			else if(serverEntry.value is NoMoves)
			{
				if(serverEntry.storedByUserId == myUserId) return;
				var noMoves:NoMoves = serverEntry.value as NoMoves;
				var userEntry:RevealEntry = domino_Logic.nextDomino(noMoves.userId);
				if(userEntry != null)
					doAllRevealState([userEntry]);
				setNextTurn();
				if(myUserId == getTurnOf())
				{
					domino_Logic.allowTurn();
				}
			}
			else if(serverEntries.length == 1)
			{
				if(serverEntry.value is DominoCube)
					domino_Logic.drawCube(serverEntry.value as DominoCube,serverEntry.key);
			}
				
		}
		override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void
		{
			
		}
	}
}