package come2play_as3.hitTheNumber
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.ClientGameAPI;
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.RevealEntry;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	
	import flash.display.MovieClip;

	public class HitTheNumberMain extends ClientGameAPI
	{
		public var userId:int;
		public var enemyId:int;
		public var gameLogic:HitTheNumberLogic;
		public var gameGraphic:HitTheNumberGraphicImp;
		public var enemyReady:Boolean;
		public var meReady:Boolean;
		public var allPlayerIds:Array;
		
		public var singlePlayer:Boolean;
		
		public function HitTheNumberMain(someMovieClip:MovieClip)
		{
			super(someMovieClip);
			AS3_vs_AS2.waitForStage(someMovieClip,constructGame);
			gameLogic = new HitTheNumberLogic();
			gameGraphic = new HitTheNumberGraphicImp();
			someMovieClip.addChild( gameGraphic );
			
		}
		
		private function constructGame():void
		{
			doRegisterOnServer();
		}
		
		override public function gotCustomInfo(infoEntries:Array):void
		{
			this.userId = T.custom( CUSTOM_INFO_KEY_myUserId, null ) as int; 
		}
		
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			trace("got match started");
			this.allPlayerIds = allPlayerIds;
			enemyReady = false;
			meReady = false;		
			if ( allPlayerIds.length == 1) singlePlayer = true;
			else singlePlayer = false;	
			gameLogic.PickNumber();
			gameGraphic.ShowNumber( gameLogic.num );
			doAllRequestRandomState("secretNumber",true );
			
			for each ( var playerId:int in allPlayerIds)
			{
				if ( playerId != userId ) enemyId = playerId;
			}
		} 
		
		override public function gotStateChanged(serverEntries:Array):void
		{
			var serverEntry:ServerEntry = serverEntries[0] ;
			
			if ( serverEntries.length == 1 )
			{	
				if ( serverEntry.key == "secretNumber" )
				{
					StoreNumber();
				} else
				if ( serverEntry.key == enemyId )
				{
					enemyReady = true;
				} else
				if ( serverEntry.key == userId )
				{
					meReady = true;
				}
				
				if ( meReady && enemyReady )
				{
					RevealAllNumbers();
				}
			} else		//REVEAL NUMBERS AND END GAME
			{
				for each ( serverEntry in serverEntries )
				{
					if ( serverEntry.key == enemyId )
					{
						gameLogic.SetEnemyNum( serverEntry.value );
					} else
					if ( serverEntry.key == "secretNumber" )
					{
						gameLogic.SetSecretNum( serverEntry.value % 10 + 1 );
						gameGraphic.ShowSecretNumber( gameLogic.secret_num );
					}
				}
				
				EndGame();
			}
			
		}
		
		public function StoreNumber():void
		{
			doStoreState( [ UserEntry.create( userId, gameLogic.num, true ) ] );
			
			if ( singlePlayer )
			{
				gameLogic.PickEnemyNumber();
				enemyReady = true;
			}
		}
		
		public function RevealAllNumbers():void
		{
			var revealEntries:Array;
			
			if ( singlePlayer )
			{
				doAllRevealState( [ RevealEntry.create( "secretNumber"), RevealEntry.create(allPlayerIds[0])] );
			} else
			{
				doAllRevealState( [ RevealEntry.create( "secretNumber"), RevealEntry.create(allPlayerIds[0]), RevealEntry.create(allPlayerIds[1]) ] );
			}
		}
		
		public function EndGame():void
		{
			var playerMatchOverArr:Array = new Array();
			
			if ( singlePlayer )
			{
				playerMatchOverArr =  [PlayerMatchOver.create( userId, 100, 100 )] ;
				
			} else
			{
				switch ( gameLogic.Win() )
				{
					case HitTheNumberLogic.WIN: playerMatchOverArr = [ PlayerMatchOver.create( userId, 100, 100 ), PlayerMatchOver.create( enemyId, 0, 0 )] ;
					break;
						
					case HitTheNumberLogic.LOOSE: playerMatchOverArr =  [ PlayerMatchOver.create( enemyId, 100, 100 ), PlayerMatchOver.create( userId, 0, 0 )] ;
					break;
						
					case HitTheNumberLogic.TIE: playerMatchOverArr =   [ PlayerMatchOver.create(allPlayerIds[0], 50, 50), PlayerMatchOver.create(allPlayerIds[1], 50, 50) ] ;
					break;
				}
			}
			
			doAllEndMatch ( playerMatchOverArr );
			
		}
		
	}
}