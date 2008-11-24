package come2play_as3.BlackJack
{
	import come2play_as3.cards.events.GraphicButtonClickEvent;
	import come2play_as3.cheat.graphic.ButtonBarButtonImp;
	
	
	public class ButtonBarImp extends ButtonBar_MC
	{
		private var standButton:ButtonBarButtonImp;
		private var hitButton:ButtonBarButtonImp;
		public function ButtonBarImp()
		{
			standButton = new ButtonBarButtonImp(ButtonEvents.STAND,"Stand");
			hitButton = new ButtonBarButtonImp(ButtonEvents.HIT,"Hit");
			standButton.x = 150;
			hitButton.x = 300;
			hitButton.y = standButton.y = 60
			super();
		}
		public function showOptions():void
		{
			addChild(standButton)
			addChild(hitButton)
		}
		public function hideOptions():void
		{
			if(contains(standButton))
				addChild(standButton)
			if(contains(hitButton))
				addChild(hitButton)
		}
		
	}
}