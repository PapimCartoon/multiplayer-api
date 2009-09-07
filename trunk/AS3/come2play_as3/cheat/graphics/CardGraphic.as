package come2play_as3.cheat.graphics
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.StaticFunctions;
	import come2play_as3.cards.Card;
	import come2play_as3.cheat.events.CardClickedEvent;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CardGraphic extends Sprite
	{
		private var card:Card_MC;
		private var cardData:Card;
		public function CardGraphic(cardData:Card=null)
		{
			card = new Card_MC();
			card.Symbole_MC.stop();
			card.Letter_MC.stop();
			card.scaleX = card.scaleY = 0.5
			setCard(cardData)
			addChild(card);
			AS3_vs_AS2.myAddEventListener("CardGraphic",this,MouseEvent.CLICK,clicked)
		}
		public function get cardValue():int{
			return cardData==null?0:(cardData.value * 4 + cardData.intSign())
		}
		public function isSame(card:Card):Boolean{
			return cardData==null?true:cardData.equelTo(card)
		}
		private function clicked(ev:MouseEvent):void{
			if(buttonMode)	dispatchEvent(new CardClickedEvent(cardData))
		}
		private function setFrameIn(mc:MovieClip,label:String,value:int):void{
			var mod:int = value>10?(value - 10):0
			var currentLabels:Array = mc.currentLabels
			for each(var frameLabel:FrameLabel in currentLabels){
				if(frameLabel.name == label){
					mc.gotoAndStop(frameLabel.frame + mod)
					return;
				}	
			}
			StaticFunctions.assert(false,"doesn't have proper image");
		}
		
		public function setCard(cardData:Card):void{
			this.cardData = cardData;
			if(cardData == null){
				card.Symbole_MC.gotoAndStop(1);
				card.Letter_MC.gotoAndStop(1);
			}else if(cardData.sign == Card.BLACKJOKER){
				card.Symbole_MC.gotoAndStop(18)
				card.Letter_MC.gotoAndStop(29);
			}else if(cardData.sign == Card.REDJOKER){
				card.Symbole_MC.gotoAndStop(19)
				card.Letter_MC.gotoAndStop(15);
			}else if(cardData.isBlack()){
				card.Letter_MC.gotoAndStop(cardData.value + 15)
				setFrameIn(card.Symbole_MC,cardData.sign,cardData.value)
			}else{
				card.Letter_MC.gotoAndStop(cardData.value + 1)
				setFrameIn(card.Symbole_MC,cardData.sign,cardData.value)
			}
		}		
	}
}