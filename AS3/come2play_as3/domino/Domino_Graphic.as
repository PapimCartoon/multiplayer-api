package come2play_as3.domino
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class Domino_Graphic extends MovieClip
	{
		private var dominoes:Array;/*DominoObject*/
		private var yourDominoes:Array;/*Domino*/
		private var domino_LogicPointer:Domino_Logic;
		private var players:Array;
		private var rivalBoards:Array/*RivalPlayerBoard*/
		private var myUserId:int;
		private var gameBoard:GameBoard;// gameBoard
		private var dominoLeft:TextField; //text field with dominoes left
		
		private var stageX:int;
		private var stageY:int;
		public function Domino_Graphic(dominoes:Array,dominoObject:DominoObject,players:Array,myUserId:int,stageX:int,stageY:int,domino_LogicPointer:Domino_Logic)
		{
			this.domino_LogicPointer = domino_LogicPointer;
			this.dominoes = dominoes;
			this.players = players;
			this.myUserId = myUserId;
			this.stageX = stageX + 5;
			this.stageY = stageY;
			dominoLeft = new TextField();
			dominoLeft.x= 60;
			dominoLeft.y=220;
			dominoLeft.selectable = false;
			addChild(dominoLeft);
			gameBoard = new GameBoard(dominoObject);
			addChild(gameBoard);
			if(players.indexOf(myUserId)!=-1)
			{
			yourDominoes = new Array();
			addEventListener(MouseEvent.CLICK,chooseDomino);
			arrangeBoard();	
			}
			else
			{
				arrangeBoardViewer();
			}
		}
		
		public function updateDeck(num:int):void
		{
			dominoLeft.text = "Deck : "+num;
		}
		
		public function chooseDomino(ev:MouseEvent):void
		{
			if(((ev.stageY-stageY)>240)&&((ev.stageY-stageY)<300))
			{
				var pos:int = Math.floor((ev.stageX-stageX)/30);
				domino_LogicPointer.takeDomino(pos);
			}
		}
		public function markCubes(avaibleMoves:Array/*int*/):void
		{
			for each(var move:int in avaibleMoves)
			{
				var dominoToMark:Domino =yourDominoes[move];
				dominoToMark.y-=20;
			}
		}
		public function reDrawHand():void
		{
			var tempDomino:Domino;
			for(var i:int=0;i<yourDominoes.length;i++)
			{
				tempDomino = yourDominoes[i];
				tempDomino.y=300;
				tempDomino.x =20 + i*30;
			}	
		}
		public function putCubeOnBoard(playerMove:PlayerMove,playerId:int):int/*Domino cubes left*/
		{
				var playerRelativePos:int =players.indexOf(playerId);
				var tempRivalBoard:RivalPlayerBoard = rivalBoards[playerRelativePos];
				tempRivalBoard.removeDomino();
				var tempDominoCube:DominoCube= playerMove.dominoCube;
				var tempDomino:Domino = new Domino();
				tempDomino.lowerNum.gotoAndStop(tempDominoCube.lowerNum +1);
				tempDomino.upperNum.gotoAndStop(tempDominoCube.upperNum +1);
				addChild(tempDomino);
				if(playerMove.isRight)
					gameBoard.addDominoRight(tempDomino);
				else
					gameBoard.addDominoLeft(tempDomino);
				var remainingDominoes:int = tempRivalBoard.dominoCount();
				return remainingDominoes;
		}
		public function removePlayer(pos:int):void
		{
			rivalBoards.splice(pos,1)
		}
		public function addDominoToRivalDeck(rivalPlayerId:int):void
		{
			
			var playerRelativePos:int =players.indexOf(rivalPlayerId);
			if((playerRelativePos!= -1) && (rivalBoards[playerRelativePos]!= null))
			{
				var tempRivalBoard:RivalPlayerBoard = rivalBoards[playerRelativePos];
				tempRivalBoard.addDomino();
			}
		}
		public function addDominoCubeToBoard(dominoPos:int,isRight:Boolean):void
		{
			var movingDomino:Domino = yourDominoes[dominoPos]
			yourDominoes.splice(dominoPos,1);
			
			if(isRight)
				gameBoard.addDominoRight(movingDomino);
			else
				gameBoard.addDominoLeft(movingDomino);
					
			reDrawHand();
		}
		public function addCubeToYourDeckdrawCube(newDominoCube:DominoCube):void
		{
				var tempDomino:Domino = new Domino;
				tempDomino.lowerNum.gotoAndStop(newDominoCube.lowerNum+1);
				tempDomino.upperNum.gotoAndStop(newDominoCube.upperNum+1);
				addChild(tempDomino)
				yourDominoes.push(tempDomino);
				reDrawHand();
		}
		public function arrangeBoardViewer():void
		{
			rivalBoards = new Array
			for(var i:int = 0;i<players.length;i++)
			{
				var playerRelativePos:int =i-players.indexOf(myUserId);
				if(playerRelativePos<0) playerRelativePos+=players.length;
				rivalBoards[i] = new RivalPlayerBoard(playerRelativePos,players.length);
				addChild(rivalBoards[i]);

			}
		}
		
		public function arrangeBoard():void
		{
			var tempDomino:Domino;
			var tempDominoObject:DominoObject;
			for(var i:int=0;i<dominoes.length;i++)
			{
				tempDominoObject = dominoes[i];
				addCubeToYourDeckdrawCube(tempDominoObject.dominoCube);
			}
			rivalBoards = new Array
			for(i = 0;i<players.length;i++)
			{
				if(players[i]!=myUserId)
				{
					var playerRelativePos:int =i-players.indexOf(myUserId);
					if(playerRelativePos<0) playerRelativePos+=players.length;
					rivalBoards[i] = new RivalPlayerBoard(playerRelativePos,players.length);
					addChild(rivalBoards[i]);

				}
			}
		}
	}
}

