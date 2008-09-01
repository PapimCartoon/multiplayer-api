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
		
		public function Domino_Graphic(dominoes:Array,dominoObject:DominoObject,players:Array,myUserId:int,domino_LogicPointer:Domino_Logic)
		{
			yourDominoes = new Array();
			this.domino_LogicPointer = domino_LogicPointer;
			this.dominoes = dominoes;
			this.players = players;
			this.myUserId = myUserId;
			addEventListener(MouseEvent.CLICK,chooseDomino);
			arrangeBoard();
			
			middleDomino = new Domino();
			middleDomino.lowerNum.gotoAndStop(dominoObject.lowerNum + 1);
			middleDomino.upperNum.gotoAndStop(dominoObject.upperNum + 1);
			middleDomino.rotation = 90;
			middleDomino.x=180;
			middleDomino.y=150;
			addChild(middleDomino);
		}
		
		public function chooseDomino(ev:MouseEvent):void
		{
			if((ev.stageY>300)&&(ev.stageY<345))
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
				tempDomino.y=300;
				tempDomino.x =20+ i*30;
				addChild(tempDomino)
				yourDominoes.push(tempDomino);
			}	
		}
	}
}