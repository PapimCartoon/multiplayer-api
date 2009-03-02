package ticktactoeTuturial
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class TickTacToeTuturialGraphic extends MovieClip
	{
		private var BoardMc:MovieClip;
		private var board:Array/*TickTacToeTuturialSquare*/;
		private var logoBackGrounds:Array/*Loader*/;
		private var logoUrl:String;
		private var loadedBackgrounds:int;
		private var userAvatarsArray:Array;/*Array*/
		public function TickTacToeTuturialGraphic()
		{
		}
		/**
		*Refreshes the board for a new game
		*
		*/
		private function refreshBoard():void
		{
			if(BoardMc !=null)
				if(contains(BoardMc))
					removeChild(BoardMc);
			BoardMc = new MovieClip();
		}
		/**
		*Loads an image to a specific loader
		*
		*@param url the url of the image to load
		*@param loader were to load the image to
		*@param callbackFunction the function to call after loading the image
		*/
		private function loadBackImage(url:String,loader:Loader,callbackFunction:Function):void
		{
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,callbackFunction);
			loader.load(new URLRequest(url));
		}
		/**
		*Loads an avatar for each game square
		*
		*@param avatarUrl the url of the avatar
		*@param userIdex the index of the user the avatar is associated with
		*/
		private function loadAvatarBoard(avatarUrl:String,userIdex:int):void
		{
			for(var i:int = 2;i<=9;i++)
			{
				var tempLoader:Loader = new Loader();
				tempLoader.load(new URLRequest(avatarUrl));
				userAvatarsArray[userIdex][i] = tempLoader;
			}
			
		}	
		/**
		*Loads the logo for all the game squares as a background
		*
		*@param avatarUrl the url of the avatar
		*@param userIdex the index of the user the avatar is associated with
		*/
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
		/**
		*Commits a game move graphicly
		*
		*@param gameMove a TickTacToeMove class representing a player move
		*/
		public function makeTurn(gameMove:TickTacToeMove):void
		{
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
		/**
		*Loads an avatar for a specific user
		*
		*@param avatarUrl the url of the avatar
		*@param userIndex the index of the user the avatar is associated with
		*/
		private function loadAvatarForUser(avatarUrl:String,userIndex:int):void
		{
				userAvatarsArray[userIndex] =new Array()
				userAvatarsArray[userIndex][1] = new Loader();		
				loadBackImage(avatarUrl,userAvatarsArray[userIndex][1], function ():void {loadAvatarBoard(avatarUrl,userIndex);} );	
		}
		/**
		*Creates a new board with logos and avatars
		*
		*@param logoUrl url of game logo
		*@param userAvatars an array of urls of user avatars
		*/
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
					if(logoBackGrounds != null)	
					{
						tempSquare.background_mc.addChild(logoBackGrounds[j+(i-1)*3]);
						var frameSquare:Sprite = new Sprite();
						frameSquare.graphics.lineStyle(1,0x000000);
						frameSquare.graphics.drawRect(0,0,100,100);
						tempSquare.addChild(frameSquare);
					}
					tempSquare.x = (i-1)*100
					tempSquare.y = (j-1)*100
					board[i][j] = tempSquare	
					BoardMc.addChild(board[i][j]);
				}
			}
			addChild(BoardMc);
		}
		
	}
}