class GameBoard extends MovieClip
{
	private const MAXX:int = 300;
	private const MINX:int = 60;
	private var leftX:int;
	private var rightX:int;
	private var leftDominos:Array;/*Domino*/
	private var rightDominos:Array;/*Domino*/
	private var middleDomino:Domino;
	private var rightSideFrame:int;
	private var leftSideFrame:int;
	public function GameBoard(dominoObject:DominoObject)
	{
		leftDominos = new Array();
		rightDominos = new Array();
		middleDomino = new Domino();
		middleDomino.lowerNum.gotoAndStop(dominoObject.lowerNum + 1);
		middleDomino.upperNum.gotoAndStop(dominoObject.upperNum + 1);			
		middleDomino.x=180;
		middleDomino.y=150;
		leftSideFrame= dominoObject.lowerNum +1;
		rightSideFrame = dominoObject.upperNum +1;
		if(dominoObject.upperNum == dominoObject.lowerNum)
		{
			leftX = 170;
			rightX = 190;	
		}
		else
		{
			leftX = 160;
			rightX = 200;	
			middleDomino.rotation = 90
		}
		
		addChild(middleDomino);
		

	}
	public function addDominoRight(domino:Domino):void
	{
		domino.y = 150;
		if(domino.lowerNum.currentFrame == domino.upperNum.currentFrame)
		{	
			rightSideFrame = domino.lowerNum.currentFrame;
			rightX +=10;
			removeCenter("Right");
			domino.x = rightX;
			rightX +=10;
		}
		else
		{
			if(rightSideFrame == domino.upperNum.currentFrame)
			{
				domino.rotation = -90;
				rightSideFrame = domino.lowerNum.currentFrame;
			}
			else
			{
				domino.rotation = 90;
				rightSideFrame = domino.upperNum.currentFrame;
			}
			rightX +=20;
			removeCenter("Right");
			domino.x = rightX;
			rightX +=20
		}
		addChild(domino);
		rightDominos.push(domino);
	}
	public function addDominoLeft(domino:Domino):void
	{
		domino.y = 150;
		if(domino.lowerNum.currentFrame == domino.upperNum.currentFrame)
		{	
			leftSideFrame = domino.lowerNum.currentFrame;
			leftX -=10;
			removeCenter("Left");
			domino.x = leftX;
			leftX -=10;
		}
		else
		{
			if(leftSideFrame == domino.upperNum.currentFrame)
			{
				domino.rotation = 90;
				leftSideFrame = domino.lowerNum.currentFrame;
			}
			else
			{
				domino.rotation = -90;
				leftSideFrame = domino.upperNum.currentFrame;
			}
			leftX -=20;
			removeCenter("Left");
			domino.x = leftX;
			leftX -=20
		}
		addChild(domino);
		leftDominos.push(domino);
	}
	private function removeCenter(shiftFrom:String):void
	{
		var cahngeXBy:int;
		var tempDominoe:Domino
		var removedDomino:Domino;
		if(shiftFrom =="Right")
		{
			if(rightX>MAXX)
			{
				removedDomino = rightDominos.shift();
				removeChild(removedDomino);
				cahngeXBy = removedDomino.width;
				for each(tempDominoe in rightDominos)
					tempDominoe.x -=cahngeXBy;
				rightX -=cahngeXBy;
			}
			
		}
		else if(shiftFrom =="Left")
		{
			if(leftX<MINX)
			{
				removedDomino = leftDominos.shift();
				removeChild(removedDomino);
				cahngeXBy = removedDomino.width;
				for each(tempDominoe in leftDominos)
					tempDominoe.x +=cahngeXBy;
				leftX +=cahngeXBy;
			}	
		}
	}
	
}


