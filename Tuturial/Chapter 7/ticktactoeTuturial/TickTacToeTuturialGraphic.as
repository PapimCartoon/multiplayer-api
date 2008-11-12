package ticktactoeTuturial
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class TickTacToeTuturialGraphic extends MovieClip
	{
		private var oldMoves:Array/*TickTacToeMove*/
		private var boardAvaible:Boolean;
		private var BoardMc:MovieClip;
		private var board:Array/*TickTacToeTuturialSquare*/;
		private var logoBackGrounds:Array/*Loader*/;
		private var logoUrl:String;
		private var loadedBackgrounds:int;
		private var userAvatarsArray:Array;/*Array*/
		private var _gameWidth:int;
		private var _gameHeight:int;
		private var mainPointer:TickTacToeTuturialMain;
		public function TickTacToeTuturialGraphic()
		{
			oldMoves = new Array();
			this.mainPointer = mainPointer;
		}
		private function isBoardAvaible(isAvailable:Boolean):void
		{
			if(isAvailable)
			{
				boardAvaible = true;
				for each(var gameMove:TickTacToeMove in oldMoves)
				{
					makeTurn(gameMove);
				}
				oldMoves = new Array();
					
			}
			else
				boardAvaible = false;
		}
		private function refreshBoard():void
		{
			isBoardAvaible(false);
			if(BoardMc !=null)
				if(contains(BoardMc))
					removeChild(BoardMc);
			BoardMc = new MovieClip();
		}
		private function loadBackImage(url:String,loader:Loader,callbackFunction:Function):void
		{
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,callbackFunction);
			loader.load(new URLRequest(url));
		}
		private function loadAvatarBoard(avatarUrl:String,userIdex:int):void
		{
			for(var i:int = 2;i<=9;i++)
			{
				var tempLoader:Loader = new Loader();
				tempLoader.load(new URLRequest(avatarUrl));
				userAvatarsArray[userIdex][i] = tempLoader;
			}
			
		}	
		private function doneLoadingLogo(ev:Event):void
		{
			var tempLoader:Loader = logoBackGrounds[loadedBackgrounds];	
			loadedBackgrounds ++
			tempLoader.width = 100;
			tempLoader.height = 100;
			
			if(loadedBackgrounds == 10)	
				createNewBoard("",null);
			else
			{
				logoBackGrounds[loadedBackgrounds] = new Loader()
				loadBackImage(logoUrl,logoBackGrounds[loadedBackgrounds],doneLoadingLogo);
			}
		}
		public function makeTurn(gameMove:TickTacToeMove):void
		{
			if(!boardAvaible)
			{
				oldMoves.push(gameMove);
				return;
			}
			var tempSquare:TickTacToeTuturialSquare = board[gameMove.xPos][gameMove.yPos];
			if(userAvatarsArray[gameMove.playerTurn - 1] !=null)
			{
				var tempLoader:Loader = userAvatarsArray[gameMove.playerTurn - 1][(gameMove.xPos-1)*3+gameMove.yPos];
				tempLoader.width = 100;
				tempLoader.height = 100;
				tempSquare.addChildAt(tempLoader,1)

			}
			else
			{
				if(gameMove.playerTurn == 1)
					tempSquare.gotoAndStop("Tick");
				else if(gameMove.playerTurn == 2)
					tempSquare.gotoAndStop("Tac");
				else if(gameMove.playerTurn == 3)
					tempSquare.gotoAndStop("Toe");
			}
		}
		private function loadAvatarForUser(avatarUrl:String,userIndex:int):void
		{
				userAvatarsArray[userIndex] =new Array()
				userAvatarsArray[userIndex][1] = new Loader();		
				loadBackImage(avatarUrl,userAvatarsArray[userIndex][1], function ():void {loadAvatarBoard(avatarUrl,userIndex);} );	
		}
		public function createNewBoard(logoUrl:String,userAvatars:Array/*String*/):void
		{
			var i:int;
			
			if(this.logoUrl == null)
			{
				this.logoUrl = logoUrl;
				loadedBackgrounds = 1;
				logoBackGrounds = new Array();
				logoBackGrounds[1] = new Loader()
				loadBackImage(logoUrl,logoBackGrounds[1],doneLoadingLogo);
				
				userAvatarsArray = new Array();
				for(i =0;i< userAvatars.length;i++)
				{	
					loadAvatarForUser(userAvatars[i],i);
				}
				return;
			}
			refreshBoard()
			board = new Array()
			var tempSquare:TickTacToeTuturialSquare;
			for(i = 1;i<=3;i++)
			{
				board[i] = new Array();
				for(var j:int = 1;j<=3;j++)
				{
					tempSquare = new TickTacToeTuturialSquare();
					tempSquare.stop();
					tempSquare.width = _gameWidth;
					tempSquare.height = _gameHeight;
					if(logoBackGrounds != null)	
					{
						tempSquare.background_mc.addChild(logoBackGrounds[j+(i-1)*3]);
						var frameSquare:Sprite = new Sprite();
						frameSquare.graphics.lineStyle(1,0x000000);
						frameSquare.graphics.drawRect(0,0,100,100);
						tempSquare.addChild(frameSquare);
					}
					tempSquare.x = (i-1)*_gameWidth
					tempSquare.y = (j-1)*_gameHeight
					board[i][j] = tempSquare	
					BoardMc.addChild(board[i][j]);
				}
			}
			addChild(BoardMc);
			isBoardAvaible(true);
		}
		public function set gameWidth(gameWidth:int):void{_gameWidth = gameWidth;}
		public function set gameHeight(gameHeight:int):void{_gameHeight = gameHeight;}
	}
}