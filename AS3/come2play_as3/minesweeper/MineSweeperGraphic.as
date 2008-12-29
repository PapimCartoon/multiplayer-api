package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.API_Message;
	
	import flash.display.MovieClip;
	import flash.events.Event;
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
			
			if(T.custom(API_Message.CUSTOM_INFO_KEY_isBack,false) as Boolean)
			{
				
				
				box.gotoAndStop(30+playerNum*10);
				box.addEventListener(Event.ENTER_FRAME,function(ev:Event):void{stopBoom(box);});
			}
			else
			{
				box.mouseChildren = false;
				box.gotoAndStop(30+playerNum*10);
				if(boomSound != null)
					removeChild(boomSound);
				boomSound = new BoomSound()
				addChild(boomSound);
			}
		}
		private function stopBoom(box:Box):void{
			if(box.Boom != null)
				box.Boom.gotoAndStop(61);
			else
				setTimeout(function():void{stopBoom(box);},10);
		}
		public function revealBox(playerNum:int,borderingMines:int,xPos:int,yPos:int,isCorrect:Boolean):void
		{
			var box:Box = boardBricks[xPos][yPos];
			box.gotoAndStop(10*(playerNum+1) + borderingMines);
			if((!isCorrect) && (!(T.custom(API_Message.CUSTOM_INFO_KEY_isBack,false) as Boolean))){
				if(mineNotFoundSound != null)
					removeChild(mineNotFoundSound);
				mineNotFoundSound = new MineNotFoundSound()
				addChild(mineNotFoundSound);
			}
			setTimeout(function():void{isCorrectChange(isCorrect,box)},10);
			
		}
		private function isCorrectChange(isCorrect:Boolean,box:Box):void
		{
			if(box.isWrong != null)
				box.isWrong.alpha = isCorrect?0:100;
			else
				setTimeout(function():void{isCorrectChange(isCorrect,box)},10);
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
		
		
		public function makeBoard(width:int,height:int,allPlayerIds:Array/*int*/,isPlayer:Boolean):void
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
					tempBox.width = tempBox.height = MineSweeperMain.squareSize;
					tempBox.x = i*MineSweeperMain.squareSize + 9.5;
					tempBox.y = j*MineSweeperMain.squareSize + 7;
					if( (!isPlayer) || ( (T.custom(API_Message.CUSTOM_INFO_KEY_isBack,false) as Boolean)))
						tempBox.frameBtn.enabled = false;
					boardBricks[i][j]=tempBox;
					boardUnderPart.addChild(boardBricks[i][j]);
				}
			}
			for (i=0;i<allPlayerIds.length;i++){
				var userId:int = allPlayerIds[i];
				playerGraphicDataArr[i]=new PlayerGraphicData(i,T.getUserValue(userId,API_Message.USER_INFO_KEY_name,"player "+userId) as String);
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
				if(contains(playerLives[i]))
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