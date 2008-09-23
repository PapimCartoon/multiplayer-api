package come2play_as3.snake
{
	import come2play_as3.api.auto_generated.UserEntry;
	
	public class RealSnake
	{
		public var futureParts:Array;/*PlayerMove*/
		public var confirmedParts:Array;/*SnakePart*/
		public var snakeLogicPointer:SnakeLogic;
		public var playerNum:int;
		public var userId:int;
		public var xMax:int = 25;
		public var yMax:int = 25;
		private var snakeVector:String;
		public function RealSnake(playerNum:int,userId:int,xMax:int,yMax:int,confirmedPlayerMoves:Array/*PlayerMove*/,playerFutureMoves:Array/*PlayerMove*/,snakeLogicPointer:SnakeLogic)
		{
			if(xMax > 0)
				this.xMax = xMax;
			if(yMax > 0)	
				this.yMax = yMax;
			if(playerFutureMoves.length >0)
				futureParts = playerFutureMoves
			else
				futureParts = new Array();
			this.snakeLogicPointer = snakeLogicPointer;
			confirmedParts = new Array();
			for each(var playerMove:PlayerMove in confirmedPlayerMoves)
			{
				confirmedParts.unshift(SnakePart.create(playerMove.xpos,playerMove.ypos,playerMove.eating));
				snakeVector = playerMove.vector;
			}
			
			this.userId = userId;
			this.playerNum = playerNum;
			var i:int;
			
			if(confirmedParts.length ==0)
			{
				if(playerNum == 0)
				{
					for(i=0;i<4;i++)
					{
						snakeVector ="Down";
						confirmedParts.unshift(SnakePart.create(3,2+i,true));
					}
				}
				else if(playerNum == 1)
				{
					for(i=0;i<4;i++)
					{
						snakeVector ="Up";
						confirmedParts.unshift(SnakePart.create(23,24-i,true));
					}
				}
				else if(playerNum == 2)
				{
					for(i=0;i<4;i++)
					{
						snakeVector ="Up";
						confirmedParts.unshift(SnakePart.create(3,24-i,true));
					}
				}
				else if(playerNum == 3)
				{
					for(i=0;i<4;i++)
					{
						snakeVector ="Down";
						confirmedParts.unshift(SnakePart.create(23,2+i,true));
					}
				}	
			}
			
		}
		public function hitMe(testPart:SnakePart,isMe:Boolean):Boolean
		{
			var snakePart:SnakePart;
			if(!isMe)
			{
				snakePart = confirmedParts[0];
				if((testPart.xpos == snakePart.xpos) && (testPart.ypos == snakePart.ypos))
					return true;
			}
			for(var i:int = 1;i<confirmedParts.length;i++)
			{
				snakePart = confirmedParts[i];
				if((testPart.xpos == snakePart.xpos) && (testPart.ypos == snakePart.ypos))
					return true;
			}	
				return false;	
		}
		public function addMove(playerMove:PlayerMove):void
		{
			futureParts.push(playerMove);
		}
		public function cofirmMove():PlayerMove
		{
			var playerMove:PlayerMove = futureParts[0];
			var lastPlayerSnake:SnakePart = confirmedParts[0];
			
			if ( (Math.abs((playerMove.xpos - lastPlayerSnake.xpos)%xMax) > 1) || (Math.abs((playerMove.ypos - lastPlayerSnake.ypos) %yMax) > 1))
				snakeLogicPointer.foundHacker(playerMove.userId,"("+playerMove.ypos+ " - " +lastPlayerSnake.ypos+") ilegal move ( " +playerMove.xpos+ " - "+ lastPlayerSnake.xpos+")");
			confirmedParts.unshift(SnakePart.create(playerMove.xpos,playerMove.ypos,playerMove.eating));
			futureParts.shift();
			if(!playerMove.eating)
				confirmedParts.pop();
			return playerMove;
		}
		public function get tick():int
		{
			if(futureParts.length > 0)
			{
				var playerMove:PlayerMove = futureParts[0]
				return playerMove.tick;
			}
			else
				return -1;
		}
		
		public function set vector(snakeVector:String):void
		{
			if((snakeVector == "Right") && (this.snakeVector == "Left")) return;
			if((snakeVector == "Left") && (this.snakeVector == "Right")) return;
			if((snakeVector == "Up") && (this.snakeVector == "Down")) return;
			if((snakeVector == "Down") && (this.snakeVector == "Up")) return;
			this.snakeVector = snakeVector;
		}
		public function get vector():String
		{
			return snakeVector;
		}
		public function getStartingSnake():Array/*UserEntry*/
		{
			var i:int = 3;
			var userEntries:Array/*UserEntry*/ = new Array();
			for each(var snakePart:SnakePart in confirmedParts)
			{
				userEntries.unshift( UserEntry.create(userId+"-"+i--,PlayerMove.createFromSnakePart(snakePart,snakeVector,userId),false));
			}
			return userEntries;
		}
		public function getHead():SnakePart{return confirmedParts[0];}
		public function get queueLength():int{return futureParts.length;}

	}
}