package come2play_as3.cheat.graphics
{
	import come2play_as3.api.auto_copied.T;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	public class GameMessage extends Sprite
	{
		//private var txt:TextField//just to get the import
		private var gameMessage:Message
		public function GameMessage()
		{
			gameMessage = new Message()
			gameMessage.messageText.wordWrap = true;
			gameMessage.x = 150
			gameMessage.y = 180
			addChild(gameMessage);
			
		}
		public function chooseCard():void{
			gameMessage.messageText.text = T.i18n("Choose a card to place")
		}
		public function chooseCards():void{
			gameMessage.messageText.text = T.i18n("Choose up to 6 cards to place")
		}
		
	}
}