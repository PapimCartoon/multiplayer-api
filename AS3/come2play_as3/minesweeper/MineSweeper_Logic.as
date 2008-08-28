package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.ServerEntry;
	
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
		private var movesInProcess:Array;
		private var playingUsers:Array;
		private var playerGameData:Array;
		private var shift:Shift;
		private var isMine:Boolean;
		private var madeMoves:int;
		public var myUserId:int;
		public function MineSweeper_Logic(mineSweeper_MainPointer:MineSweeper_Main,graphics:MovieClip,boardWidth:int,boardHeight:int)
		{
			this.mineSweeper_MainPointer = mineSweeper_MainPointer;
			this.graphics = graphics;
			this.boardWidth = boardWidth;
			this.boardHeight = boardHeight;
			
			shift = new Shift()
			shift.x = 250;
			shift.y = 300;
			
			
			shift.addEventListener(MouseEvent.CLICK,pressShift);
			shift.addEventListener(MouseEvent.ROLL_OVER,overShift);
			shift.addEventListener(MouseEvent.ROLL_OUT,leftShift);
			this.graphics.addChild(shift)
		}
		
		private function pressShift(ev:MouseEvent):void
		{
			if(isMine)
			{
				isMine=false;
				shift.gotoAndStop(8);
			}
			else
			{
				isMine=true;
				shift.gotoAndStop(14);
			}
		}
		private function overShift(ev:MouseEvent):void
		{
			if(!isMine)
			{
				shift.gotoAndStop(8);
			}
		}
		private function leftShift(ev:MouseEvent):void
		{
			if(!isMine)
			{
				shift.gotoAndStop(1);
			}
		}
		public function set mine(isMine:Boolean):void
		{
			this.isMine = isMine;
			if(isMine)
				shift.gotoAndStop(14);
			else
				shift.gotoAndStop(1);
				
		}
		public function renewBoard():void
		{
			if(mineSweeper_Graphic!=null)
				this.graphics.removeChild(mineSweeper_Graphic);
		}
		public function buildBoard(users:Array,players:Array):void
		{

			mineSweeper_Graphic = new MineSweeper_Graphic();
			this.graphics.addChild(mineSweeper_Graphic);
			madeMoves=0;
			playingUsers = new Array();
			movesInProcess = new Array();
			boardLogic = new Array();
			playerGameData = new Array();
			for(var i:int=0;i<users.length;i++)
			{
				var user:Object = users[i];
				for(var j:int=0;j<players.length;j++)
					if(user.userId == players[j])
					{
							playingUsers.push(user);
							playerGameData.push(new PlayerData(user.userId))
							if(user.userId == myUserId)
								graphics.addEventListener(MouseEvent.CLICK,selectMine);
					}

			}

			boardLogic=new Array()
			for(i=0;i<boardWidth;i++)
			{
				boardLogic[i] = new Array();
				for(j=0;j<boardHeight;j++)
				{
					boardLogic[i][j] = -1 ;
				}
			}
			mineSweeper_Graphic.buildBoard(boardWidth,boardHeight,playingUsers);
			
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
			if((posX> -1)&&(posX<(boardWidth+1))&&(posY>-1)&&(posY<(boardHeight+1)))
				if(boardLogic[posX][posY] ==-1)
					mineSweeper_MainPointer.pressMine(posX,posY,isMine);
		}
		private function findPlayer(id:int):int
		{
			for (var i:int=0;i<playingUsers.length;i++)
			{
				var playerObj:Object = playingUsers[i];
				if(playerObj.userId == id)
					return i;
			}
			return -1;
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
					var playerNum:int = findPlayer(tempPlayerMove.takingPlayer);
					var currentData:PlayerData = playerGameData[playerNum];
					if((serverBox.isMine)&&(tempPlayerMove.isMine))
					{
						mineSweeper_Graphic.foundMine(serverBox.xPos,serverBox.yPos,playerNum)
						currentData.addLife();
						currentData.playerScore += 10;
						mineSweeper_Graphic.updateLives(playerNum,currentData.playerLives);
						//found mine
					}
					else if((!serverBox.isMine)&&(tempPlayerMove.isMine))
					{
						mineSweeper_Graphic.revealBox(serverBox.borderingMines,serverBox.xPos,serverBox.yPos)
						currentData.playerLives --;
						currentData.playerScore -= 5;
						mineSweeper_Graphic.updateLives(playerNum,currentData.playerLives);
						//didnt find mine,where thought there was one
						
					}
					else if((serverBox.isMine)&&(!tempPlayerMove.isMine))
					{
						mineSweeper_Graphic.setOfMine(serverBox.xPos,serverBox.yPos,playerNum)
						currentData.playerLives --;
						currentData.playerScore -= 5;
						mineSweeper_Graphic.updateLives(playerNum,currentData.playerLives);
						//found an unexpected mine,and died
					}
					else
					{
						mineSweeper_Graphic.revealBox(serverBox.borderingMines,serverBox.xPos,serverBox.yPos)
						currentData.playerScore += 1;
						//found empty space near mines
					}
					madeMoves++;
					mineSweeper_Graphic.updateScore(playerNum,currentData.playerScore);
					if(madeMoves >= boardHeight * boardWidth)
						gameOver();
					if(currentData.playerLives == 0)
						gameOver();
					
					return PlayerBox.create(serverBox,tempPlayerMove.takingPlayer);
				}	
			}	
			return null;
		}
		private function gameOver():void
		{
			//graphics.removeEventListener(MouseEvent.CLICK,selectMine);
			mineSweeper_MainPointer.gameOver();
		}
		public function endMatch():Array/*PlayerMatchOver*/
		{
			var playerMatchOverArr:Array = new Array();
			for each(var playerData:PlayerData in playerGameData)
				if(playerData.playerLives == 0)
					playerData.playerScore = 0;				
			playerGameData.sortOn("playerScore", Array.NUMERIC | Array.DESCENDING);		
			if(playerGameData.length ==2)
			{
				playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[0].id,playerGameData[0].playerScore,100));
				playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[1].id,playerGameData[1].playerScore,0));
			}
			else if(playerGameData.length ==3)
			{
				playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[0].id,playerGameData[0].playerScore,70));
				playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[1].id,playerGameData[1].playerScore,30));
				playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[2].id,playerGameData[2].playerScore,0));
			}
			else if(playerGameData.length ==4)
			{
				playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[0].id,playerGameData[0].playerScore,50));
				playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[1].id,playerGameData[1].playerScore,30));
				playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[2].id,playerGameData[2].playerScore,20));
				playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[3].id,playerGameData[3].playerScore,0));
			}	
			return 	playerMatchOverArr;
		}
		public function blankBoxCaller(blankSquares:Array):int
		{

			for(var i:int=0;i<movesInProcess.length;i++)
				for(var j:int=0;j<blankSquares.length;j++)
				{
					var playerMove:PlayerMove = movesInProcess[i];
					var blankBox:BlankBox = blankSquares[j] as BlankBox;
					if((blankBox.xPos == playerMove.xPos) && (blankBox.yPos == playerMove.yPos))
						return playerMove.takingPlayer;
				}
				return -1;
		}
		private function applyOldMove(serverBox:ServerBox,playerMove:PlayerMove):void
		{
			var playerNum:int = findPlayer(playerMove.takingPlayer)
			playerMove.takingPlayer = playerNum;
			var playerData:PlayerData = playerGameData[playerNum];
			if(playerMove.isMine)
			{
				if(serverBox.isMine)
				{
					playerData.addLife();
					playerData.playerScore +=10;
				}
				else
				{
					playerData.playerLives --;
					playerData.playerScore -=5;
				}
			}
			else
			{
				if(serverBox.isMine)
				{
					playerData.playerLives --;
					playerData.playerScore -=5;
				}
				else
				{
					playerData.playerScore ++;
				}
			}
		}
		public function loadBoard(users:Array,players:Array,serverEntries:Array):void
		{
			mineSweeper_Graphic = new MineSweeper_Graphic();
			this.graphics.addChild(mineSweeper_Graphic);
			madeMoves=0;
			playingUsers = new Array();
			movesInProcess = new Array();
			boardLogic = new Array();
			playerGameData = new Array();
			for(var i:int=0;i<users.length;i++)
			{
				var user:Object = users[i];
				for(var j:int=0;j<players.length;j++)
					if(user.userId == players[j])
					{
							playingUsers.push(user);
							playerGameData.push(new PlayerData(user.userId))
							if(user.userId == myUserId)
								graphics.addEventListener(MouseEvent.CLICK,selectMine);
					}

			}
			
			
			
			
			var loadBoard:Array = new Array();
			var playerMoves:Array =new Array();
			boardLogic=new Array()
			for(i=0;i<boardWidth;i++)
			{
				loadBoard[i] = new Array();
				boardLogic[i] = new Array();
				for(j=0;j<boardHeight;j++)
				{
					boardLogic[i][j] = -1 ;
				}
			}
			for each(var serverEntry:ServerEntry in serverEntries)
			{
				if(serverEntry.value is ServerBox)
				{
					var serverBox:ServerBox=serverEntry.value as ServerBox
					loadBoard[serverBox.xPos][serverBox.yPos] = serverBox;
					boardLogic[serverBox.xPos][serverBox.yPos] = -1;
				}
				else if(serverEntry.value is PlayerMove)
				{
					var playerMove:PlayerMove = serverEntry.value as PlayerMove;
					playerMoves.push(playerMove);
					applyOldMove(serverBox,playerMove);
				}
			}
			mineSweeper_Graphic.loadBoard(boardWidth,boardHeight,playingUsers,loadBoard,playerMoves);
			for(i=0;i<playerGameData.length;i++)
			{
				var playerData:PlayerData = playerGameData[i];
				mineSweeper_Graphic.updateLives(i,playerData.playerLives);
				mineSweeper_Graphic.updateScore(i,playerData.playerScore);
			}
			
			
		}
		public function addBlankBoxesServer(blankSquares:Array):void
		{

			var userId:int = blankBoxCaller(blankSquares);	
			var playerNum:int = findPlayer(userId);
			var currentData:PlayerData = playerGameData[playerNum];
			for each(var boxPos:Object in blankSquares)
			{
				var blankBox:BlankBox = boxPos as BlankBox
				mineSweeper_Graphic.revealBox(blankBox.bordering,blankBox.xPos,blankBox.yPos);
				boardLogic[blankBox.xPos][blankBox.yPos] = 0
				currentData.playerScore += 1;
				madeMoves++;
			}
			mineSweeper_Graphic.updateScore(playerNum,currentData.playerScore);
			if(madeMoves >= boardHeight * boardWidth)
				gameOver();
		}
		
		

	}
}

class PlayerData
{
	public var playerScore:int;
	public var playerLives:int;
	public var lifeThirds:int
	public var id:int;
	public function PlayerData(id:int)
	{
		playerScore=0;
		playerLives = 3;
		lifeThirds=0;
		this.id = id;
	}
	public function addLife():void
	{
			
		if(lifeThirds == 3)
		{
			if(playerLives<3)
			{
				lifeThirds = 0;
				playerLives++;
			}
		}
		else
			lifeThirds++;
	}
}