package come2play_as3.cheat.graphics
{
	import come2play_as3.api.auto_copied.T;
	
	import flash.display.Sprite;

	public class GameMessage extends Sprite
	{
		//private var txt:TextField//just to get the import
		private var cheater:Cheater = new Cheater()
		private var notCheater:NotCheater = new NotCheater()
		private var cardsPic:CardsPic = new CardsPic()
		
		private var gameMessage:Message
		public function GameMessage()
		{
			gameMessage = new Message()
			gameMessage.messageText.wordWrap = true;
			gameMessage.x = 150
			gameMessage.y = 180
			cardsPic.x = 13
			cardsPic.y = 8
			
			notCheater.x = cheater.x = 13
			notCheater.y = cheater.y = 8
			notCheater.scaleX = cheater.scaleX = 0.8
			notCheater.scaleY = cheater.scaleY = 0.8
			addChild(gameMessage);
			
		}
		private function removeGraphics():void{
			if(gameMessage.contains(cheater))	gameMessage.removeChild(cheater);
			if(gameMessage.contains(notCheater))	gameMessage.removeChild(notCheater);
			if(gameMessage.contains(cardsPic))	gameMessage.removeChild(cardsPic);
		}
		
		public function chooseCard():void{
			removeGraphics()
			gameMessage.messageText.text = T.i18n("Choose a card to place");
			gameMessage.addChild(cardsPic);
		}
		public function amIRight(isRight:Boolean,isBiengCalled:Boolean):void{
			removeGraphics()
			if(isBiengCalled){
				if(isRight){
					gameMessage.messageText.text = T.i18n("He got you there mate !");
					gameMessage.addChild(cheater);
				}else{
					gameMessage.messageText.text = T.i18n("We got him,Excelent !");
					gameMessage.addChild(notCheater);
				}
			}else{
				if(isRight){
					gameMessage.messageText.text = T.i18n("You got the cheater !");
					gameMessage.addChild(cheater);
				}else{
					gameMessage.messageText.text = T.i18n("He's an innocent as a sheep,tough luck");
					gameMessage.addChild(notCheater);
				}
			}
		}
		public function willCallBluff(isBluff:Boolean):void{
			removeGraphics()
			if(isBluff){
				gameMessage.messageText.text = T.i18n("Will he call our bluff ?!");
				gameMessage.addChild(cheater);
			}else{
				gameMessage.messageText.text = T.i18n("Will he fall for it ?!");
				gameMessage.addChild(notCheater);
			}
		}
		public function bluffSuccess():void{
			removeGraphics()
			gameMessage.messageText.text = T.i18n("SAFE !!!");
			gameMessage.addChild(cheater);
		}

		
	}
}