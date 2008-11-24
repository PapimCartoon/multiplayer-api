package come2play_as3.BlackJack
{
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.graphic.CardGraphic;

	public class BlackJackGraphic extends CardGraphic
	{
		private var buttonBar:ButtonBarImp
		public function BlackJackGraphic()
		{

		}
		public function initBlackJack():void
		{
			if(buttonBar!=null)
				if(contains(buttonBar))
				{
					removeChild(buttonBar);
				}
			buttonBar= new ButtonBarImp();
			buttonBar.y = CardDefenitins.CONTAINER_gameHeight + 10 - buttonBar.height;
			buttonBar.x = CardDefenitins.CONTAINER_gameWidth - buttonBar.width;
			addChild(buttonBar);
		}
		public function showOptions():void
		{
			buttonBar.showOptions();
		}
		public function hideOptions():void
		{
			buttonBar.hideOptions();
		}
		
	}
}