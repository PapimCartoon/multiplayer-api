package come2play_as3.snake
{
	import flash.display.MovieClip;
	
	public class SnakeGraphic extends MovieClip
	{
		private var allPlayerGraphicSnakes:Array/*GraphicSnake*/;
		private var allPlayerIds:Array/*int*/;
		private var foodCube:Food;
		public function SnakeGraphic(allPlayerSnakes:Array/*PlayerSnake*/,allPlayerIds:Array/*int*/)
		{
			this.allPlayerIds = allPlayerIds;
			allPlayerGraphicSnakes = new Array();
			foodCube = new Food();
			for each(var playerSnake:VirtualSnake in allPlayerSnakes)
			{
				var tempGraphicSnake:GraphicSnake = new GraphicSnake(playerSnake.playerNum)
				tempGraphicSnake.updateSnake(playerSnake.getConfirmedParts(),playerSnake.getUnConfirmedParts());
				allPlayerGraphicSnakes.push(tempGraphicSnake);
				addChild(tempGraphicSnake);
			}
		}
		public function printSnake(confirmedMoves:Array,unconfirmedMoves:Array,userId:int):void
		{
			var pos:int = allPlayerIds.indexOf(userId);
			var playerGraphicSnake:GraphicSnake = allPlayerGraphicSnakes[pos];
			playerGraphicSnake.updateSnake(confirmedMoves,unconfirmedMoves);
		}
		public function removeSnake(pos:int):void
		{
			removeChild(allPlayerGraphicSnakes[pos]);
			allPlayerGraphicSnakes.splice(pos,1);
		}
		public function putFoodCube(xpos:int,ypos:int):void
		{
			foodCube.x = xpos * 16;
			foodCube.y = ypos * 16;
			addChild(foodCube);
		}

	}
}




	import flash.display.MovieClip;
	import come2play_as3.snake.SnakePart;
	

class GraphicSnake extends MovieClip 
{
	private var snake:Array;/*SquareExample*/
	private var playerNum:int;
	public function GraphicSnake(playerNum:int)
	{
		this.playerNum = playerNum;
		snake = new Array();
	}
	public function updateSnake(confirmedMoves:Array,unconfirmedMoves:Array):void
	{
		while(snake.length > 0)
			removeChild(snake.pop());
		for each(var tempSnakePart:SnakePart in unconfirmedMoves)
			addSnakePart(tempSnakePart,true);
		
		for each(tempSnakePart in confirmedMoves)
			addSnakePart(tempSnakePart,false);
	}
	
	private function addSnakePart(snakePart:SnakePart,guess:Boolean):void
	{
		var tempSquare:SquareExample = new SquareExample();
		tempSquare.x = snakePart.xpos * 16;
		tempSquare.y = snakePart.ypos * 16;
		if(guess)
			tempSquare.gotoAndStop("player_"+playerNum+"_guess");
		else
			tempSquare.gotoAndStop("player_"+playerNum+"_sure");
		snake.push(tempSquare);	
		addChild(tempSquare);
	}

}
