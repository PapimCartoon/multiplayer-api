package come2play_as3.snake
{
	import come2play_as3.api.auto_copied.AS3_Timer;
	import come2play_as3.api.auto_copied.RandomGenerator;
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.ServerEntry;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class SnakeLogic
	{
		private var snakeSpeed:int = 500;
		private var myUserId:int;
		private var allPlayerIds:Array/*int*/;
		private var graphic:MovieClip;
		private var snakeGraphic:SnakeGraphic;
		private var snakeMainPointer:SnakeMain;
		private var allPlayerSnakes:Array/*PlayerSnake*/
		private var foodCubeGenerator:RandomGenerator;
		private var interactionBoard:InteractionBoard;
		private var moveGap:int;
		public var moveTick:Timer
		
		public function SnakeLogic(graphic:MovieClip,snakeMainPointer:SnakeMain)
		{
			this.graphic = graphic;
			this.snakeMainPointer = snakeMainPointer;
			moveTick = new AS3_Timer("SnakeLogic.snakeSpeed", snakeSpeed,0);
			moveTick.addEventListener(TimerEvent.TIMER,makeMove);
		}
		
		private function makeMove(ev:TimerEvent):void
		{
			if(moveGap < allPlayerIds.length * 3)
			{
				var playerMove:PlayerMove
				
				for each(var playerSnake:VirtualSnake in allPlayerSnakes)
				{
					playerMove = playerSnake.moveForward((snakeMainPointer.tick % 50) == 0);	
					if (playerMove !=null)
					{
						if (playerMove.userId == myUserId)
							snakeMainPointer.makeMove(playerMove);	
					}
					moveGap++;
				}
				updateSpeed();
				printSnakes();
			}
		}
		public function foundHacker(userId:int,message:String):void
		{
			snakeMainPointer.foundHacker(userId,message);
		}
		public function updateSpeed():void
		{
			var quelength:int;
				quelength = interactionBoard.queueLength(allPlayerIds.indexOf(myUserId));
			if(quelength > 3)
				moveTick.stop();
			else
			{
				moveTick.delay = snakeSpeed + 200*quelength;
				if(!moveTick.running)
					moveTick.start();
			}	
		}
		
		public function finishGame(deadPlayers:Array):void
		{
			var finishedPlayers:Array/*PlayerMatchOver*/ = new Array();
			
			
			for each(var playerId:int in deadPlayers)
			{
				finishedPlayers.push(PlayerMatchOver.create(playerId,0,0));
				var pos:int = allPlayerIds.indexOf(playerId);
				allPlayerIds.splice(pos,1);
				allPlayerSnakes.splice(pos,1);
				snakeGraphic.removeSnake(pos);
				interactionBoard.removeSnake(pos);
			}
			
			if(allPlayerIds.length == 1)
			{
				playerId = allPlayerIds[0];
				finishedPlayers.push(PlayerMatchOver.create(playerId,100,100));
				pos = allPlayerIds.indexOf(playerId);
				allPlayerIds.splice(pos,1);
				allPlayerSnakes.splice(pos,1);
				snakeGraphic.removeSnake(pos);
				interactionBoard.removeSnake(pos);
					
			}
			if(allPlayerIds.length < 2)
				moveTick.stop();
			snakeMainPointer.finishGame(finishedPlayers);
			
		}
		public function makePlayerMove(playerMove:PlayerMove):void
		{
			moveGap--;
			var pos:int = allPlayerIds.indexOf(playerMove.userId);
			interactionBoard.addMove(pos,playerMove);
			if(allPlayerIds.indexOf(myUserId) == -1)
				printSnakes();
			else
				updateSpeed();
		}
		public function printSnakes():void
		{
			var playerSnake:VirtualSnake;
			for(var i:int = 0;i<allPlayerSnakes.length;i++)
			{
				playerSnake = allPlayerSnakes[i];
				snakeGraphic.printSnake(playerSnake.getConfirmedParts(),playerSnake.getUnConfirmedParts(),allPlayerIds[i]);
			}
			
		}
		public function changeVector(vector:String):void
		{
			var playerSnake:VirtualSnake = allPlayerSnakes[allPlayerIds.indexOf(myUserId)];
			playerSnake.vector = vector;
		}
		public function startGame(myUserId:int,allPlayerIds:Array/*int*/,xMax:int,yMax:int,snakeSpeed:int):Array/*UserEntry*/
		{
			if(snakeGraphic != null)
				graphic.removeChild(snakeGraphic);
			if(snakeSpeed > 0)
			{
				this.snakeSpeed = snakeSpeed;
				moveTick.delay = snakeSpeed;
			}
			this.myUserId = myUserId;	
			this.allPlayerIds = allPlayerIds;
			allPlayerSnakes = new Array();
			interactionBoard= new InteractionBoard(allPlayerSnakes,myUserId,this);
			moveGap = 0;
			var userEntries:Array/*UserEntry*/ = new Array();
			for(var i:int = 0;i<allPlayerIds.length;i++)
			{
				var tempRealSnake:RealSnake = new RealSnake(i,allPlayerIds[i],xMax,yMax,[],[],this);
				userEntries = userEntries.concat(tempRealSnake.getStartingSnake());
				interactionBoard.addRealSnake(tempRealSnake,i);
				if(allPlayerIds[i] == myUserId)
					allPlayerSnakes[i]= new VirtualSnake(tempRealSnake,true,false);			
				else
					allPlayerSnakes[i]= new VirtualSnake(tempRealSnake,false,false);
				
			}
			
			snakeGraphic = new SnakeGraphic(allPlayerSnakes,allPlayerIds);
			graphic.addChild(snakeGraphic);
			if(allPlayerIds.indexOf(myUserId) != -1)
				moveTick.start();
			return userEntries;
		}
		
		
		
		public function loadGame(myUserId:int,allPlayerIds:Array/*int*/,xMax:int,yMax:int,serverEntries:Array/*ServerEntry*/):void
		{
			if(snakeGraphic != null)
				graphic.removeChild(snakeGraphic);
			moveGap = 0;
			this.myUserId = myUserId;	
			this.allPlayerIds = allPlayerIds;
			if(snakeSpeed > 0)
			{
				this.snakeSpeed = snakeSpeed;
				moveTick.delay = snakeSpeed;
			}
			
			var serverEntry:ServerEntry;
			var playerMove:PlayerMove;
			var playerMoves:Array = new Array();
			var playerFutureMoves:Array = new Array();
			var confirmedTick:Array = new Array;
			snakeMainPointer.tail = int.MAX_VALUE
			var tick:int = 0;
			for(var i:int = 0;i<serverEntries.length;i++)
			{
				serverEntry = serverEntries[i];
				if(serverEntry.value is PlayerMove)
				{
					playerMove = serverEntry.value as PlayerMove;
					if (confirmedTick[playerMove.tick] == undefined)
						confirmedTick[playerMove.tick] = 1 ;
					else
						confirmedTick[playerMove.tick] ++ ;
					if(confirmedTick[playerMove.tick] == allPlayerIds.length)
						if(tick<playerMove.tick)
							tick = playerMove.tick;	
					var splitKey:Array = String(serverEntry.key).split("-");
					if(Number(splitKey[0]) == myUserId)
					{	
						if(Number(splitKey[1]) > snakeMainPointer.head)
							snakeMainPointer.head = Number(splitKey[1]) + 1;
						if(Number(splitKey[1]) < snakeMainPointer.tail)
							snakeMainPointer.tail = Number(splitKey[1]) -1;
						if(snakeMainPointer.tick < (playerMove.tick +1))
							snakeMainPointer.tick = playerMove.tick + 1;
					}
				}
		
			}
			
			for(i = 0 ;i<allPlayerIds.length;i++)
			{	
				var tempPlayerMoves:Array = new Array();
				var tempPlayerFutureMoves:Array = new Array();
				for(var j:int = 0;j<serverEntries.length;j++)
				{
					serverEntry = serverEntries[j];
					if(serverEntry.value is PlayerMove)
					{
						playerMove = serverEntry.value as PlayerMove;
						if(playerMove.userId == allPlayerIds[i])
							if(playerMove.tick > tick )
								tempPlayerFutureMoves.push(playerMove);
							else
								tempPlayerMoves.push(playerMove);

						
					}
					
				}
				playerMoves[i] = tempPlayerMoves;
				playerFutureMoves[i] = tempPlayerFutureMoves;
			}


			allPlayerSnakes = new Array();
			interactionBoard= new InteractionBoard(allPlayerSnakes,myUserId,this);
			for(i = 0;i<allPlayerIds.length;i++)
			{
				var tempRealSnake:RealSnake = new RealSnake(i,allPlayerIds[i],xMax,yMax,playerMoves[i],playerFutureMoves[i],this);
				interactionBoard.addRealSnake(tempRealSnake,i);
				if(allPlayerIds[i] == myUserId)
					allPlayerSnakes[i]= new VirtualSnake(tempRealSnake,true,true);	
				else
					allPlayerSnakes[i]= new VirtualSnake(tempRealSnake,false,true);	
			}
			
			snakeGraphic = new SnakeGraphic(allPlayerSnakes,allPlayerIds);
			graphic.addChild(snakeGraphic);
			if(allPlayerIds.indexOf(myUserId) != -1)
				moveTick.start();
		}

	}
}
	import come2play_as3.snake.*;
	
