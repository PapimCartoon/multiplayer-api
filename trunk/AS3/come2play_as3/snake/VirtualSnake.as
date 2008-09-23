package come2play_as3.snake
{
	public class VirtualSnake
	{
		//private var realSnake:RealSnake;
		private var confirmedSnakeParts:Array;/*SnakePart*/
		private var guessedSnakeParts:Array;/*SnakePart*/
		private var snakeVector:String;
		private var isPlayer:Boolean;
		public var userId:int;
		public var playerNum:int;
		private var xMax:int;
		private var yMax:int;
		private var skipThis:Boolean;
		public function VirtualSnake(realSnake:RealSnake,isPlayer:Boolean,isLoaded:Boolean)
		{
			//this.realSnake = realSnake;
			confirmedSnakeParts = realSnake.confirmedParts.concat();
			userId = realSnake.userId;
			playerNum = realSnake.playerNum;
			xMax =realSnake.xMax;
			yMax =realSnake.yMax;
			snakeVector = realSnake.vector;
			
			this.isPlayer =isPlayer;
			guessedSnakeParts = new Array();
			
			if(isLoaded)
			{
				for each(var playerMove:PlayerMove in realSnake.futureParts)
				{
					guessedSnakeParts.unshift(SnakePart.create(playerMove.xpos,playerMove.ypos,playerMove.eating));
				}	
			}
		}
		public function confirmMove(playerMove:PlayerMove):void
		{
				var oldestGuessedMove:SnakePart = guessedSnakeParts.pop();
				if(oldestGuessedMove == null)
				{
					confirmedSnakeParts.unshift(SnakePart.create(playerMove.xpos,playerMove.ypos,playerMove.eating));
					if(!playerMove.eating)
						if(confirmedSnakeParts.length > 0)
							confirmedSnakeParts.pop();
						else if(guessedSnakeParts.length > 0)
							guessedSnakeParts.pop();
					skipThis = true;
				}
				else
				{
					if((oldestGuessedMove.xpos != playerMove.xpos) || (oldestGuessedMove.ypos != playerMove.ypos))
					{
						var confirmedMove:SnakePart = SnakePart.create(playerMove.xpos,playerMove.ypos,playerMove.eating);
						confirmedSnakeParts.unshift(confirmedMove);
						snakeVector = playerMove.vector;
						var guessedMoveLength:int = guessedSnakeParts.length;
						guessedSnakeParts = new Array();
						for(var i:int = 0;i<guessedMoveLength;i++)
							moveForward(true);
					}
					else
					{
						confirmedSnakeParts.unshift(oldestGuessedMove);
					}
				}
			//todo: confirm move from real snake
		}
		public function moveForward(isEating:Boolean):PlayerMove
		{
			if(skipThis)
			{
				skipThis = false;
				return null;	
			}
			var head:SnakePart;
			var tempSnakePart:SnakePart;
			
			if(guessedSnakeParts.length > 0)
				head = guessedSnakeParts[0]
			else
				head = confirmedSnakeParts[0];
			if(snakeVector == "Right")
				tempSnakePart = SnakePart.create(head.xpos + 1,head.ypos,isEating);
			else if(snakeVector == "Left")
				tempSnakePart = SnakePart.create(head.xpos - 1,head.ypos,isEating);
			else if(snakeVector == "Down")
				tempSnakePart = SnakePart.create(head.xpos,head.ypos + 1,isEating);
			else if(snakeVector == "Up")
				tempSnakePart = SnakePart.create(head.xpos,head.ypos - 1,isEating);
				
			if(tempSnakePart.xpos > xMax)
				tempSnakePart.xpos=0;
			if(tempSnakePart.xpos < 0)
				tempSnakePart.xpos=xMax;				
			if(tempSnakePart.ypos > yMax)
				tempSnakePart.ypos=0;
			if(tempSnakePart.ypos < 0)
				tempSnakePart.ypos=yMax;
			guessedSnakeParts.unshift(tempSnakePart);
			if(!isEating)
			{
				if(confirmedSnakeParts.length >0)	
					confirmedSnakeParts.pop();
				else
					guessedSnakeParts.pop();
			}
			
			return PlayerMove.createFromSnakePart(tempSnakePart,snakeVector,userId);
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
		public function getConfirmedParts():Array/*SnakePart*/{return confirmedSnakeParts.concat();}
		public function getUnConfirmedParts():Array/*SnakePart*/{return guessedSnakeParts.concat();}
	}
}