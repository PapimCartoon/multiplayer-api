package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_generated.UserEntry;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MineSweeper_Logic
	{
		private var mineSweeper_MainPointer:MineSweeper_Main;
		private var mineSweeper_Graphic:MineSweeper_Graphic; 
		private var graphics:MovieClip;
		private var boardLogic:Array;
		private var boardWidth:int;
		private var boardHeight:int;
		private var isMine:Boolean;
		private var movesInProcess:Array;
		public var myUserId:int;
		public function MineSweeper_Logic(mineSweeper_MainPointer:MineSweeper_Main,graphics:MovieClip,boardWidth:int,boardHeight:int)
		{
			
			this.mineSweeper_MainPointer = mineSweeper_MainPointer;
			this.graphics = graphics;
			this.boardWidth = boardWidth;
			this.boardHeight = boardHeight;
			boardLogic = new Array();
			mineSweeper_Graphic = new MineSweeper_Graphic();
			movesInProcess = new Array();
			this.graphics.addChild(mineSweeper_Graphic);
		}
		
		public function buildBoard(users:Array):void
		{
			boardLogic=new Array()
			for(var i:int=0;i<boardWidth;i++)
			{
				boardLogic[i] = new Array();
				for(var j:int = 0;j<boardHeight;j++)
				{
					boardLogic[i][j] = -1 ;
				}
			}
			mineSweeper_Graphic.buildBoard(boardWidth,boardHeight,users);
			graphics.addEventListener(MouseEvent.CLICK,selectMine);
		}
		public function isMoveTaken(playerMove:PlayerMove):Boolean
		{
			if(boardLogic[playerMove.xPos][playerMove.yPos] == -1)
			{
				for each(var tempPlayerMove:PlayerMove in movesInProcess)
				{
					if((playerMove.xPos == tempPlayerMove.xPos) && (playerMove.yPos == tempPlayerMove.yPos))
						return true;
				}
				movesInProcess.push(playerMove);
				return false;
			}
			else
				return true;
		}
		private function selectMine(ev:MouseEvent):void
		{
			var posX:int = Math.floor((ev.stageX-14.5)/16);
			var posY:int = Math.floor((ev.stageY-30)/16);
			if((posX> -1)&&(posX<16)&&(posY>-1)&&(posY<16))
				if(boardLogic[posX][posY] ==-1)
					mineSweeper_MainPointer.pressMine(posX,posY,isMine);
		}
		public function addBoxesServer(serverBox:ServerBox):PlayerBox
		{
			for(var i:int=0;i<movesInProcess.length;i++)
			{
				var tempPlayerMove:PlayerMove = movesInProcess[i];
				if((serverBox.xPos == tempPlayerMove.xPos) && (serverBox.yPos == tempPlayerMove.yPos))
				{
					movesInProcess.splice(i,1);
					boardLogic[serverBox.xPos][serverBox.yPos] = 0;
					var isPlayer:Boolean = (myUserId == tempPlayerMove.takingPlayer)
					if((serverBox.isMine)&&(tempPlayerMove.isMine))
					{
						mineSweeper_Graphic.foundMine(serverBox.xPos,serverBox.yPos,isPlayer)
						//found mine
					}
					else if((!serverBox.isMine)&&(tempPlayerMove.isMine))
					{
						mineSweeper_Graphic.revealBox(serverBox.borderingMines,serverBox.xPos,serverBox.yPos)
						//didnt find mine,where thought there was one
						
					}
					else if((serverBox.isMine)&&(!tempPlayerMove.isMine))
					{
						mineSweeper_Graphic.setOfMine(serverBox.xPos,serverBox.yPos,isPlayer)
						//found an unexpected mine,and died
					}
					else
					{
						mineSweeper_Graphic.revealBox(serverBox.borderingMines,serverBox.xPos,serverBox.yPos)
						//found empty space near mines
					}
					/*
					if(serverBox.isMine)
					{
					boardLogic[serverBox.xPos][serverBox.yPos] = serverBox.
					}
					else*/
					return PlayerBox.create(serverBox,tempPlayerMove.takingPlayer);
				}	
			}	
			return null;
		}
		public function blankBoxCaller(blankSquares:Array)
		{

			for(var i:int=0;i<movesInProcess.length;i++)
				for(var j:int=0;j<blankSquares.length;j++)
				{
					var playerMove:PlayerMove = movesInProcess[i];
					var boxPos:Object = blankSquares[j];
					if((boxPos.xPos == playerMove.xPos) && (boxPos.yPos == playerMove.yPos))
						return playerMove.takingPlayer;
				}
				return -1;
		}
		
		
		public function addBlankBoxesServer(blankSquares:Array):Array/*UserEntries*/
		{

			var userEntries:Array = new Array();
			var userId:int = blankBoxCaller(blankSquares);
			
			for each(var boxPos:Object in blankSquares)
			{
				var playerBox:PlayerBox = new PlayerBox();
				playerBox.borderingMines = 0;
				playerBox.isMine =false;
				playerBox.takingPlayer = userId;
				playerBox.xPos = boxPos.xPos;
				playerBox.yPos = boxPos.yPos;
				mineSweeper_Graphic.revealBox(0,boxPos.xPos,boxPos.yPos)
				userEntries.push(UserEntry.create(boxPos.xPos+"_"+boxPos.yPos,playerBox,false))
			}
			return userEntries;
		}
		
		

	}
}