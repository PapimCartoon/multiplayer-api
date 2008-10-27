package come2play_as3.cheat
{
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.graphic.CardGraphic;
	import come2play_as3.cheat.graphic.ButtonBarImp;

	public class CheatGraphic extends CardGraphic
	{
		private var buttonBar:ButtonBarImp;
		public function CheatGraphic()
		{
			
		}
		public function initCheat():void
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
		public function setMyTrun(lastCall:int):void
		{
			buttonBar.addNumButtons(lastCall)
		}
		public function callCheater():void
		{
			buttonBar.callCheater();
		}
		public function clear():void
		{
			buttonBar.clear();
		}
		public function okMessage():void
		{
			buttonBar.okMessage();
		}
		public function set enableButtons(enabled:Boolean):void
		{
			buttonBar.enableNumberButton = enabled;
		}
		
		
	}
}