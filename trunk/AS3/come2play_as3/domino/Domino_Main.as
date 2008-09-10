package come2play_as3.domino
{
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class Domino_Main extends ClientGameAPI
	{
		private var cubeMaxValue:int = 7;
		private var graphics:MovieClip;
		
		public var currentTurn:int;
		
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

			this.graphics = graphics;
			super(graphics); 
			AS3_vs_AS2.waitForStage(graphics,constructGame);
		}
		private function constructGame():void
		{
				users = new Array(); 
				domino_Logic  = new Domino_Logic(this,graphics,cubeMaxValue);
				doRegisterOnServer();
		}
		
		
		private function getTurnOf():int
		{
			return players[currentTurn%players.length];	
		}
		public function doMyTrace(traceObj:Object):void
		{
			//doTrace("Player"+myUserId,traceObj);
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
		public function refreshTurn():void
		{
			
			var oldTurn:int = currentTurn % (players.length+1);
			if(oldTurn == (players.length))
				oldTurn=0;
				
			
			
			var newTurn:int = currentTurn % players.length;
			while(oldTurn!=newTurn)
			{
				currentTurn++;
				newTurn= currentTurn % players.length;
			}
			currentTurn--;
			doTrace("Player"+myUserId,"currentTurn : "+currentTurn);
		}
		public function setNextTurn():void
		{
			currentTurn++;
			doTrace("Turn",myUserId + " : "+players.length + "/" + currentTurn + "/" +players[currentTurn%players.length]);
			doAllSetTurn(getTurnOf(),-1);
			doAllStoreState([UserEntry.create("TurnOf",PlayerTurn.create(currentTurn),false)]);
		}
		public function noMoves():void
		{
			doStoreState([UserEntry.create("player_"+currentTurn,NoMoves.create(myUserId),false)]);
			var userEntry:RevealEntry = domino_Logic.nextDomino(myUserId);
			if(userEntry != null)
				doAllRevealState([userEntry]);
			setNextTurn();
			
		}
		public function foundHacker(playerId:int,key:String):void
		{
			if(players.indexOf(myUserId) != -1)
				doAllFoundHacker(playerId,"player does not have this key :"+key);	
		}
		public function revealHands(revealEntries:Array/*RevealEntry*/):void
		{
			gameEnded = true;
			doAllRevealState(revealEntries);
		}
		//override functions
		
		override public function gotCustomInfo(infoEntries:Array):void
		{
				trace("came in")
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
			players=allPlayerIds;
			domino_Logic.newGame(players,myUserId);
			gameEnded = false;
			currentTurn = 0;	
			if(serverEntries.length == 0)
			{
				doAllStoreState(domino_Logic.getCubesArray());
				doAllShuffleState(domino_Logic.getDominoKeysArray());
				doAllRevealState(domino_Logic.getFirstDevision());
			}
			else
			{
				currentTurn = domino_Logic.loadBoard(serverEntries);
				setNextTurn();
				if(myUserId == getTurnOf())
					domino_Logic.allowTurn();
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
				if ((serverEntry.storedByUserId != getTurnOf()) && (players.indexOf(myUserId) != -1)) doAllFoundHacker(serverEntry.storedByUserId,"the user tried to play in someone elses turn");
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