package come2play_as3.cheat.graphics
{
	import come2play_as3.cards.Card;
	
	import flash.display.Sprite;

	public class CardGraphic extends Sprite
	{
		private var card:Card_MC;
		public function CardGraphic(cardData:Card=null)
		{
			card = new Card_MC();
			card.Symbole_MC.stop();
			card.Letter_MC.stop();
			card.scaleX = card.scaleY = 0.4
			setCard(cardData)
			addChild(card);
		}
		public function setCard(cardData:Card):void{
			if(cardData == null)	return;
			card.Symbole_MC.gotoAndStop(cardData.sign)
			//card.Letter_MC.gotoAndStop(cardData.value)
		}		
	}
}