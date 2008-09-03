package come2play_as3.domino
{
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.RevealEntry;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Domino_Logic
	{
		private var domino_MainPointer:Domino_Main;
		private var domino_Graphic:Domino_Graphic;
		
		
		//graphic related
		private var leftArrow:LeftArrow;
		private var rightArrow:RightArrow;
		private var noMovesBox:NoMovesBox;
		private var graphics:MovieClip;
		
		private var dominoAmount:int;// how many dominoes are avaible in the game
		private var currentDomino:int;//how many dominoes have been drawn already
		private var dominoes:Array/*DominoObject*/; //my dominoes
		
		//game detailes
		private var players:Array/*int*/;
		private var myUserId:int;
		private var movesWithNoAction:int;
		private var dominoBoard:DominoBoard/*DominoObject*/ // dominoes on board
		private var isMyTurn:Boolean; // is my turn
		private var currentDominoMove:DominoObject; //domino choosen to put on board
		private var choosingSide:Boolean; //am I currently choosing a side for the domino
		private var rivalPlayersDominoKeys:Array/*Array*/
		public var playing:Boolean;
		
		private var avaibleDominoMoves:Array; //aviable dominoes to put on board
		
		
		public function Domino_Logic(domino_MainPointer:Domino_Main,graphics:MovieClip)
		{
			this.graphics = graphics;
			this.domino_MainPointer = domino_MainPointer;
			playing = false;
			rightArrow = new RightArrow();
			leftArrow = new LeftArrow();
			noMovesBox = new NoMovesBox();
			noMovesBox.x = 100;
			noMovesBox.y = 100;
			noMovesBox.confirm_btn.addEventListener(MouseEvent.CLICK,noMovesConfirmed);
			rightArrow.addEventListener(MouseEvent.CLICK,doRight);
			leftArrow.addEventListener(MouseEvent.CLICK,doLeft);
		}
		
		public function newGame(players:Array,myUserId:int):void
		{
			this.players = players;
			this.myUserId = myUserId
			dominoes = new Array();
			dominoBoard = new DominoBoard();
			rivalPlayersDominoKeys = new Array();
			for(var i:int;i<players.length;i++)
				rivalPlayersDominoKeys[i] = new Array();
			
		}
		public function takeDomino(dominoNum:int):void
		{
			if(isMyTurn)
			{
				if(avaibleDominoMoves.indexOf(dominoNum)==-1)
					return;
				removeArrows()				
				currentDominoMove = dominoes[dominoNum];
				if((dominoBoard.right == currentDominoMove.upperNum) || (dominoBoard.right == currentDominoMove.lowerNum))
				{
					rightArrow.x = 35+ dominoNum*30
					rightArrow.y = 240
					graphics.addChild(rightArrow);
				}
				if((dominoBoard.left == currentDominoMove.upperNum) || (dominoBoard.left == currentDominoMove.lowerNum))
				{
					leftArrow.x = dominoNum*30
					leftArrow.y = 240
					graphics.addChild(leftArrow);
				}
			}
		}
		private function removeArrows():void
		{
			if(graphics.contains(rightArrow))
				graphics.removeChild(rightArrow);
			if(graphics.contains(leftArrow))
				graphics.removeChild(leftArrow);
		}
		public function checkWin(remainingCubes:int,playerId:int):void
		{
			if(remainingCubes == 0)
			{
				domino_MainPointer.setNextTurn();
				playerWon(playerId);
			}
			else
			{
				domino_MainPointer.setNextTurn();
			}
		}
		
		private function makeMove(isRight:Boolean):void
		{
			var playerMove:PlayerMove = PlayerMove.create(currentDominoMove.key,isRight,currentDominoMove.dominoCube,myUserId);
			removeArrows();
			if(isRight)
				dominoBoard.addToRight(currentDominoMove.dominoCube);
			else
				dominoBoard.addToLeft(currentDominoMove.dominoCube);	
			for(var i:int = 0;i<dominoes.length;i++)
			{
				var tempDominoObject:DominoObject = dominoes[i];
				if((currentDominoMove.lowerNum == tempDominoObject.lowerNum)&&(currentDominoMove.upperNum == tempDominoObject.upperNum))
				{
					dominoes.splice(i,1);
					domino_Graphic.addDominoCubeToBoard(i,isRight);
				}
			}
			isMyTurn = false;
			domino_MainPointer.sendPlayerMove(playerMove);
			checkWin(dominoes.length,myUserId);
			
		}
		public function loadBoard():void
		{
			for(var i:int=0;i<players.length;i++)
			{
					var tempRivalPlayersDominoKeys:Array = new Array();
					for(var j:int=0;j<7;j++)
						tempRivalPlayersDominoKeys.push("domino_"+(i*7+j+1));
					rivalPlayersDominoKeys[i] = tempRivalPlayersDominoKeys;
			}	
			currentDomino = players.length * 7 + 2;
			makeBoard();
		}				
		public function addLodedDominoKey(playerId:int):void
		{
			var tempRivalPlayersDominoKeys:Array = rivalPlayersDominoKeys[players.indexOf(playerId)];
			trace(playerId+"/"+players.indexOf(playerId)+"******************"+currentDomino)
			tempRivalPlayersDominoKeys.push("domino_"+currentDomino);
			currentDomino++;
		}
		
		public function loadPlayerDominoCube(playerMove:PlayerMove,playerId:int):void
		{
			if(playerId != myUserId)
			{
				var tempRivalPlayersDominoKeys:Array = rivalPlayersDominoKeys[players.indexOf(playerId)]
				var keyPosition:int =tempRivalPlayersDominoKeys.indexOf(playerMove.key)
				tempRivalPlayersDominoKeys.splice(tempRivalPlayersDominoKeys.indexOf(playerMove.key),1);	
				var rivalCubes:int = domino_Graphic.addPlayerDominoCube(playerMove,playerId);
				if(playerMove.isRight)
					dominoBoard.addToRight(playerMove.dominoCube);
				else
					dominoBoard.addToLeft(playerMove.dominoCube);
			}
			else
			{
				if(playerMove.isRight)
					dominoBoard.addToRight(playerMove.dominoCube);
				else
					dominoBoard.addToLeft(playerMove.dominoCube);
						
				for(var i:int = 0;i<dominoes.length;i++)
				{
					var tempDominoObject:DominoObject = dominoes[i];
					if((playerMove.dominoCube.lowerNum == tempDominoObject.lowerNum)&&(playerMove.dominoCube.upperNum == tempDominoObject.upperNum))
					{
						dominoes.splice(i,1);
						domino_Graphic.addDominoCubeToBoard(i,playerMove.isRight);
					}
				}
			}
		}
		public function addPlayerDominoCube(playerMove:PlayerMove,playerId:int):void
		{
			var tempRivalPlayersDominoKeys:Array = rivalPlayersDominoKeys[players.indexOf(playerId)]
			var keyPosition:int =tempRivalPlayersDominoKeys.indexOf(playerMove.key)
			trace("*********"+playerMove.key)
			if(keyPosition != -1)	
				tempRivalPlayersDominoKeys.splice(tempRivalPlayersDominoKeys.indexOf(playerMove.key),1);
			else
				domino_MainPointer.foundHacker(playerId);		
			var rivalCubes:int = domino_Graphic.addPlayerDominoCube(playerMove,playerId);
			if(playerMove.isRight)
				dominoBoard.addToRight(playerMove.dominoCube);
			else
				dominoBoard.addToLeft(playerMove.dominoCube);
			checkWin(rivalCubes,playerId);
		}
		public function playerWon(winingUserId:int):void
		{
			var playerPos:int=players.indexOf(winingUserId);
			var playerMatchOverArr:Array = new Array();
			if(players.length > 2)
			{	
				playerMatchOverArr.push(PlayerMatchOver.create(winingUserId,players.length*10,70));
				players.splice(playerPos,1);
				rivalPlayersDominoKeys.splice(playerPos,1);
			}
			else
			{
				playerMatchOverArr.push(PlayerMatchOver.create(winingUserId,players.length*10,100));
				players.splice(playerPos,1);
				rivalPlayersDominoKeys.splice(playerPos,1);
				playerMatchOverArr.push(PlayerMatchOver.create(players[0],0,0));
				domino_MainPointer.gameEnded = true;
			}
			domino_MainPointer.refreshTurn(playerPos);
			domino_MainPointer.endGame(playerMatchOverArr);
		}
		private function noMovesConfirmed(ev:MouseEvent):void
		{
			graphics.removeChild(noMovesBox);
			domino_MainPointer.noMoves();
		}
		private function doLeft(ev:MouseEvent):void
		{
			makeMove(false);	
		}
		private function doRight(ev:MouseEvent):void
		{
			makeMove(true);
		}
		private function findAvaibleMoves(rightSide:int,leftSide:int):Array/*int*/
		{
			var i:int;
			var avaibleMoves:Array = new Array();
			var dominoObject:DominoObject;
			if(rightSide != leftSide)
			{
				for(i = 0 ;i < dominoes.length;i++)
				{
					dominoObject = dominoes[i];
					if ((dominoObject.lowerNum == rightSide) || (dominoObject.upperNum == rightSide) || (dominoObject.lowerNum == leftSide) || (dominoObject.upperNum == leftSide))
					{
						if(avaibleMoves.indexOf(i)== -1 )
							avaibleMoves.push(i);
					}
				}
			}
			else
			{
				for(i = 0 ;i < dominoes.length;i++)
				{
					dominoObject = dominoes[i];
					if ((dominoObject.lowerNum == rightSide) || (dominoObject.upperNum == rightSide))
					{
						if(avaibleMoves.indexOf(i)== -1 )
							avaibleMoves.push(i);
					}
				}
			}
			return avaibleMoves;
		}
		
		public function allowTurn():void
		{
			isMyTurn = true;
			avaibleDominoMoves = findAvaibleMoves(dominoBoard.right,dominoBoard.left);
			if(avaibleDominoMoves.length == 0)
				graphics.addChild(noMovesBox);
			else
			{
				movesWithNoAction = 0;
				domino_Graphic.markCubes(avaibleDominoMoves);
			}
		}
		public function nextDomino(revealToUser:int):RevealEntry
		{
			if(dominoAmount > currentDomino)
			{
				movesWithNoAction = 0;
				var tempRivalPlayersDominoKeys:Array = rivalPlayersDominoKeys[players.indexOf(revealToUser)];
				
				if(revealToUser !=myUserId)
				{
					domino_Graphic.addDominoToRivalDeck(revealToUser);
					tempRivalPlayersDominoKeys.push("domino_"+currentDomino);
				}
				domino_Graphic.updateDeck(dominoAmount-(currentDomino+1));
				return RevealEntry.create("domino_"+(currentDomino++),[revealToUser],0);
			}
			else
			{
				movesWithNoAction ++;
				if(players.length == movesWithNoAction)
					endMatchTie();
				return null;
			}

		}
		public function endMatchTie():void
		{
			var revealEntries:Array = new Array();
			for each(var keyArray:Array in rivalPlayersDominoKeys)
				for each(var key:String in keyArray)
					revealEntries.push(RevealEntry.create(key,null,0));
			domino_MainPointer.revealHands(revealEntries);
		}
		public function calculateHands(serverEntries:Array/*ServerEntry*/):Array/*PlayerMatchOver*/
		{
			var playerBadScore:Array = new Array/*int*/
			for(var i:int = 0; i<players.length;i++)
			{
				playerBadScore[i] = {score:0,id:i};
			}
			for each(var serverEntry:ServerEntry in serverEntries)
			{
				var tempCube:DominoCube = serverEntry.value as DominoCube;
				var tempRivalPlayersDominoKeys:Array;
				for(i = 0; i<playerBadScore.length;i++)
				{
					tempRivalPlayersDominoKeys =rivalPlayersDominoKeys[i]
					if (tempRivalPlayersDominoKeys.indexOf(serverEntry.key)!= -1)
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
				finishedPlayers.push(PlayerMatchOver.create(players[playerBadScore[0].id],10,100));
				finishedPlayers.push(PlayerMatchOver.create(players[playerBadScore[1].id],0,0));		
			}
			else if(playerBadScore.length == 3)
			{
				finishedPlayers.push(PlayerMatchOver.create(players[playerBadScore[0].id],20,70));
				finishedPlayers.push(PlayerMatchOver.create(players[playerBadScore[1].id],10,30));
				finishedPlayers.push(PlayerMatchOver.create(players[playerBadScore[2].id],0,0));
			}
			else if(playerBadScore.length == 4)
			{
				finishedPlayers.push(PlayerMatchOver.create(players[playerBadScore[0].id],30,60));
				finishedPlayers.push(PlayerMatchOver.create(players[playerBadScore[1].id],20,30));
				finishedPlayers.push(PlayerMatchOver.create(players[playerBadScore[2].id],10,10));
				finishedPlayers.push(PlayerMatchOver.create(players[playerBadScore[3].id],0,0));
			}
			return finishedPlayers;
		}
		
		public function getCubesArray(cubeMaxValue:int):Array/*UserEntry*/
		{
			var userEntries:Array/*UserEntry*/ = new Array();
			var count:int=1;
			for(var i:int=0;i<=cubeMaxValue;i++)
				for(var j:int=i;j<=cubeMaxValue;j++)
					userEntries.push(UserEntry.create("domino_"+(count++),DominoCube.create(i,j),false));
			dominoAmount = count;
			return userEntries;
		}
		public function getDominoKeysArray():Array/*String*/
		{
			var keyArray:Array = new Array();
			for(var i:int=1;i<dominoAmount;i++)
				keyArray.push("domino_"+i);
			return keyArray;
		}
		public function getFirstDevision():Array /*RevealEntry*/
		{
			var revealEntries:Array/*RevealEntry*/ = new Array();
			for(var i:int=0;i<players.length;i++)
			{
				var tempRivalPlayersDominoKeys:Array = new Array();
				for(var j:int=0;j<7;j++)
				{
					tempRivalPlayersDominoKeys.push("domino_"+(i*7+j+1));
					revealEntries.push(RevealEntry.create("domino_"+(i*7+j+1),[players[i]],0));
				}
				rivalPlayersDominoKeys[i] = tempRivalPlayersDominoKeys;
			}
			revealEntries.push(RevealEntry.create("domino_"+(i*7+1),null,0));
			currentDomino =i*7+2;
			return revealEntries;
		}
		
		public function addDominoCube(newDominoCube:DominoCube,key:String):void
		{
			dominoes.push(new DominoObject(newDominoCube,key));
		}
		public function drawCube(newDominoCube:DominoCube,key:String):void
		{
			dominoes.push(new DominoObject(newDominoCube,key));
			domino_Graphic.addCubeToYourDeckdrawCube(newDominoCube);
		}
		public function addDominoMiddle(newDominoCube:DominoCube,key:String):void
		{
			dominoBoard.addToMiddle(new DominoObject(newDominoCube,key));
		}
		public function makeBoard():void
		{
			if(!playing)
			{
				playing =true;
				if(domino_Graphic != null)
					graphics.removeChild(domino_Graphic);
				movesWithNoAction = 0;
				domino_Graphic = new Domino_Graphic(dominoes,dominoBoard.middle(),players,myUserId,this);
				domino_Graphic.updateDeck(dominoAmount-currentDomino);
				graphics.addChild(domino_Graphic);
			}

		}
	}
	
}
	import come2play_as3.domino.DominoObject;
	import come2play_as3.domino.DominoCube;
	

class DominoBoard
{
	private var leftValue:int;
	private var rightValue:int
	private var middleDominoObject:DominoObject;
	public function addToMiddle(dominoObject:DominoObject):void{
		rightValue = dominoObject.right;
		leftValue = dominoObject.left;
		middleDominoObject = dominoObject;
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
	public function middle():DominoObject{return middleDominoObject;}
}