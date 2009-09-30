package come2play_as3.cheat.graphics
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.cheat.events.MenuClickEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class CardDeck extends MovieClip
	{
		private var deck:Deck_MC;
		private var circleNum:CircleCounterImp
		public var availableCards:int
		
		public function CardDeck()
		{
			deck = new Deck_MC();
			deck.drawText.mouseEnabled = false;
			deck.Deck1.Symbole_MC.stop();
			deck.Deck1.Letter_MC.stop();
			deck.Deck2.Symbole_MC.stop();
			deck.Deck2.Letter_MC.stop();
			deck.Deck3.Symbole_MC.stop();
			deck.Deck3.Letter_MC.stop();
			AS3_vs_AS2.myAddEventListener("deck",deck,MouseEvent.CLICK,drawCard)
			AS3_vs_AS2.myAddEventListener("deck",deck,MouseEvent.MOUSE_OVER,drawOver)
			AS3_vs_AS2.myAddEventListener("deck",deck,MouseEvent.MOUSE_OUT,drawOut)
			deck.scaleX = deck.scaleY = 0.6
			circleNum = new CircleCounterImp()
			addChild(deck);
			addChild(circleNum)
			circleNum.y = -70
			circleNum.x = 30
			canDraw(false)
		}
		public function setCards(num:int):void{
			availableCards = num;
			circleNum.setCards(num)
			
		}
		public function canDraw(value:Boolean):void{
			deck.drawText.visible = deck.buttonMode = deck.mouseChildren = deck.mouseEnabled = value;
		}
		private function drawCard(ev:MouseEvent):void{
			dispatchEvent(new MenuClickEvent(MenuClickEvent.DRAW_CARD))
		}
		private function drawOver(ev:MouseEvent):void{
			deck.filters = [new GlowFilter(0x66FFFF,1,8,8,2.2)]
		}
		private function drawOut(ev:MouseEvent):void{
			deck.filters = []
		}
		

	}
}