class InteractionBoard
{
	private var allPlayerRealSnakes:Array/*RealSanke*/;
	private var allPlayerVirtualSnakes:Array/*VirtualSnake*/;
	private var snakeLogicPointer:SnakeLogic;
	public var myUserId:int
	public function InteractionBoard(allPlayerVirtualSnakes:Array,myUserId:int,snakeLogicPointer:SnakeLogic)
	{
		this.snakeLogicPointer = snakeLogicPointer;
		this.allPlayerVirtualSnakes = allPlayerVirtualSnakes;
		this.myUserId = myUserId;
		allPlayerRealSnakes =new Array();
	}
	
	public function addRealSnake(realSnake:RealSnake,pos:int):void
	{
		allPlayerRealSnakes[pos] = realSnake;
	}
	
	public function queueLength(playerNum:int):int
	{
		var realSnake:RealSnake = allPlayerRealSnakes[playerNum];
		if(realSnake == null)
			return 0
		else
			return realSnake.queueLength;
	}
	
	public function addMove(playerNum:int,playerMove:PlayerMove):void
	{
		var realSnake:RealSnake = allPlayerRealSnakes[playerNum];
		if(realSnake == null)
			return;
		realSnake.addMove(playerMove);
		for each(realSnake in allPlayerRealSnakes)
			if(realSnake.tick != playerMove.tick) return;

		var virtualSnake:VirtualSnake;
		for(var i:int = 0;i<allPlayerRealSnakes.length;i++)
		{
			realSnake = allPlayerRealSnakes[i];
			virtualSnake = allPlayerVirtualSnakes[i];
			
			virtualSnake.confirmMove(realSnake.cofirmMove());
		}
		
		testHits();
		snakeLogicPointer.printSnakes();
	}
	
	public function removeSnake(playerNum:int):void
	{
		allPlayerRealSnakes.splice(playerNum,1);
	}

	public function testHits():void
	{
		var playerSnake:RealSnake;
		var rivalSnake:RealSnake;
		var playerHead:SnakePart;
		var deadPlayers:Array = new Array;
		for(var i:int = 0;i<allPlayerRealSnakes.length;i++)
		{
			playerSnake =allPlayerRealSnakes[i];
			playerHead = playerSnake.getHead();
			if(playerHead != null)
			{
				for(var j:int = 0;j<allPlayerRealSnakes.length;j++)
				{
					rivalSnake = allPlayerRealSnakes[j];
					if(rivalSnake.hitMe(playerHead,j==i))
					{
						deadPlayers.push(playerSnake.userId);
						break;
					}
				}
			}
		}
		if(deadPlayers.length > 0)
			snakeLogicPointer.finishGame(deadPlayers);		
	}
	
}
