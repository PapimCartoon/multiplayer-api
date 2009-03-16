package come2play_as3.BlackJack
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.cards.CardsAPI;
	import come2play_as3.cards.events.GraphicButtonClickEvent;
	
	import flash.display.MovieClip;

	public class BlackJackMain extends CardsAPI
	{
		private var blackJackGraphic:BlackJackGraphic;
		private var allPlayerIds:Array;
		public function BlackJackMain(graphics:MovieClip)
		{
			blackJackGraphic = new BlackJackGraphic();
			graphics.addChild(blackJackGraphic);
			super(blackJackGraphic);
			AS3_vs_AS2.myAddEventListener(blackJackGraphic,GraphicButtonClickEvent.GraphicButtonClick,makeAction,true)
			doRegisterOnServer();
		}
		private function makeAction(ev:GraphicButtonClickEvent):void
		{
			if(ev.name == ButtonEvents.HIT)
			{
				
			}
			else if(ev.name == ButtonEvents.STAND)
			{
				
			}
		}

		public function setTurn(turnPos:int):void
		{
			blackJackGraphic.showOptions();
			doAllSetTurn(allPlayerIds[turnPos],-1);
		}
		override public function gotNewMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			blackJackGraphic.initBlackJack()
			this.allPlayerIds = allPlayerIds;
			storeDecks(1,false);
			for each(var playerId:int in allPlayerIds)
				drawCards(2,playerId);
			setTurn(0);
		}
		
	}
}