package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_copied.JSON;
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.ServerEntry;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MineSweeperLogic
	{
		
		//graphicly used
		private var shift:Shift;
		private var mineSweeperGraphic:MineSweeperGraphic; 
		private var graphics:MovieClip;
		//multiplayer related
		private var playerGameData:Array;/*custom  data about players*/
		private var allPlayerIds:Array;
		public var myUserId:int;
		public var isPlaying:Boolean;
		
		private var scaleX:Number;
		private var scaleY:Number;
		
		private var mineSweeperMainPointer:MineSweeperMain;/*Pointer to minesweeper main*/
		private var boardLogic:Array;
		/*
		what places were pressed already
		value 0 meant unthoched
		value 1 means pressed
		value 2 means press callback on this square was recived
		value 3 means the move is on the board
		*/
		private var boardWidth:int;/*board width in squares*/
		private var boardHeight:int;/*board height in squares*/
		
		private var stageX:int;/*the x where the game is positioned*/
		private var stageY:int;/*the y where the game is positioned*/
		
		private var movesInProcess:Array;/*Moves that need to be addressed*/
		private var isMine:Boolean;
		private var madeMoves:int;/*move counted so far*/
		private var avaibleMoves:int;/*avaible moves*/

		public function MineSweeperLogic(mineSweeperMainPointer:MineSweeperMain,graphics:MovieClip)
		{
			this.mineSweeperMainPointer = mineSweeperMainPointer;
			this.graphics = graphics;
			shift = new Shift();
			shift.x = 250;
			shift.y = 300;
			
			shift.addEventListener(MouseEvent.CLICK,pressShift);
			shift.addEventListener(MouseEvent.ROLL_OVER,overShift);
			shift.addEventListener(MouseEvent.ROLL_OUT,leftShift);
			this.graphics.addChild(shift)
			
			mineSweeperGraphic = new MineSweeperGraphic();
			mineSweeperGraphic.addEventListener(MouseEvent.CLICK,selectMine);
			graphics.addChild(mineSweeperGraphic);
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
		public function setNewGraphicScale(scaleX:Number,scaleY:Number):void
		{
			this.scaleX = scaleX;
			this.scaleY = scaleY;
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
		public function makeBoard(boardWidth:int,boardHeight:int,stageX:int,stageY:int,allPlayerIds:Array/*int*/,usersData:Array/*Object*/,myUserId:int):void
		{
			this.boardWidth = boardWidth;
			this.boardHeight = boardHeight;
			this.stageX = stageX;
			this.stageY = stageY;
			this.myUserId = myUserId;
			this.allPlayerIds = allPlayerIds;
			if(allPlayerIds.indexOf(myUserId)!= -1)
				isPlaying = true;
			madeMoves = 0;
			movesInProcess = new Array();
			playerGameData = new Array();
			boardLogic=new Array()
			for(var i:int=0;i<allPlayerIds.length;i++)
			{
				playerGameData[i] = new PlayerData(allPlayerIds[i]);
			}
			for(i=0;i<boardWidth;i++)
			{
				boardLogic[i] = new Array();
				for(var j:int=0;j<boardHeight;j++)
				{
					boardLogic[i][j] = 0 ;
				}
			}		
			mineSweeperGraphic.makeBoard(boardWidth,boardHeight,usersData,allPlayerIds.indexOf(myUserId) != -1);

		}
		public function loadBoard(serverEntries:Array/*ServerEntry*/):void
		{
			var serverBoxes:Array = new Array/*ServerBox*/
			var safeZones:Array = new Array /*Array*//*ServerBox*/
			for each (var serverEntry:ServerEntry in serverEntries)
			{
				trace("serverEntry :"+JSON.stringify(serverEntry.value))
				if(serverEntry.value is PlayerMove)
					addPlayerMove(serverEntry.value as PlayerMove)
				else if(serverEntry.value is ServerBox)
					serverBoxes.push(serverEntry.value as ServerBox)
				else if(serverEntry.value is Array)
					safeZones.push(serverEntry.value as Array)
			}
			for each (var serverBox:ServerBox in serverBoxes)
			{
				addServerBox(serverBox);
			}
			for each (var safeZone:Array in safeZones)
			{
				addSafeZone(safeZone);
			}

		}
		private function selectMine(ev:MouseEvent):void
		{
			var xPos:int = Math.floor((ev.stageX-(stageX+9.5))/(16*scaleX));
			var yPos:int = Math.floor((ev.stageY-(stageY+7))/(16*scaleY));
			trace(scaleX+"/"+scaleY)
			if((xPos> -1)&&(xPos<(boardWidth))&&(yPos>-1)&&(yPos<(boardHeight)))
				if((boardLogic[xPos][yPos] == 0) && (isPlaying))
				{
					boardLogic[xPos][yPos] = 1;
					mineSweeperMainPointer.makePlayerMove(PlayerMove.create(xPos,yPos,myUserId,isMine));
				}
		}
		
		public function addPlayerMove(playerMove:PlayerMove):Boolean
		{
			for each(var queuedMove:PlayerMove in movesInProcess)
			{
				if((playerMove.xPos == queuedMove.xPos) && (playerMove.yPos == queuedMove.yPos))
					return false;
			}
			movesInProcess.push(playerMove);
			boardLogic[playerMove.xPos][playerMove.yPos] = 2;
			return true;
		}
		
		public function addServerBox(serverBox:ServerBox):void
		{
			var playerMove:PlayerMove;
			for(var i:int = 0 ;i < movesInProcess.length ; i++)
			{
				playerMove = movesInProcess[i];
				if ((playerMove.xPos == serverBox.xPos) && (playerMove.yPos == serverBox.yPos))
				{
					movesInProcess.splice(i,1);
					updateMove(playerMove,serverBox);
					return;
				}
			}
		}
		
		private function updateMove(playerMove:PlayerMove,serverBox:ServerBox):void
		{
			var playerNum:int = allPlayerIds.indexOf(playerMove.playerId);
			var currentData:PlayerData = playerGameData[playerNum]
			if((playerMove.isMine) && (serverBox.isMine))//player found mine
			{
				mineSweeperGraphic.foundMine(playerNum,serverBox.xPos,serverBox.yPos);
				currentData.addLifePart();
				currentData.playerScore += 10;
			}
			else if((playerMove.isMine) && (!serverBox.isMine))//player thought he found a mine,he was wrong!
			{
				mineSweeperGraphic.revealBox(playerNum,serverBox.borderingMines,serverBox.xPos,serverBox.yPos,false);
				currentData.playerLives --;
				currentData.playerScore -= 5;
			}
			else if((!playerMove.isMine) && (serverBox.isMine))//player thought he was safe,he was wrong!
			{
				mineSweeperGraphic.setOfMine(playerNum,serverBox.xPos,serverBox.yPos);
				currentData.playerLives --;
				currentData.playerScore -= 5;
			}
			else if((!playerMove.isMine) && (!serverBox.isMine))//player found a safe spot
			{
				mineSweeperGraphic.revealBox(playerNum,serverBox.borderingMines,serverBox.xPos,serverBox.yPos,true);
				currentData.playerScore += 1;
			}
			mineSweeperGraphic.updateLives(playerNum,currentData.playerLives);
			mineSweeperGraphic.updateScore(playerNum,currentData.playerScore);
			boardLogic[serverBox.xPos][serverBox.yPos] = 3
			madeMoves++;
			if(madeMoves >= boardHeight * boardWidth)
				gameOver();
			if(currentData.playerLives == 0)
				gameOver();
		}
		
		public function gameOver():void
		{
			var playerMatchOverArr:Array/*PlayerMatchOver*/ = new Array();
			for each(var playerData:PlayerData in playerGameData)
				if(playerData.playerLives == 0)
					playerData.playerScore = -1000;				
			playerGameData.sortOn("playerScore", Array.NUMERIC | Array.DESCENDING);		
			if(playerGameData.length ==1)
			{
				playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[0].id,playerGameData[0].playerScore,100));
			}
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
			mineSweeperMainPointer.gameOver(playerMatchOverArr);
		}

		private function findPlayer(serverBox:ServerBox):int
		{
			var playerMove:PlayerMove;
			for(var i:int = 0 ;i < movesInProcess.length ; i++)
			{
				playerMove = movesInProcess[i];
				if ((playerMove.xPos == serverBox.xPos) && (playerMove.yPos == serverBox.yPos))
				{
					movesInProcess.splice(i,1);
					return playerMove.playerId;
				}
			}
			return -1;
		}

		public function addSafeZone(safeSquares:Array/*ServerBox*/):void
		{
			var playerId:int = -1;
			var score:int = 0;
			for each (var serverBox:ServerBox in safeSquares)
			{
				if ((boardLogic[serverBox.xPos][serverBox.yPos] == 2) && (playerId == -1))
				{
					playerId = findPlayer(serverBox);
					break;
				}
			}
			
			for each (serverBox in safeSquares)
			{
				if(boardLogic[serverBox.xPos][serverBox.yPos] != 3)
				{
					mineSweeperGraphic.revealBox(allPlayerIds.indexOf(playerId),serverBox.borderingMines,serverBox.xPos,serverBox.yPos,true);
					score ++;
					madeMoves ++ ;	
				}
				boardLogic[serverBox.xPos][serverBox.yPos] = 3
			}			
		
			var playerNum:int = allPlayerIds.indexOf(playerId);
			var currentData:PlayerData = playerGameData[playerNum]
			currentData.playerScore += score;
			mineSweeperGraphic.updateScore(playerNum,currentData.playerScore);
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
	public function addLifePart():void
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