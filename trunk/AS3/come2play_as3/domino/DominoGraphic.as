package come2play_as3.domino
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class DominoGraphic extends MovieClip
	{
		private var dominoes:Array;/*DominoObject*/
		private var yourDominoes:Array;/*Domino*/
		private var dominoLogicPointer:DominoLogic;
		private var allPlayerIds:Array;
		private var rivalBoards:Array/*RivalPlayerBoard*/
		private var myUserId:int;
		private var gameBoard:GameBoard;// gameBoard
		private var dominoLeft:TextField; //text field with dominoes left
		
		private var stageX:int;
		private var stageY:int;
		public function DominoGraphic(allPlayerIds:Array,myUserId:int,stageX:int,stageY:int,dominoLogicPointer:DominoLogic)
		{
			this.dominoLogicPointer = dominoLogicPointer;
			this.allPlayerIds = allPlayerIds;
			this.myUserId = myUserId;
			this.stageX = stageX + 5;
			this.stageY = stageY;
			dominoLeft = new TextField();
			dominoLeft.x= 60;
			dominoLeft.y=220;
			dominoLeft.selectable = false;
			addChild(dominoLeft);
			gameBoard = new GameBoard();
			addChild(gameBoard);
			if(allPlayerIds.indexOf(myUserId)==-1)
				arrangeBoard(false);
			else
			{
				yourDominoes = new Array();
				addEventListener(MouseEvent.CLICK,chooseDomino);
				arrangeBoard(true);
			}
			
		}
		
		public function updateDeck(num:int):void
		{
			dominoLeft.text = "Deck : "+num;
		}
		
		private function chooseDomino(ev:MouseEvent):void
		{
			if(((ev.stageY-stageY)>240)&&((ev.stageY-stageY)<300))
			{
				var pos:int = Math.floor((ev.stageX-stageX)/30);
				dominoLogicPointer.takeDomino(pos);
			}
		}
		public function markCube(avaibleMove:int):void
		{
				var dominoToMark:Domino =yourDominoes[avaibleMove];
				dominoToMark.y -= 20;
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
		public function makeMove(playerMove:PlayerMove,splicePos:int):void
		{
			if(playerMove.playerId == myUserId)
			{
				if(splicePos != -1)
				{
					removeChild(yourDominoes[splicePos]);
					yourDominoes.splice(splicePos,1);
				}
				reDrawHand();
				//todo : remove domino from player
			}
			else
			{
				var playerRelativePos:int = allPlayerIds.indexOf(playerMove.playerId);
				var tempRivalBoard:RivalPlayerBoard = rivalBoards[playerRelativePos];
				tempRivalBoard.removeDomino();
			}
			gameBoard.addDomino(playerMove);
		}
		public function removePlayer(pos:int):void
		{
			rivalBoards.splice(pos,1)
		}
		public function getDeckSize(playerId:int):int
		{
			var playerRelativePos:int =allPlayerIds.indexOf(playerId);
			var tempRivalBoard:RivalPlayerBoard = rivalBoards[playerRelativePos];
			return tempRivalBoard.length;
		}
		public function addDominoToDeck(domino:DominoCube,playerId:int):void
		{
			if(playerId == myUserId)
			{
				var tempDomino:Domino = new Domino();
				tempDomino.lowerNum.gotoAndStop(domino.lowerNum + 1);
				tempDomino.upperNum.gotoAndStop(domino.upperNum + 1);
				addChild(tempDomino);
				yourDominoes.push(tempDomino);
				reDrawHand();
			}
			else
			{
				var playerRelativePos:int =allPlayerIds.indexOf(playerId);
				if((playerRelativePos!= -1) && (rivalBoards[playerRelativePos]!= null))//todo : check if needed
				{
					var tempRivalBoard:RivalPlayerBoard = rivalBoards[playerRelativePos];
					tempRivalBoard.addDomino();
				}
			}
		}
		public function addMiddleDominoToDeck(newDominoCube:DominoCube):void
		{
			gameBoard.addCenter(newDominoCube);
		}
		public function arrangeBoard(isPlayer:Boolean):void
		{
			rivalBoards = new Array;
			var playerRelativePos:int
			var i:int;
			if(isPlayer)
			{
				for(i= 0;i<allPlayerIds.length;i++)
				{
					if(allPlayerIds[i] != myUserId)
					{
						playerRelativePos =i-allPlayerIds.indexOf(myUserId);
						if(playerRelativePos<0) playerRelativePos+=allPlayerIds.length;
						rivalBoards[i] = new RivalPlayerBoard(playerRelativePos,allPlayerIds.length,isPlayer);
						addChild(rivalBoards[i]);
					}
	
				}	
			}
			else
			{
				for(i= 0;i<allPlayerIds.length;i++)
				{
						playerRelativePos =i;
						if(playerRelativePos<0) playerRelativePos+=allPlayerIds.length;
						rivalBoards[i] = new RivalPlayerBoard(playerRelativePos,allPlayerIds.length,isPlayer);
						addChild(rivalBoards[i]);			
				}	
			}
			
		}
		
		
	}
}

