package come2play_as3.cheat.graphics
{
	import flash.display.MovieClip;
	
	public class CardDeck extends MovieClip
	{
		private var deck:Deck_MC;
		public function CardDeck()
		{
			deck = new Deck_MC();
			deck.Deck.Symbole_MC.stop();
			deck.Deck.Letter_MC.stop();
			deck.scaleX = deck.scaleY = 0.5
			addChild(deck);
		}
		public function setCards(num:int):void{
			deck.cardNum_txt.text = String(num);
		}
		

	}
}