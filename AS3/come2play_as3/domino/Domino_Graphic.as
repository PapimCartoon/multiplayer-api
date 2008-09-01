package come2play_as3.domino
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Domino_Graphic extends MovieClip
	{
		private var dominoes:Array;/*DominoObject*/
		private var yourDominoes:Array;/*Domino*/
		private var domino_LogicPointer:Domino_Logic;
		private var players:Array;
		private var myUserId:int;
		
		private var leftDominos:Array
		private var rightDominos:Array
		private var middleDomino:Domino;
		
		private var isMiddleVertical:Boolean;
		public function Domino_Graphic(dominoes:Array,dominoObject:DominoObject,players:Array,myUserId:int,domino_LogicPointer:Domino_Logic)
		{
			yourDominoes = new Array();
			leftDominos = new Array();
			rightDominos = new Array();
			this.domino_LogicPointer = domino_LogicPointer;
			this.dominoes = dominoes;
			this.players = players;
			this.myUserId = myUserId;
			addEventListener(MouseEvent.CLICK,chooseDomino);
			arrangeBoard();
			
			middleDomino = new Domino();
			middleDomino.lowerNum.gotoAndStop(dominoObject.lowerNum + 1);
			middleDomino.upperNum.gotoAndStop(dominoObject.upperNum + 1);
			if(dominoObject.upperNum == dominoObject.lowerNum)
				isMiddleVertical = false;	
			else
			{
				middleDomino.rotation = 90;
				isMiddleVertical = true;
			}
			
			middleDomino.x=180;
			middleDomino.y=150;
			addChild(middleDomino);
		}
		
		public function chooseDomino(ev:MouseEvent):void
		{
			if((ev.stageY>280)&&(ev.stageY<325))
			{
				var pos:int = Math.floor(((ev.stageX)/15)/2);
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
		public function reDrawRight():void
		{
			var tempDomino:Domino;
			for(var i:int=0;i<rightDominos.length;i++)
			{
				tempDomino = rightDominos[i];
				if(tempDomino.lowerNum == tempDomino.upperNum)
				{
					tempDomino.rotation = 90;
					tempDomino.y=210;
					tempDomino.x =210 - i*30;
				}				
				else
				{
					tempDomino.y=210;
					tempDomino.x =210 - i*30;
				}
			}	
		}
		public function reDrawLeft():void
		{
			var tempDomino:Domino;
			for(var i:int=0;i<leftDominos.length;i++)
			{
				tempDomino = leftDominos[i];
				if(tempDomino.lowerNum == tempDomino.upperNum)
				{
					tempDomino.rotation = 90;
					tempDomino.y=150;
					tempDomino.x =150 - i*30;
				}				
				else
				{
					tempDomino.y=150;
					tempDomino.x =150 - i*30;
				}
			}	
		}	
		public function addPlayerDominoCube(playerMove:PlayerMove,playerId:int):void
		{
			
		}
		
		public function addDominoCubeToBoard(dominoPos:int,isRight:Boolean):void
		{
			var movingDomino:Domino = yourDominoes[dominoPos]
			yourDominoes.splice(dominoPos,1);
			if(isRight)
			{
				rightDominos.push(movingDomino);
				reDrawRight();
			}
			else
			{
				leftDominos.push(movingDomino);
				reDrawLeft();
			}
					
			reDrawHand();
		}
		public function arrangeBoard():void
		{
			var tempDomino:Domino;
			var tempDominoObject:DominoObject;
			for(var i:int=0;i<dominoes.length;i++)
			{
				tempDominoObject = dominoes[i];
				tempDomino = new Domino;
				tempDomino.lowerNum.gotoAndStop(tempDominoObject.lowerNum+1);
				tempDomino.upperNum.gotoAndStop(tempDominoObject.upperNum+1);
				addChild(tempDomino)
				yourDominoes.push(tempDomino);
			}	
			reDrawHand()
		}
	}
}