import flash.display.MovieClip;
import come2play_as3.domino.DominoObject;
	

class RivalPlayerBoard extends MovieClip
{
	private var dominoes:Array/*DominoBack*/;
	private var playerNum:int;
	private var playerCount:int;
	public function RivalPlayerBoard(playerNum:int,playerCount:int)
	{
		this.playerNum = playerNum;
		this.playerCount = playerCount;
		dominoes = new Array();
		for(var i:int=0;i<7;i++)
 			addDomino();
	}
	public function dominoCount():int
	{
		return dominoes.length;
	}
	public function addDomino():void
	{
		var tempDominoBack:DominoBack= new DominoBack();
		dominoes.push(tempDominoBack);
		addChild(tempDominoBack);
		reDrawDominoes();
	}
	public function removeDomino():void
	{
		var tempDominoBack:DominoBack= dominoes.pop();
		removeChild(tempDominoBack);
		reDrawDominoes()
	}
	private function reDrawDominoes():void
	{
		if(playerCount == 2)
			drawTwoPlayerGame();
		else
			drawThreeOrMorePlayerGame();
	}
	private function drawTwoPlayerGame():void
	{
		for(var i:int=0;i<dominoes.length;i++)
		{
			var tempDominoBack:DominoBack = dominoes[i]
			tempDominoBack.y=50;
			tempDominoBack.x =20 + i*25;
		}
	}
	private function drawThreeOrMorePlayerGame():void
	{
		var i:int;
		var tempDominoBack:DominoBack;
		if(playerNum == 1)
		{
			for(i=0;i<dominoes.length;i++)
			{
				tempDominoBack = dominoes[i];
				tempDominoBack.rotation = 90;
				tempDominoBack.y=65 + i*23;
				tempDominoBack.x =360;
			}
		}
		if(playerNum == 2)
		{
			for(i=0;i<dominoes.length;i++)
			{
				tempDominoBack = dominoes[i]
				tempDominoBack.y=10;
				tempDominoBack.x =65 + i*23;
			}

		}
		if(playerNum == 3)
		{
			for(i=0;i<dominoes.length;i++)
			{
				tempDominoBack = dominoes[i];
				tempDominoBack.rotation = 90;
				tempDominoBack.y=10 + i*23;
				tempDominoBack.x =40;
			}
		}
		if(playerNum == 4)
		{
			for(i=0;i<dominoes.length;i++)
			{
				tempDominoBack = dominoes[i]
				tempDominoBack.y = 280;
				tempDominoBack.x = 65 + i*23;
			}

		}
	}
	
}