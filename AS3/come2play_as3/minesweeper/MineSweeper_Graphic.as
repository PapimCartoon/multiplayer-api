package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_generated.InfoEntry;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class MineSweeper_Graphic extends MovieClip
	{
		private var boardBricks:Array;
		private var playerLives:Array;
		private var playerText:Array;
		private var board:MovieClip;
		public function MineSweeper_Graphic()
		{
			board=new MovieClip();
		}
		
		public function foundMine(xPos:int,yPos:int,isPlayer:Boolean):void
		{
			var box:Box = boardBricks[xPos][yPos];
			if(isPlayer)
				box.gotoAndStop(44);
			else
				box.gotoAndStop(55);
		}
		public function setOfMine(xPos:int,yPos:int,isPlayer:Boolean):void
		{
			var box:Box = boardBricks[xPos][yPos];
			addChild(box);
			if(isPlayer)
				box.gotoAndStop(20);
			else
				box.gotoAndStop(31);
		}
		public function revealBox(borderingMines:int,xPos:int,yPos:int):void
		{
			var box:Box = boardBricks[xPos][yPos];
			box.gotoAndStop(10 + borderingMines);
		}
		public function updateLives(playerNum:int,livesCount:int):void
		{
			for(var i:int=0;i<3;i++)
			{
				board.addChild(playerLives[playerNum][i]);
				if(livesCount< (i+1))
					board.removeChild(playerLives[playerNum][i])

			}	
		}
		
		
		
		public function buildBoard(width:int,height:int,users:Array):void
		{
			if (contains(board))
				removeChild(board);
			board=new MovieClip();
			addChild(board);
			boardBricks=new Array()
			
			for(var i:int=0;i<width;i++)
			{
				boardBricks[i] = new Array();
				for(var j:int = 0;j<height;j++)
				{
					var tempBox:Box =new Box()
					tempBox.stop();
					tempBox.x = i*16 + 9.5;
					tempBox.y = j*16 + 7;
					boardBricks[i][j]=tempBox;
					board.addChild(boardBricks[i][j]);
				}
			}
			
			
			playerText = new Array();
			playerLives = new Array();
			for(i=0;i<users.length;i++)
			{
				playerLives[i]=new Array();
				for(j=0;j<3;j++)
				{
					var playerLife:PlayerLife = new PlayerLife();
					playerLife.gotoAndStop(i+1);
					playerLife.x = 250 + j * 35;
					playerLife.y = 5 + i * 50;
					playerLives[i][j] = playerLife;
				}	
				var tempTextField:TextField = new TextField()
				var userObj:Object = users[i];
				for each(var infoEntry:InfoEntry in userObj.entries)
					if(infoEntry.key == "name")
					{
						tempTextField.text = String(infoEntry.value);
						break;
					}
				tempTextField.selectable= false;
				tempTextField.x = 250
				tempTextField.y = 35 + i * 50
				playerText[i] = tempTextField;
				board.addChild(playerText[i]);
				updateLives(i,3);
			}
			
		}

	}
}