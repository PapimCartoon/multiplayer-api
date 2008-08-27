package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_generated.InfoEntry;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class MineSweeper_Graphic extends MovieClip
	{
		private var boardBricks:Array;
		
		private var playerGraphicDataArr:Array;
		public function MineSweeper_Graphic()
		{
			playerGraphicDataArr = new Array();
		}
		
		public function foundMine(xPos:int,yPos:int,playerNum:int):void
		{
			var box:Box = boardBricks[xPos][yPos];
				box.gotoAndStop(44+playerNum*11);
		}
		public function setOfMine(xPos:int,yPos:int,playerNum:int):void
		{
			var box:Box = boardBricks[xPos][yPos];
			addChild(box);
				box.gotoAndStop(20+playerNum*10);
		}
		public function revealBox(borderingMines:int,xPos:int,yPos:int):void
		{
			var box:Box = boardBricks[xPos][yPos];
			box.gotoAndStop(10 + borderingMines);
		}
		public function updateLives(playerNum:int,livesCount:int):void
		{
			var player:PlayerGraphicData = playerGraphicDataArr[playerNum];
			for(var i:int=0;i<3;i++)
			{
				addChild(player.playerLives[i]);
				if(livesCount < (i+1))
					removeChild(player.playerLives[i])
			}	
		}
		public function updateScore(playerNum:int,Score:int):void
		{
			var player:PlayerGraphicData = playerGraphicDataArr[playerNum];
			player.playerText.text = player.playerName + " : " + Score;
	
		}
		
		
		public function buildBoard(width:int,height:int,players:Array):void
		{
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
					addChild(boardBricks[i][j]);
				}
			}
			
			
			for(i=0;i<players.length;i++)
			{
				var playerObj:Object = players[i];
				for each(var infoEntry:InfoEntry in playerObj.entries)
					if(infoEntry.key == "name")
					{
						var tempName:String = String(infoEntry.value);
						break;
					}
				playerGraphicDataArr[i]=new PlayerGraphicData(i,tempName);
				addChild(playerGraphicDataArr[i]);	
				updateLives(i,3);
			}
			
		}
		public function loadBoard(width:int,height:int,players:Array,loadBoard:Array):void
		{
			boardBricks=new Array()
			for(var i:int=0;i<width;i++)
			{
				boardBricks[i] = new Array();
				for(var j:int = 0;j<height;j++)
				{
					var tempBox:Box =new Box()
					tempBox.x = i*16 + 9.5;
					tempBox.y = j*16 + 7;
					if(loadBoard[i][j] is PlayerBox)
					{
						var playerBox:PlayerBox =loadBoard[i][j];
						if(!playerBox.isMine)
							tempBox.gotoAndStop(playerBox.borderingMines + 10);
						else
							if(playerBox.isMineFound)
							{
								tempBox.gotoAndStop(20+playerBox.takingPlayer * 10);
							}
							else
							{
								tempBox.gotoAndStop(44+playerBox.takingPlayer * 11);
							}

					}
					else
					{
						tempBox.stop();	
					}
					
					boardBricks[i][j]=tempBox;
					addChild(boardBricks[i][j]);
				}
			}
			
			
			for(i=0;i<players.length;i++)
			{
				var playerObj:Object = players[i];
				for each(var infoEntry:InfoEntry in playerObj.entries)
					if(infoEntry.key == "name")
					{
						var tempName:String = String(infoEntry.value);
						break;
					}
				playerGraphicDataArr[i]=new PlayerGraphicData(i,tempName);
				addChild(playerGraphicDataArr[i]);	
				updateLives(i,3);
			}
			
		}		
		

	}
}
	import flash.display.MovieClip;
	import flash.text.TextField;
	
class PlayerGraphicData extends MovieClip
{
	public var playerLives:Array;
	public var playerText:TextField;
	public var playerName:String;	
	public function PlayerGraphicData(num:int,name:String):void
	{
		playerName= name;
		playerLives = new Array();
		playerText = new TextField();
		playerText.text = name+" : 0";
		playerText.selectable = false;
		addChild(playerText);
		playerText.x = 250
		playerText.y = 35 + num * 50
		for(var i:int=0;i<3;i++)
		{
			var playerLife:PlayerLife = new PlayerLife();
			playerLife.gotoAndStop(num+1);
			playerLife.x = 250 + i * 35;
			playerLife.y = 5 + num * 50;
			playerLives[i] = playerLife;
		}	
			
	}
}