package come2play_as3.domino
{
	import come2play_as3.api.auto_generated.RevealEntry;
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
		private var graphics:MovieClip;
		
		private var dominoAmount:int;// how many dominoes are avaible in the game
		private var currentDomino:int;//how many dominoes have been drawn already
		private var dominoes:Array/*DominoObject*/; //my dominoes
		
		//game detailes
		private var players:Array/*int*/;
		private var myUserId:int;
		
		private var dominoBoard:DominoBoard/*DominoObject*/ // dominoes on board
		private var isMyTurn:Boolean; // is my turn
		private var currentDominoMove:DominoObject; //domino choosen to put on board
		private var choosingSide:Boolean; //am I currently choosing a side for the domino
		
		private var avaibleDominoMoves:Array; //aviable dominoes to put on board
		
		
		public function Domino_Logic(domino_MainPointer:Domino_Main,graphics:MovieClip)
		{
			this.graphics = graphics;
			this.domino_MainPointer = domino_MainPointer;
			rightArrow = new RightArrow();
			leftArrow = new LeftArrow();
			rightArrow.addEventListener(MouseEvent.CLICK,doRight);
			leftArrow.addEventListener(MouseEvent.CLICK,doLeft);
		}
		
		public function takeDomino(dominoNum:int):void
		{
			if(isMyTurn)
			{
				if(avaibleDominoMoves.indexOf(dominoNum)==-1)
					return;
				removeArrows()				
				currentDominoMove = dominoes[dominoNum];
				var rightDomino:DominoObject = dominoBoard.right();
				var leftDomino:DominoObject = dominoBoard.left();
				if((rightDomino.right == currentDominoMove.upperNum) || (rightDomino.right == currentDominoMove.lowerNum))
				{
					rightArrow.x = 35+ dominoNum*30
					rightArrow.y = 240
					graphics.addChild(rightArrow);
				}
				if((leftDomino.left == currentDominoMove.upperNum) || (leftDomino.left == currentDominoMove.lowerNum))
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
		private function makeMove(isRight:Boolean):void
		{
			var playerMove:PlayerMove = PlayerMove.create(currentDominoMove.key,isRight,currentDominoMove.dominoCube);
			removeArrows();
			if(isRight)
				dominoBoard.addToRight(currentDominoMove);
			else
				dominoBoard.addToLeft(currentDominoMove);	
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
			
		}
		public function addPlayerDominoCube(playerMove:PlayerMove,playerId:int):void
		{
			domino_Graphic.addPlayerDominoCube(playerMove,playerId);
		}
		private function doLeft(ev:MouseEvent):void
		{
			makeMove(false);	
		}
		private function doRight(ev:MouseEvent):void
		{
			makeMove(true);
		}
		private function findDominoes(rightSide:int,leftSide:int):Array/*int*/
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
			var rightDomino:DominoObject = dominoBoard.right();
			var leftDomino:DominoObject = dominoBoard.left();
			avaibleDominoMoves = findDominoes(rightDomino.right,leftDomino.left);
			domino_Graphic.markCubes(avaibleDominoMoves);
		}
		
		public function getCubesArray(cubeMaxValue:int):Array/*UserEntry*/
		{
			var userEntries:Array/*UserEntry*/ = new Array();
			var count:int=1;
			for(var i:int=0;i<=cubeMaxValue;i++)
				for(var j:int=i;j<=cubeMaxValue;j++)
					userEntries.push(UserEntry.create("domino_"+(count++),DominoCube.create(i,j),false));
			dominoes = new Array();
			dominoBoard = new DominoBoard;
			dominoAmount = count;
			currentDomino = 1;
			return userEntries;
		}
		public function getDominoKeysArray():Array/*String*/
		{
			var keyArray:Array = new Array();
			for(var i:int=1;i<dominoAmount;i++)
				keyArray.push("domino_"+i);
			return keyArray;
		}
		public function getFirstDevision(players:Array,myUserId:int):Array /*RevealEntry*/
		{
			this.players = players;
			this.myUserId = myUserId;
			var revealEntries:Array/*RevealEntry*/ = new Array();
			for(var i:int=0;i<players.length;i++)
				for(var j:int=0;j<7;j++)
					revealEntries.push(RevealEntry.create("domino_"+(i*7+j+1),[players[i]],1));
			revealEntries.push(RevealEntry.create("domino_"+(i*7+1),null,1));
			return revealEntries;
		}
		
		public function addDominoCube(newDominoCube:DominoCube,key:String):void
		{
			dominoes.push(new DominoObject(newDominoCube,key));
		}
		public function addDominoMiddle(newDominoCube:DominoCube,key:String):void
		{
			dominoBoard.addToMiddle(new DominoObject(newDominoCube,key));
		}
		public function makeBoard():void
		{
			if(domino_Graphic != null)
				graphics.removeChild(domino_Graphic);
			domino_Graphic = new Domino_Graphic(dominoes,dominoBoard.middle(),players,myUserId,this);
			graphics.addChild(domino_Graphic)
		}
	}
	
}
	import come2play_as3.domino.DominoObject;
	

class DominoBoard
{
	public var boardDominoes:Array = new Array/*DominoObject*/
	private var endPos:int;
	public function addToMiddle(dominoObject:DominoObject):void{
		boardDominoes.push(dominoObject);
		endPos = 0;
	}
	public function addToLeft(dominoObject:DominoObject):void{
		boardDominoes.unshift(dominoObject);
		endPos++;
	}
	public function addToRight(dominoObject:DominoObject):void{
		boardDominoes.push(dominoObject);
		endPos++;
	}
	public function left():DominoObject{return boardDominoes[0];}
	public function right():DominoObject{return boardDominoes[endPos];}
	public function middle():DominoObject{return boardDominoes[0];}
}