package come2play_as3.cheat.graphics
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.StaticFunctions;
	import come2play_as3.cards.Card;
	import come2play_as3.cards.CardKey;
	import come2play_as3.cheat.caurina.transitions.Tweener;
	import come2play_as3.cheat.events.CardClickedEvent;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CardGraphic extends Sprite
	{
		private var card:Card_MC;
		private var cardData:Card;
		private var cardKey:CardKey;
		private var blankCardValue:int = 0
		public function CardGraphic(cardKey:CardKey,cardData:Card=null,value:int = 0)
		{
			this.cardKey = cardKey;
			card = new Card_MC();
			card.Symbole_MC.stop();
			card.Letter_MC.stop();
			card.scaleX = card.scaleY = 0.5
			setCardData(cardData);
			setCard(cardData)
			if(value!=0){
				setValue(value)
			}
			addChild(card);
			AS3_vs_AS2.myAddEventListener("CardGraphic",this,MouseEvent.CLICK,clicked)
		}
		public function getCardKey():CardKey{
			return cardKey;
		}
		public function get cardValue():int{
			return cardData==null?0:(cardData.value * 9 + cardData.intSign())
		}
		public function getCardValue():int{
			return cardData.value;
		}
		public function assertLegealCardData():void{
			StaticFunctions.assert(cardData!=null,"Card Graphic should not be null")
		}
		public function fixData(cardData:Card):void{
			if(cardData == null)	this.cardData = cardData;
		}
		public function isSame(card:CardKey):Boolean{
			return card.num == cardKey.num
		}
		public function isSameCard(card:Card):Boolean{
			return ((cardData == null) || (card == null))?true:((card.value == cardData.value) && (card.sign == cardData.sign))
		}
		private function clicked(ev:MouseEvent):void{
			if(buttonMode)	dispatchEvent(new CardClickedEvent(cardKey,cardData))
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
		public function setKey(cardKey:CardKey):void{
			this.cardKey = cardKey;
		}
		public function getCard():Card{
			return cardData;
		}
		public function hide():void{
			card.Symbole_MC.gotoAndStop(1);
			card.Letter_MC.gotoAndStop(1);
		}
		public function startFlip():void{
			Tweener.addTween(card, {time:0.15, scaleX:0.1,scaleY:0.55, transition:"linear",onComplete:showCardData})
		}
		public function endFlip():void{
			Tweener.addTween(card, {time:0.15, scaleX:0.5,scaleY:0.5, transition:"linear",onComplete:function():void{
				
			}})
		}
		private function showCardData(canEndFlip:Boolean = true):void{
			if(blankCardValue!=0){
				card.Symbole_MC.gotoAndStop(20);
				card.Letter_MC.gotoAndStop(29+blankCardValue)
				endFlip()
				return	
			}
			
			if(cardData == null){
				hide()
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
			if(canEndFlip)	endFlip()
		}
		public function setCardData(cardData:Card):void{
			this.cardData = cardData;
			blankCardValue = 0
		}
		
		public function setCard(cardData:Card):void{
			if(((cardData==null) && (this.cardData!=null)) || ((cardData!=null) && (this.cardData==null)) || (blankCardValue != 0)){
				setCardData(cardData);
				startFlip()
			}else{
				setCardData(cardData);
				showCardData(false)
			}
			
			
		}	
		public function setValue(value:int):void{
			blankCardValue = value;
			/*return;
			card.Symbole_MC.gotoAndStop(20);
			card.Letter_MC.gotoAndStop(29+value)*/
		}
		
		
		
		override public function toString():String{
			return cardKey.toString() +(cardData==null?"null":cardData.toString());
		}	
	}
}