class GameBoard extends MovieClip
{
	private const MAXX:int = 280;
	private const MINX:int = 80;
	private var leftX:int;
	private var rightX:int;
	private var leftDominos:Array;/*Domino*/
	private var rightDominos:Array;/*Domino*/
	private var middleDomino:Domino;
	public function GameBoard()
	{
		leftDominos = new Array();
		rightDominos = new Array();

	}
	public function addDomino(playerMove:PlayerMove):void
	{	
		var tempDominoCube:DominoCube = playerMove.dominoCube;
		var tempDomino:Domino = new Domino();
		tempDomino.lowerNum.gotoAndStop(tempDominoCube.lowerNum +1);
		tempDomino.upperNum.gotoAndStop(tempDominoCube.upperNum +1);
		addChild(tempDomino);
		if(playerMove.sideToPutOn == PlayerMove.RIGHT)
			addDominoRight(tempDomino,playerMove.partConnecting);
		else if(playerMove.sideToPutOn == PlayerMove.LEFT)
			addDominoLeft(tempDomino,playerMove.partConnecting);
		
	}
	private function addDominoRight(domino:Domino,partConnecting:String):void
	{
		domino.y = 150;
		if(partConnecting == PlayerMove.MIDDLE)
		{	
			rightX +=10;
			removeCenter(PlayerMove.RIGHT);
			domino.x = rightX;
			rightX +=10;
		}
		else 
		{
			if(partConnecting == PlayerMove.UP)
				domino.rotation = -90;
			else if(partConnecting == PlayerMove.DOWN)
				domino.rotation = 90;
			rightX +=20;
			removeCenter(PlayerMove.RIGHT);
			domino.x = rightX;
			rightX +=20
		}

		rightDominos.push(domino);
	}
	private function addDominoLeft(domino:Domino,partConnecting:String):void
	{	
		domino.y = 150;
		if(partConnecting == PlayerMove.MIDDLE)
		{	
			rightX -=10;
			removeCenter(PlayerMove.LEFT);
			domino.x = leftX;
			domino.rotation = 90;
			rightX -=10;
		}
		else 
		{
			if(partConnecting == PlayerMove.UP)
				domino.rotation = 90;
			else if(partConnecting == PlayerMove.DOWN)
				domino.rotation = -90;
			leftX -=20;
			removeCenter(PlayerMove.LEFT);
			domino.x = leftX;
			leftX -=20
		}

		leftDominos.push(domino);		
	}
	public function addCenter(dominoCube:DominoCube):void
	{
		middleDomino = new Domino();
		middleDomino.lowerNum.gotoAndStop(dominoCube.lowerNum +1);
		middleDomino.upperNum.gotoAndStop(dominoCube.upperNum +1);
		middleDomino.y =150;
		middleDomino.x = 180;
		if(dominoCube.lowerNum != dominoCube.upperNum)
		{
			leftX = 160 ;
			rightX = 200;
			middleDomino.rotation = 90;
			
		}
		else
		{
			leftX = 170 ;
			rightX = 190;
			
		}
		
		addChild(middleDomino);
	}
	private function removeCenter(shiftFrom:String):void
	{
		var cahngeXBy:int;
		var tempDominoe:Domino
		var removedDomino:Domino;
		if(shiftFrom ==PlayerMove.RIGHT)
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
		else if(shiftFrom ==PlayerMove.LEFT)
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
import come2play_as3.domino.PlayerMove;
import come2play_as3.domino.DominoCube;
	

class RivalPlayerBoard extends MovieClip
{
	private var dominoes:Array/*DominoBack*/;
	private var playerNum:int;
	private var playerCount:int;
	private var isPlayer:Boolean;
	public function RivalPlayerBoard(playerNum:int,playerCount:int,isPlayer:Boolean)
	{
		this.isPlayer = isPlayer;
		this.playerNum = playerNum;
		this.playerCount = playerCount;
		dominoes = new Array();
		/*for(var i:int=0;i<7;i++)
 			addDomino();
 			*/
	}
	public function get length():int{return dominoes.length;}
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
		var i:int;
		var tempDominoBack:DominoBack;
		if((playerNum == 1) || isPlayer)
		{
			for(i=0;i<dominoes.length;i++)
			{
				tempDominoBack = dominoes[i]
				tempDominoBack.y=50;
				tempDominoBack.x =20 + i*25;
			}
		}
		else
		{
			for(i=0;i<dominoes.length;i++)
			{
				tempDominoBack = dominoes[i]
				tempDominoBack.y=280;
				tempDominoBack.x =20 + i*25;
			}
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
		if(playerNum == 0)
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