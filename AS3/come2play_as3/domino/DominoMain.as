package come2play_as3.domino
{
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.MovieClip;
	
	public class DominoMain extends ClientGameAPI
	{
		private var cubeMaxValue:int = 7;
		private var stageX:int;
		private var stageY:int;
		private var graphics:MovieClip;
		
		private var tieGame:int;
		private var gameOver:Boolean;
		public var currentTurn:int;
		private var moveNum:int;
		private var dominoLogic:DominoLogic;
		private var myUserId:int; //my user id
		private var allPlayerIds:Array; //playing user ids
	/** 
	 * Written by: Ofir Vainshtein (ofirvins@yahoo.com)
 	**/
		public function DominoMain(graphics:MovieClip)
		{ 

			this.graphics = graphics;
			super(graphics); 
			AS3_vs_AS2.waitForStage(graphics,constructGame);
		}
		private function constructGame():void
		{
				dominoLogic  = new DominoLogic(this,graphics);
				doRegisterOnServer();
		}
		
		public function sendPlayerMove(playerMove:PlayerMove):void
		{
			if(!gameOver)
			{
				doStoreState([UserEntry.create({playerId:myUserId,move:moveNum},playerMove,false)])
				moveNum++;
			}
		}
		public function endGame(playerMatchOverArr:Array):void
		{
			gameOver = true;
			doAllEndMatch(playerMatchOverArr);
		}
		public function setPlayerTurn(playerId:int):void
		{
			if(!gameOver)
			{
				var changeToCurrentTurn:int =  allPlayerIds.indexOf(playerId);
				if(currentTurn != changeToCurrentTurn)
				{
					currentTurn = allPlayerIds.indexOf(playerId);
					if(currentTurn == -1)
					{
						currentTurn = 0
						playerId = allPlayerIds[0];
					}
					
					doAllSetTurn(playerId,-1);
					if(myUserId == playerId)
						dominoLogic.allowTurn();
					
				}
			}
		}
		public function setNextTurn():void
		{
			currentTurn ++ ;
			if (allPlayerIds.length == currentTurn )
				currentTurn = 0;
			doAllSetTurn(allPlayerIds[currentTurn],-1);
			doAllStoreState([UserEntry.create("turnOfPlayerId",PlayerTurn.create(allPlayerIds[currentTurn]),false)]);
			if(myUserId == allPlayerIds[currentTurn])
				dominoLogic.allowTurn();
		}
		public function revealNextMove(revealEntry:RevealEntry):void
		{
			doAllRevealState([revealEntry]);
		}
		//todo: see if used
		public function foundHacker(playerId:int,key:String):void
		{
			doAllFoundHacker(playerId,"player does not have this key :"+key);	
		}
		public function revealHands(revealEntries:Array/*RevealEntry*/):void
		{
			tieGame = revealEntries.length;
			doAllRevealState(revealEntries);
		}
		public function myTracer(text:String):void
		{
			doTrace("MyUser :"+myUserId,text);
		}
		//override functions
		
		override public function gotCustomInfo(infoEntries:Array):void
		{
			for each (var infoEntry:InfoEntry in infoEntries)
			{
				switch(infoEntry.key)
				{
					case "CONTAINER_gameStageX" : stageX = int(infoEntry.value);break;
					case "CONTAINER_gameStageY" : stageY = int(infoEntry.value); break;
					case "cubeMaxValue" : cubeMaxValue =int(infoEntry.value); break;
				}
			}
		}
		override public function gotMyUserId(myUserId:int):void
		{
			this.myUserId = myUserId;
		}
		override public function gotUserInfo(userId:int, entries:Array/*InfoEntry*/):void 
		{
			
		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			this.allPlayerIds=allPlayerIds;
			dominoLogic.newGame(allPlayerIds,myUserId,cubeMaxValue,stageX,stageY);
			dominoLogic.makeBoard();
			currentTurn = -1;
			moveNum = 0;	
			tieGame = 0;
			gameOver = false;
			if(serverEntries.length == 0)
			{
				doAllStoreState(dominoLogic.getCubesArray());
				doAllShuffleState(dominoLogic.getDominoKeysArray());
				doAllRevealState(dominoLogic.getFirstDevision());
			}
			else
			{
				var playerTurn:PlayerTurn;
				for each (var serverEntry:ServerEntry in serverEntries)
				{
					if(serverEntry.value is PlayerMove)
						dominoLogic.makeMove(serverEntry.value as PlayerMove);
					else if(serverEntry.value is PlayerTurn)
						playerTurn = serverEntry.value as PlayerTurn
					else if(serverEntry.value is DominoCube)
					{
						if(serverEntry.visibleToUserIds == null)
						{
							if(serverEntry.key.num == 1)
								dominoLogic.addMiddle(serverEntry.value as DominoCube);
						}
						else if (serverEntry.visibleToUserIds.length == 1)
						{
							dominoLogic.drawCube(serverEntry.value as DominoCube,myUserId,serverEntry.key.num);
						}
					}
					else if(serverEntry.visibleToUserIds.length == 1)
					{
						dominoLogic.drawCube(serverEntry.value as DominoCube,serverEntry.visibleToUserIds[0],serverEntry.key.num);
					}
				}
				setPlayerTurn(playerTurn.playerId)
			}
			//todo : make load

		}
		override public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void 
		{
			
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			
			//setNextTurn();	
			if(gameOver) return;
			var serverEntry:ServerEntry = serverEntries[0]
			if(tieGame > 0)
			{
				serverEntries.pop();
				doTrace("tieGame",serverEntries.length +"!="+ tieGame);
				if(serverEntries.length != tieGame) return;
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,"tried to resave hands");
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,"user stored on entries he shouldn't touch");
				var finishedPlayers:Array = dominoLogic.calculateHands(serverEntries);
				doAllEndMatch(finishedPlayers);
			}
			else if(serverEntries.length == ((cubeMaxValue+1)*(cubeMaxValue+2)/2 ))
			{
				for each (serverEntry in serverEntries)
				{
					if (serverEntry.visibleToUserIds == null)
						dominoLogic.addMiddle(serverEntry.value as DominoCube)
					else if(serverEntry.visibleToUserIds.length > 0)
						dominoLogic.drawCube(serverEntry.value as DominoCube,serverEntry.visibleToUserIds[0],serverEntry.key.num);
				}
				setNextTurn();
			}
			else if(serverEntry.value is PlayerMove)
			{
				var playerMove:PlayerMove = serverEntry.value as PlayerMove;
				if(playerMove.playerId != serverEntry.storedByUserId) doAllFoundHacker(serverEntry.storedByUserId,"player tried to fake other user move");
				dominoLogic.makeMove(serverEntry.value as PlayerMove);
				setNextTurn();
			}
			else if(serverEntry.value is PlayerTurn)
			{
				var playerTurn:PlayerTurn = serverEntry.value as PlayerTurn;
				setPlayerTurn(playerTurn.playerId);
			}
			else if(serverEntry.key.type == "domino")
			{
				dominoLogic.drawCube(serverEntry.value as DominoCube,serverEntry.visibleToUserIds[0],serverEntry.key.num);
			}
			else
			{
				doAllFoundHacker(serverEntry.storedByUserId,"player "+serverEntry.storedByUserId+"stored an unexpected message"+JSON.stringify(serverEntry.value));
			}
		}
		override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void
		{
			
		}
	}
}