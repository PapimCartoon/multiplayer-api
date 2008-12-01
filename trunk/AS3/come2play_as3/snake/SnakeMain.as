package come2play_as3.snake
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.MovieClip;

	public class SnakeMain extends ClientGameAPI
	{
		private var snakeLogic:SnakeLogic;
		private var graphics:MovieClip;
		private var myUserId:int;
		private var allPlayerIds:Array;/*int*/
		private var waitingMove:Boolean;
		private var nextMove:int;
		private var xMax:int;
		private var yMax:int;
		private var snakeSpeed:int;
		public var head:int;
		public var tail:int;
		public var tick:int;
		public var paused:Boolean;
		public function SnakeMain(graphics:MovieClip)
		{
			(new PlayerMove).register();
			super(graphics);
			this.graphics = graphics;
			AS3_vs_AS2.waitForStage(graphics,constructGame);
		}
		public function constructGame():void
		{
			waitingMove = false;
			snakeLogic = new SnakeLogic(graphics,this);
			doRegisterOnServer();	
		}
		
		public function makeMove(playerMove:PlayerMove):void
		{
			if(waitingMove)
			{
				waitingMove = false;
				if(nextMove!=0)
				{
					updateVector(nextMove);
					nextMove = 0
				}
			}
			playerMove.tick = tick++;
			if(playerMove.eating)
				doStoreState([UserEntry.create(myUserId+"-"+head++,playerMove,false)]);
			else
				doStoreState([UserEntry.create(myUserId+"-"+head++,playerMove,false),UserEntry.create(myUserId+"-"+tail++,null,false)]);
		}
		public function initSnake(startingUserEntries:Array/*UserEntry*/):void
		{
			doStoreState(startingUserEntries);
		}
		public function finishGame(finishedPlayers:Array/*PlayerMatchOver*/):void
		{
			doAllEndMatch(finishedPlayers);
		}
		public function pauseControl():void
		{
			if(paused)
			{
				paused = false;
				snakeLogic.moveTick.start();
			}
			else
			{
				paused = true;
				snakeLogic.moveTick.stop();
			}
		}
		public function foundHacker(userId:int,message:String):void
		{
			doAllFoundHacker(userId,message);	
		}
		private function updateVector(keyCode:int):void
		{
			switch(keyCode)
			{
				case 37: snakeLogic.changeVector("Left");	break;
				case 38: snakeLogic.changeVector("Up");		break;
				case 39: snakeLogic.changeVector("Right");	break;
				case 40: snakeLogic.changeVector("Down");	break;
			}
		}
		override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void 
		{
			if((keyCode == 80) && isKeyDown)
				pauseControl();
			if(allPlayerIds.indexOf(myUserId) != -1)
			{
				if (!isKeyDown) return;
				if(snakeLogic == null) return; // arrow keys pressed (37 = left, 38 = up, 39 = right, 40 = down)
				if(waitingMove) {nextMove = keyCode; return;}
				waitingMove = true;
				updateVector(keyCode);
			}
		}

		override public function gotCustomInfo(infoEntries:Array):void
		{
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId, null) as int;
			xMax = T.custom("xMax", 24) as int;
			yMax = T.custom("yMax", 24) as int;
			snakeSpeed = T.custom("snakeSpeed", 100) as int;
		}
		override public function gotMatchEnded(finishedPlayerIds:Array):void
		{
			if(allPlayerIds.length< 2)
			{
				snakeLogic.moveTick.stop();
				doTrace("Strop","in Main");
			}
		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			this.allPlayerIds = allPlayerIds;
			tick = 1;
			head = 4;
			tail = 0;
			paused = false;
			if(serverEntries.length > 0 )
			{
				for each (var id:int in finishedPlayerIds)
				{
					var tempPos:int = allPlayerIds.indexOf(id);
					if(tempPos != -1)
						allPlayerIds.splice(tempPos,1);
				}
				snakeLogic.loadGame(myUserId,allPlayerIds,xMax,yMax,serverEntries);	
			}
			else
			{
				var userEntries:Array/*UserEntry*/ = snakeLogic.startGame(myUserId,allPlayerIds,xMax,yMax,snakeSpeed);
				doAllStoreState(userEntries);	
			}
			
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			var serverEntry:ServerEntry = serverEntries[0];
			if(serverEntries.length == (4 * allPlayerIds.length))
			{
				if (serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,"tried to fake starting snake positins");
			}
			else if (serverEntry.value is PlayerMove)
			{		
				snakeLogic.makePlayerMove(serverEntry.value as PlayerMove);
			}
				
		}
		
	}
}