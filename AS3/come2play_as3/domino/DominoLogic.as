package come2play_as3.domino
{
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.RevealEntry;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class DominoLogic
	{
		private var dominoMainPointer:DominoMain;
		private var dominoGraphic:DominoGraphic;
		
		
		//graphic related
		private var leftArrow:LeftArrow;
		private var rightArrow:RightArrow;
		private var noMovesBox:NoMovesBox;
		private var graphics:MovieClip;
		private var stageX:int;
		private var stageY:int;
		private var dominoAmount:int;// how many dominoes are avaible in the game
		public var currentDomino:int;//how many dominoes have been drawn already
		
		
		//game detailes
		private var allPlayerIds:Array/*int*/;
		private var myUserId:int;
		private var cubeMaxValue:int;
		private var movesWithNoAction:int;
		private var dominoBoard:DominoBoard/*DominoObject*/ // dominoes on board
		private var rivalPlayersDominoKeys:Array/*Array*/
		
		private var avaibleDominoMoves:Array; //aviable dominoes to put on board
		private var playerDominoes:Array/*DominoCube*/; //my dominoes
		private var choosenMove:AvaibleMove;//avaible move choosen by the player
		
		public function DominoLogic(dominoMainPointer:DominoMain,graphics:MovieClip)
		{
			this.graphics = graphics;
			this.dominoMainPointer = dominoMainPointer;
			rightArrow = new RightArrow();
			leftArrow = new LeftArrow();
			noMovesBox = new NoMovesBox();
			noMovesBox.x = 100;
			noMovesBox.y = 100;
			noMovesBox.confirm_btn.addEventListener(MouseEvent.CLICK,noMovesConfirmed);
			rightArrow.addEventListener(MouseEvent.CLICK,doRight);
			leftArrow.addEventListener(MouseEvent.CLICK,doLeft);
		}
		
		public function newGame(allPlayerIds:Array,myUserId:int,cubeMaxValue:int,stageX:int,stageY:int):void
		{
			this.allPlayerIds = allPlayerIds;
			this.myUserId = myUserId
			this.cubeMaxValue = cubeMaxValue;
			this.stageX = stageX;
			this.stageY = stageY;
			currentDomino = 0;
			playerDominoes = new Array();
			dominoBoard = new DominoBoard();
			rivalPlayersDominoKeys = new Array();
			dominoAmount = (cubeMaxValue+1)*(cubeMaxValue+2)/2 +1;
			for(var i:int;i<allPlayerIds.length;i++)
				rivalPlayersDominoKeys[i] = new Array();
			
		}
		private function removeArrows():void
		{
			if(graphics.contains(rightArrow))
				graphics.removeChild(rightArrow);
			if(graphics.contains(leftArrow))
				graphics.removeChild(leftArrow);
			if(graphics.contains(noMovesBox))
				graphics.removeChild(noMovesBox);
			
		}
		private function noMovesConfirmed(ev:MouseEvent):void
		{
			graphics.removeChild(noMovesBox);
			dominoMainPointer.sendPlayerMove(PlayerMove.create("","",null,myUserId));
		}
		private function doLeft(ev:MouseEvent):void
		{
			sendMove(PlayerMove.LEFT);	
		}
		private function doRight(ev:MouseEvent):void
		{
			sendMove(PlayerMove.RIGHT);	
		}
		public function makeBoard():void
		{
			if(dominoGraphic != null)
				graphics.removeChild(dominoGraphic);
			movesWithNoAction = 0;
			dominoGraphic = new DominoGraphic(allPlayerIds,myUserId,stageX,stageY,this);
			graphics.addChild(dominoGraphic);
		}
		private function sendMove(sideToPutOn:String):void
		{
			var playerMove:PlayerMove;
			removeArrows();
			avaibleDominoMoves = new Array();
			dominoMainPointer.doTrace("choise",choosenMove.toString());
			if(choosenMove.dominoCube.upperNum == choosenMove.dominoCube.lowerNum)
			{
				dominoMainPointer.doTrace("made","Middle");
				playerMove = PlayerMove.create(sideToPutOn,PlayerMove.MIDDLE,choosenMove.dominoCube,myUserId);
			}
			else if (sideToPutOn == PlayerMove.LEFT)
			{
				if(dominoBoard.left == choosenMove.dominoCube.upperNum)
					playerMove = PlayerMove.create(sideToPutOn,PlayerMove.UP,choosenMove.dominoCube,myUserId);
				else
					playerMove = PlayerMove.create(sideToPutOn,PlayerMove.DOWN,choosenMove.dominoCube,myUserId);
				dominoMainPointer.doTrace("made","Left");
			}
			else if (sideToPutOn == PlayerMove.RIGHT)
			{
				if(dominoBoard.right == choosenMove.dominoCube.upperNum)
					playerMove = PlayerMove.create(sideToPutOn,PlayerMove.UP,choosenMove.dominoCube,myUserId);
				else
					playerMove = PlayerMove.create(sideToPutOn,PlayerMove.DOWN,choosenMove.dominoCube,myUserId);
				dominoMainPointer.doTrace("made","Right");
			}			

			dominoMainPointer.sendPlayerMove(playerMove);
		}
		
		
		public function takeDomino(dominoNum:int):void
		{
			if (avaibleDominoMoves.length == 0) return;
			var avaibleMove:AvaibleMove = avaibleDominoMoves[dominoNum];
			dominoMainPointer.doTrace("chack",avaibleMove.isLeft+"/"+avaibleMove.isRight);
			if((avaibleMove.isLeft == false )&& (avaibleMove.isRight==false))
				return;
			removeArrows();
			if(avaibleMove.isRight)
			{
				rightArrow.x = 35+ dominoNum*30
				rightArrow.y = 240
				graphics.addChild(rightArrow);
			}
			if(avaibleMove.isLeft)
			{
				leftArrow.x = dominoNum*30
				leftArrow.y = 240
				graphics.addChild(leftArrow);
			}
				choosenMove = avaibleMove;
		}

		public function checkWin(remainingCubes:int,playerId:int):void
		{
			dominoMainPointer.myTracer(myUserId+" says : "+playerId+"has "+remainingCubes+" cubes")
			if(remainingCubes == 0)
				playerWon(playerId);
		}
		
		public function makeMove(playerMove:PlayerMove):void
		{
			if(playerMove.dominoCube == null)
			{
				dominoMainPointer.doTrace("DrawCube","player : "+playerMove.playerId);
				if(dominoAmount > currentDomino)
				{
					movesWithNoAction = 0;
					dominoMainPointer.revealNextMove(RevealEntry.create({type:"domino",num:(currentDomino++)},[playerMove.playerId],0));
				}
				else
				{
					movesWithNoAction ++;
					if(allPlayerIds.length == movesWithNoAction)
						endMatchTie();
				}
				return;
			}
			var tempRivalKeysArray:Array = rivalPlayersDominoKeys[allPlayerIds.indexOf(playerMove.playerId)];
			if(tempRivalKeysArray.indexOf(playerMove.keyToVerefy) == -1 ) dominoMainPointer.doAllFoundHacker(playerMove.playerId,playerMove.playerId+" doesnt have this domino");	
			movesWithNoAction = 0;
			if (playerMove.sideToPutOn == PlayerMove.RIGHT)
				dominoBoard.addToRight(playerMove.dominoCube);			
			else if (playerMove.sideToPutOn == PlayerMove.LEFT)
				dominoBoard.addToLeft(playerMove.dominoCube);
			var splicePos:int;
			
			
			if(playerMove.playerId == myUserId)
			{
				removeArrows();
					for (var i:int = 0;i<playerDominoes.length;i++)
					{
						var dominoCube:PlayerDominoCube = playerDominoes[i];
						if ((dominoCube.upperNum == playerMove.dominoCube.upperNum) && (dominoCube.lowerNum == playerMove.dominoCube.lowerNum))
						{
							splicePos = i;
							break;
						}
					}
				if (splicePos != -1) 
					playerDominoes.splice(splicePos,1);
				dominoGraphic.makeMove(playerMove,splicePos);
				checkWin(playerDominoes.length,playerMove.playerId);
				return
			}
				
					
			dominoGraphic.makeMove(playerMove,splicePos);
			checkWin(dominoGraphic.getDeckSize(playerMove.playerId),playerMove.playerId);
		}
	
		public function playerWon(winingUserId:int):void
		{
			var playerPos:int=allPlayerIds.indexOf(winingUserId);
			var playerMatchOverArr:Array = new Array();
			
			
			playerMatchOverArr.push(PlayerMatchOver.create(winingUserId,allPlayerIds.length*10,70));
			dominoGraphic.removePlayer(playerPos);
			allPlayerIds.splice(playerPos,1);
			rivalPlayersDominoKeys.splice(playerPos,1);
			
			
			if(allPlayerIds.length < 2)
			{
				playerMatchOverArr.push(PlayerMatchOver.create(allPlayerIds[0],allPlayerIds.length*10,30));
				/*allPlayerIds.splice(0,1);
				rivalPlayersDominoKeys.splice(0,1);
				playerMatchOverArr.push(PlayerMatchOver.create(allPlayerIds[0],0,0));
				*/
			}
			
			dominoMainPointer.endGame(playerMatchOverArr);
		}

		private function findAvaibleMoves(rightSide:int,leftSide:int):void
		{
			
			var i:int;
			var dominoCube:PlayerDominoCube;
			avaibleDominoMoves = new Array();
			for(i = 0 ;i < playerDominoes.length;i++)
			{
				dominoCube = playerDominoes[i];
				avaibleDominoMoves.push(new AvaibleMove(i,dominoCube,((dominoCube.lowerNum == rightSide) || (dominoCube.upperNum == rightSide)),((dominoCube.lowerNum == leftSide) || (dominoCube.upperNum == leftSide))));
			}
		}
		
		public function allowTurn():void
		{
			findAvaibleMoves(dominoBoard.right,dominoBoard.left);
			var isMoveAvaible:Boolean = false;
			for each (var avaibleMove:AvaibleMove in avaibleDominoMoves)
			{
				if (avaibleMove.isLeft || avaibleMove.isRight)
				{
					isMoveAvaible = true;
					dominoGraphic.markCube(avaibleMove.partNum);
				}
			}
			
			if(!isMoveAvaible)
				graphics.addChild(noMovesBox);
			else
				movesWithNoAction = 0;
		}


		public function endMatchTie():void
		{
			var revealEntries:Array = new Array();
			for each(var keyNumArray:Array in rivalPlayersDominoKeys)
				for each(var keyNum:int in keyNumArray)
					revealEntries.push(RevealEntry.create({type:"domino",num:keyNum},null,0));
			dominoMainPointer.revealHands(revealEntries);
		}
		public function calculateHands(serverEntries:Array/*ServerEntry*/):Array/*PlayerMatchOver*/
		{
			var playerBadScore:Array = new Array/*int*/
			for(var i:int = 0; i<allPlayerIds.length;i++)
			{
				playerBadScore[i] = {score:0,id:allPlayerIds[i]};
			}
			for each(var serverEntry:ServerEntry in serverEntries)
			{
				var tempCube:DominoCube = serverEntry.value as DominoCube;
				var tempRivalPlayersDominoKeys:Array;
				for(i = 0; i<playerBadScore.length;i++)
				{
					tempRivalPlayersDominoKeys =rivalPlayersDominoKeys[i]
					if (tempRivalPlayersDominoKeys.indexOf(serverEntry.key.num)!= -1)
					{
						playerBadScore[i].score += tempCube.lowerNum +tempCube.upperNum;
					 	break;
					}
				}	
			}
			
			playerBadScore.sortOn("score", Array.NUMERIC | Array.DESCENDING);
			var finishedPlayers:Array/*PlayerMatchOver*/ = new Array();
			if(playerBadScore.length == 2)
			{
				finishedPlayers.push(PlayerMatchOver.create(playerBadScore[0].id,10,100));
				finishedPlayers.push(PlayerMatchOver.create(playerBadScore[1].id,0,0));		
			}
			else if(playerBadScore.length == 3)
			{
				finishedPlayers.push(PlayerMatchOver.create(playerBadScore[0].id,20,70));
				finishedPlayers.push(PlayerMatchOver.create(playerBadScore[1].id,10,30));
				finishedPlayers.push(PlayerMatchOver.create(playerBadScore[2].id,0,0));
			}
			else if(playerBadScore.length == 4)
			{
				finishedPlayers.push(PlayerMatchOver.create(playerBadScore[0].id,30,60));
				finishedPlayers.push(PlayerMatchOver.create(playerBadScore[1].id,20,30));
				finishedPlayers.push(PlayerMatchOver.create(playerBadScore[2].id,10,10));
				finishedPlayers.push(PlayerMatchOver.create(playerBadScore[3].id,0,0));
			}
			return finishedPlayers;
		}
		
		public function getCubesArray():Array/*UserEntry*/
		{
			var userEntries:Array/*UserEntry*/ = new Array();
			var count:int=1;
			for(var i:int=0;i<=cubeMaxValue;i++)
				for(var j:int=i;j<=cubeMaxValue;j++)
					userEntries.push(UserEntry.create({type:"domino",num:(count++)},DominoCube.create(i,j),false));
			return userEntries;
		}
		public function getDominoKeysArray():Array/*String*/
		{
			var keyArray:Array = new Array();
			for(var i:int=1;i<dominoAmount;i++)
				keyArray.push({type:"domino",num:i});
			return keyArray;
		}
		public function getFirstDevision():Array /*RevealEntry*/
		{
			var revealEntries:Array/*RevealEntry*/ = new Array();
			revealEntries.push(RevealEntry.create({type:"domino",num:1},null,0));
			for(var i:int=0;i<allPlayerIds.length;i++)
			{
				for(var j:int=0;j<7;j++)
					revealEntries.push(RevealEntry.create({type:"domino",num:(i*7+j+2)},[allPlayerIds[i]],0));
			}
			
			currentDomino =i*7+2;
			return revealEntries;
		}
		public function drawCube(newDominoCube:DominoCube,playerId:int,num:int):void
		{
			
			if(playerId == myUserId)
			{
				removeArrows();
				playerDominoes.push(new PlayerDominoCube(newDominoCube,num));
			}
			var tempRivalPlayersDominoKeys:Array = rivalPlayersDominoKeys[allPlayerIds.indexOf(playerId)];
			tempRivalPlayersDominoKeys.push(num);
			if(currentDomino <(num+1))
				currentDomino = (num+1);
			dominoGraphic.updateDeck(dominoAmount-currentDomino);
			dominoGraphic.addDominoToDeck(newDominoCube,playerId);
		}
		public function addMiddle(newDominoCube:DominoCube):void
		{
			dominoGraphic.addMiddleDominoToDeck(newDominoCube);
			dominoBoard.addToMiddle(newDominoCube);
		}	
	}
	
}



	import come2play_as3.domino.DominoCube;
	

class DominoBoard
{
	private var leftValue:int;
	private var rightValue:int
	private var middleDominoObject:DominoCube;
	public function addToMiddle(dominoCube:DominoCube):void{
		rightValue = dominoCube.right;
		leftValue = dominoCube.left;
		middleDominoObject = dominoCube;
	}
	public function addToLeft(dominoCube:DominoCube):void{
		if(leftValue == dominoCube.upperNum)
			leftValue = dominoCube.lowerNum;
		else
			leftValue = dominoCube.upperNum;
	}
	public function addToRight(dominoCube:DominoCube):void{
		if(rightValue == dominoCube.upperNum)
			rightValue = dominoCube.lowerNum;
		else
			rightValue = dominoCube.upperNum;
	}
	public function get left():int{return leftValue;}
	public function get right():int{return rightValue;}
	public function middle():DominoCube{return middleDominoObject;}
}