package come2play_as3.minesweeper
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	public class MineSweeperGraphic extends MovieClip
	{
		private var boardUnderPart:MovieClip;
		private var boardBricks:Array;
		private var playerGraphicDataArr:Array;
		private var boomSound:BoomSound;
		private var mineNotFoundSound:MineNotFoundSound;
		
		public function MineSweeperGraphic()
		{
			
		}
		
		public function foundMine(playerNum:int,xPos:int,yPos:int):void
		{
			var box:Box = boardBricks[xPos][yPos];
			box.gotoAndStop(54+playerNum*11);
		}
		public function setOfMine(playerNum:int,xPos:int,yPos:int):void
		{
			var box:Box = boardBricks[xPos][yPos];
			boardUnderPart.addChild(box);
			box.gotoAndStop(30+playerNum*10);
			if(boomSound != null)
				removeChild(boomSound);
			boomSound = new BoomSound()
			addChild(boomSound);
		}
		public function revealBox(playerNum:int,borderingMines:int,xPos:int,yPos:int,isCorrect:Boolean):void
		{
			var box:Box = boardBricks[xPos][yPos];
			box.gotoAndStop(10*(playerNum+1) + borderingMines);
			if(!isCorrect){
				if(mineNotFoundSound != null)
					removeChild(mineNotFoundSound);
				mineNotFoundSound = new MineNotFoundSound()
				addChild(mineNotFoundSound);
			}
			setTimeout(function():void{isCorrectChange(isCorrect,box)},200);
			
		}
		private function isCorrectChange(isCorrect:Boolean,box:Box):void
		{
			box.isWrong.alpha = isCorrect?0:100;
		}
		public function updateLives(playerNum:int,livesCount:int):void
		{
			var player:PlayerGraphicData = playerGraphicDataArr[playerNum];
			player.updateLives(livesCount);
			/*for(var i:int=0;i<3;i++)
			{
				boardUnderPart.addChild(player.playerLives[i]);
				if(livesCount < (i+1))
					boardUnderPart.removeChild(player.playerLives[i])
			}	*/
		}
		public function updateScore(playerNum:int,Score:int):void
		{
			var player:PlayerGraphicData = playerGraphicDataArr[playerNum];
			player.playerText.text = player.playerName + " : " + Score;
	
		}
		
		
		public function makeBoard(width:int,height:int,players:Array,isPlayer:Boolean):void
		{
			if(boardUnderPart != null)
				removeChild(boardUnderPart);
			boardUnderPart = new MovieClip();
			
			playerGraphicDataArr = new Array();
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
					if(!isPlayer)
						tempBox.frameBtn.enabled = false;
					boardBricks[i][j]=tempBox;
					boardUnderPart.addChild(boardBricks[i][j]);
				}
			}
			
			
			for(i=0;i<players.length;i++)
			{
				var playerObj:Object = players[i];
				playerGraphicDataArr[i]=new PlayerGraphicData(i,playerObj.name);
				boardUnderPart.addChild(playerGraphicDataArr[i]);	
				updateLives(i,3);
			}
			addChild(boardUnderPart)
			
		}		

	}
}
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
class PlayerGraphicData extends MovieClip
{
	public var playerLives:Array;
	public var playerText:TextField;
	public var playerName:String;	
	private var currentLives:int;
	private var liveUpSound:LiveUpSound;
	private var lifeUpTimer:Timer;
	public function PlayerGraphicData(num:int,name:String):void
	{
		lifeUpTimer = new Timer(1000,0);
		lifeUpTimer.addEventListener(TimerEvent.TIMER,flicker);
		if(name.length > 10)
			name = name.substr(0,10);
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
			addChild(playerLife);
		}	
		currentLives = 3;			
	}
	public function updateLives(newLives:int):void
	{
		trace("newLivesnewLivesnewLives"+newLives)
		if(newLives < currentLives)
		{
			for(var i:int =(currentLives-1);i>=newLives;i-- )
			{
				removeChild(playerLives[i]);
			}
		}
		else if(newLives != currentLives)
			addLife(currentLives)
		currentLives = newLives;
	}
	private function addLife(lifeCount:int):void
	{
		if(liveUpSound != null)
			removeChild(liveUpSound)
		liveUpSound = new LiveUpSound();
		addChild(liveUpSound);
		lifeUpTimer.delay = 100;
		lifeUpTimer.start();
	}
	private function flicker(ev:TimerEvent):void
	{
		var life:PlayerLife = playerLives[currentLives -1];
		if(contains(life))
			removeChild(life)
		else
		{
			lifeUpTimer.delay -= 10;
			if(lifeUpTimer.delay<30)
				lifeUpTimer.stop();
			addChild(life);
		}
	}
}