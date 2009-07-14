package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.API_Message;
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.ServerEntry;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
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
		
		private var movesInProcess:Array;/*Moves that need to be addressed*/
		private var isMine:Boolean;
		private var madeMoves:int;/*move counted so far*/
		private var avaibleMoves:int;/*avaible moves*/

		private var gameOverSound:GameOverSound;
		public function MineSweeperLogic(mineSweeperMainPointer:MineSweeperMain,graphics:MovieClip)
		{
			this.mineSweeperMainPointer = mineSweeperMainPointer;
			this.graphics = graphics;
			shift = new Shift();
			shift.x = 250;
			shift.y = 300;
			AS3_vs_AS2.myAddEventListener("shift",shift,MouseEvent.CLICK,pressShift)
			AS3_vs_AS2.myAddEventListener("shift",shift,MouseEvent.ROLL_OVER,overShift)
			AS3_vs_AS2.myAddEventListener("shift",shift,MouseEvent.ROLL_OUT,leftShift)
			this.graphics.addChild(shift)
			mineSweeperGraphic = new MineSweeperGraphic();
			AS3_vs_AS2.myAddEventListener("mineSweeperGraphic",mineSweeperGraphic,MouseEvent.CLICK,selectMine)
			graphics.addChild(mineSweeperGraphic);
		}
		private function pressShift(ev:MouseEvent):void
		{
			if(isMine)
			{
				isMine=false;
				shift.gotoAndStop(1);
			}
			else
			{
				isMine=true;
				shift.gotoAndStop(8);
			}
		}

		private function overShift(ev:MouseEvent):void
		{
			//shift.stroke_mc.visible = true;
		}
		private function leftShift(ev:MouseEvent):void
		{
			//shift.stroke_mc.visible = false;
		}
		public function set mine(isMine:Boolean):void
		{
			this.isMine = isMine;
			//shift.stroke_mc.visible = false;
			if(isMine)
				shift.gotoAndStop(8);
			else
				shift.gotoAndStop(1);
				
		}
		public function makeBoard(boardWidth:int,allPlayerIds:Array/*int*/,myUserId:int):void
		{
			this.boardWidth = boardWidth;
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
				for(var j:int=0;j<boardWidth;j++)
				{
					boardLogic[i][j] = 0 ;
				}
			}		
			mineSweeperGraphic.makeBoard(boardWidth,allPlayerIds,allPlayerIds.indexOf(myUserId) != -1);

		}
		public function loadBoard(serverEntries:Array/*ServerEntry*/):void
		{
			var serverBoxes:Array = new Array/*ServerBox*/
			var safeZones:Array = new Array /*Array*//*ServerBox*/
			for each (var serverEntry:ServerEntry in serverEntries)
			{
			
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
			if((T.custom(API_Message.CUSTOM_INFO_KEY_isPause,false) as Boolean))	return;
			if(!mineSweeperMainPointer.allowMoves)	return;
			var clickPoint:Point = mineSweeperGraphic.globalToLocal(new Point(ev.stageX,ev.stageY));
			var xPos:int = Math.floor((clickPoint.x - 9.5)/(MineSweeperMain.squareSize));
			var yPos:int = Math.floor((clickPoint.y-7)/(MineSweeperMain.squareSize));
			
			if((xPos> -1)&&(xPos<(boardWidth))&&(yPos>-1)&&(yPos<(boardWidth)))
				if((boardLogic[xPos][yPos] == 0) && (isPlaying))
				{
					boardLogic[xPos][yPos] = 1;
					mineSweeperMainPointer.makePlayerMove(PlayerMove.create(xPos,yPos,myUserId,isMine));
				}
		}
		public function getRandomMove(xpos:int,ypos:int):ComputerMove{
			for(var i:int = xpos;i<boardWidth;i++){
				for(var j:int = ypos;j<boardWidth;j++){
					if(boardLogic[i][j] == 0){
						return ComputerMove.create(i,j); 
					}
				}
			}
			return null;
		}
		
		public function getComputerMove():ComputerMove{
			var computerMove:ComputerMove = getRandomMove(Math.random()*boardWidth,Math.random()*boardWidth);
			if(computerMove == null){
				computerMove = getRandomMove(0,0);
			}
			if(computerMove != null){
				boardLogic[computerMove.xPos][computerMove.yPos] = 1;
			}
			return computerMove;
		}
		public function addPlayerMove(playerMove:PlayerMove):Boolean
		{
			for each(var queuedMove:PlayerMove in movesInProcess)
			{
				if((playerMove.xPos == queuedMove.xPos) && (playerMove.yPos == queuedMove.yPos))
					return false;
				if(boardLogic[playerMove.xPos][playerMove.yPos] == 3)
					return false;
			}
			movesInProcess.push(playerMove);
			boardLogic[playerMove.xPos][playerMove.yPos] = 2;
			return true;
		}
		public function addComputerMove(computerMove:ComputerMove):Boolean
		{
			var fakePlayerMove:PlayerMove = PlayerMove.create(computerMove.xPos,computerMove.yPos,-1,false);
			for each(var queuedMove:PlayerMove in movesInProcess)
			{
				if((fakePlayerMove.xPos == queuedMove.xPos) && (fakePlayerMove.yPos == queuedMove.yPos))
					return false;
				if(boardLogic[fakePlayerMove.xPos][fakePlayerMove.yPos] == 3)
					return false;
			}
			movesInProcess.push(fakePlayerMove);
			boardLogic[fakePlayerMove.xPos][fakePlayerMove.yPos] = 2;
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
					updateMove(playerMove,serverBox,playerMove.playerId == -1);
					return;
				}
			}
		}
		
		private function updateMove(playerMove:PlayerMove,serverBox:ServerBox,isComputer:Boolean):void
		{
			var playerNum:int = allPlayerIds.indexOf(playerMove.playerId);
			var currentData:PlayerData = playerGameData[playerNum]
			if(currentData == null)	return;
			if(isComputer){
				if(serverBox.isMine){
					mineSweeperGraphic.foundMine(playerNum,serverBox.xPos,serverBox.yPos);
					currentData.addLifePart();
					currentData.playerScore += 10;
				}else{
					mineSweeperGraphic.revealBox(playerNum,serverBox.borderingMines,serverBox.xPos,serverBox.yPos,true);
					currentData.playerScore += 1;
				}
				
			}else if((playerMove.isMine) && (serverBox.isMine))//player found mine
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
			if((madeMoves >= boardWidth * boardWidth) || (currentData.playerLives == 0))
				gameOver();
		}
		
		public function gameOver():void
		{
			var playerMatchOverArr:Array/*PlayerMatchOver*/ = new Array();
			for each(var playerData:PlayerData in playerGameData)
			{
				if(playerData.playerLives == 0)
				{
					playerData.playerScore = -1000;	
					mineSweeperGraphic.updateScore(allPlayerIds.indexOf(playerData.id),playerData.playerScore);
				}	
			}		
			playerGameData.sortOn("playerScore", Array.NUMERIC | Array.DESCENDING);		
			if(playerGameData.length ==1)
			{
				playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[0].id,playerGameData[0].playerScore,100));
			}
			if(playerGameData.length ==2)
			{
				if(allPlayerIds.indexOf(-1) !=-1){
					if(playerGameData[0].id == -1)
						playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[1].id,playerGameData[1].playerScore - playerGameData[0].playerScore,0));
					else
						playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[0].id,playerGameData[0].playerScore -playerGameData[1].playerScore,100));
				}else{
					playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[0].id,playerGameData[0].playerScore,100));
					playerMatchOverArr.push(PlayerMatchOver.create(playerGameData[1].id,playerGameData[1].playerScore,0));
				}
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
			if((myUserId == playerGameData[playerGameData.length - 1].id) && (playerGameData.length > 1))
			{
				if(gameOverSound != null)
				{
					graphics.removeChild(gameOverSound);	
				}
				gameOverSound = new GameOverSound();
				graphics.addChild(gameOverSound);
			}
			mineSweeperMainPointer.gameOver(playerMatchOverArr);
			isPlaying = false;
		}

		private function findPlayerMove(serverBox:ServerBox):PlayerMove
		{
			var playerMove:PlayerMove;
			for(var i:int = 0 ;i < movesInProcess.length ; i++)
			{
				playerMove = movesInProcess[i];
				if ((playerMove.xPos == serverBox.xPos) && (playerMove.yPos == serverBox.yPos))
				{
					movesInProcess.splice(i,1);
					return playerMove;
				}
			}
			return null;
		}

		public function addSafeZone(safeSquares:Array/*ServerBox*/):void
		{
			var playerMove:PlayerMove = null;
			var score:int = 0;
			for each (var serverBox:ServerBox in safeSquares)
			{
				if ((boardLogic[serverBox.xPos][serverBox.yPos] == 2) && (playerMove == null))
				{
					playerMove = findPlayerMove(serverBox);
					break;
				}
			}
			var isComputer:Boolean = (playerMove.playerId == -1);
			for each (serverBox in safeSquares)
			{
				if(boardLogic[serverBox.xPos][serverBox.yPos] != 3)
				{
					if((playerMove.xPos == serverBox.xPos) &&(playerMove.yPos == serverBox.yPos))
						mineSweeperGraphic.revealBox(allPlayerIds.indexOf(playerMove.playerId),serverBox.borderingMines,serverBox.xPos,serverBox.yPos,!playerMove.isMine);
					else
						mineSweeperGraphic.revealBox(allPlayerIds.indexOf(playerMove.playerId),serverBox.borderingMines,serverBox.xPos,serverBox.yPos,true);
					score ++;
					madeMoves ++ ;	
				}
				boardLogic[serverBox.xPos][serverBox.yPos] = 3
			}			
		
			var playerNum:int = allPlayerIds.indexOf(playerMove.playerId);
			var currentData:PlayerData = playerGameData[playerNum];
			if((!playerMove.isMine) || isComputer)
				currentData.playerScore += score;
			else
			{
				currentData.playerScore -= 10;
				currentData.playerLives --;
			}
			mineSweeperGraphic.updateLives(playerNum,currentData.playerLives);
			mineSweeperGraphic.updateScore(playerNum,currentData.playerScore);
			if((madeMoves >= boardWidth * boardWidth) || (currentData.playerLives == 0))
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