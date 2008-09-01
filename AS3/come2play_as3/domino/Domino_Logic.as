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
		private var leftArrow:LeftArrow;
		private var rightArrow:RightArrow;
		private var graphics:MovieClip;
		private var dominoAmount:int;
		private var currentDomino:int;
		private var dominoes:Array/*DominoObject*/;
		private var players:Array/*int*/;
		private var myUserId:int;
		private var boardDominoes:Array/*DominoObject*/
		private var isMyTurn:Boolean;
		private var avaibleDominoMoves:Array;
		
		public function Domino_Logic(domino_MainPointer:Domino_Main,graphics:MovieClip)
		{
			this.graphics = graphics;
			this.domino_MainPointer = domino_MainPointer;
			rightArrow = new RightArrow();
			leftArrow = new LeftArrow();
		}
		
		public function takeDomino(dominoNum:int):void
		{
			if(isMyTurn)
			{
				var turnDone:Boolean =false;
				var dominoMove:DominoObject = dominoes[dominoNum];
				trace("dominoNum:"+dominoNum)
				trace(dominoMove.upperNum+"/"+dominoMove.lowerNum)
				var rightDomino:DominoObject = boardDominoes[boardDominoes.length-1];
				var leftDomino:DominoObject = boardDominoes[0];
				if((rightDomino.upperNum == dominoMove.upperNum) || (rightDomino.upperNum == dominoMove.lowerNum))
				{
					trace("in right")
					turnDone = true;
					rightArrow.x = 100
					rightArrow.y = 100
					graphics.addChild(rightArrow);
				}
				if((leftDomino.lowerNum == dominoMove.upperNum) || (leftDomino.lowerNum == dominoMove.lowerNum))
				{
					trace("in left")
					turnDone = true;
					leftArrow.x = 100
					leftArrow.y = 100
					graphics.addChild(leftArrow);
				}
				if(turnDone)
					dominoes.splice(dominoNum,1)
			}
		}
		private function doLeft(ev:MouseEvent):void
		{
			
		}
		private function doRight(ev:MouseEvent):void
		{
			
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
			var rightDomino:DominoObject = boardDominoes[boardDominoes.length-1];
			var leftDomino:DominoObject = boardDominoes[0];
			avaibleDominoMoves = findDominoes(rightDomino.upperNum,leftDomino.lowerNum);
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
			boardDominoes = new Array();
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
			boardDominoes.push(new DominoObject(newDominoCube,key));
		}
		public function makeBoard():void
		{
			if(domino_Graphic != null)
				graphics.removeChild(domino_Graphic);
			domino_Graphic = new Domino_Graphic(dominoes,boardDominoes[0],players,myUserId,this);
			graphics.addChild(domino_Graphic)
		}
	}
}