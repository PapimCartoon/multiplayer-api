package come2play_as3.cards.graphic
{
	import come2play_as3.cards.Card;
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.events.CardRecievedEvent;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class CardGraphicMovieClip extends MovieClip
	{
		private var card:Card;
		private var cardGraphic:Card_MC;
		private var cardMover:Timer;
		private var playerNum:int;
		private var cardNum:int;
		public function CardGraphicMovieClip(card:Card = null)
		{
			cardGraphic = new Card_MC();
			cardGraphic.scaleX = CardDefenitins.cardSize *0.01
			cardGraphic.scaleY = CardDefenitins.cardSize *0.01
			cardMover = new Timer(10,0);
			cardMover.addEventListener(TimerEvent.TIMER,cardMove);
			if(card!=null)
			{
				this.card = card;
				cardGraphic.Letter_MC.gotoAndStop(int(card.intSign/2));
				cardGraphic.Symbole_MC.gotoAndStop(card.value);
			}
			addChild(cardGraphic)
		}
		private function cardMove(ev:TimerEvent):void
		{
			if(playerNum == 0)
			{
				x += CardDefenitins.cardSpeed;
				y += CardDefenitins.cardSpeed;	
				if(rotation > 0)
					rotation -= 8;
				else
					rotation = 0;
				if ( y > (stage.stageHeight -cardGraphic.height) )
				{	
					cardMover.stop();
					dispatchEvent(new CardRecievedEvent());
				}
			}
			
		}
		
		public function moveCard(playerNum:int,cardNum:int):void
		{
			x = stage.stageWidth /2;
			y = stage.stageHeight /2;
			rotation = 90
			this.playerNum = playerNum;
			this.cardNum = cardNum;
			cardMover.start();
		}
		

	}
}