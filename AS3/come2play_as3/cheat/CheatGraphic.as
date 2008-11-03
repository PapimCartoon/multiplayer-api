package come2play_as3.cheat
{
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.caurina.transitions.Tweener;
	import come2play_as3.cards.graphic.CardGraphic;
	import come2play_as3.cards.graphic.RivalHand;
	import come2play_as3.cheat.connectionClasses.PlayerCall;
	import come2play_as3.cheat.graphic.ButtonBarImp;

	public class CheatGraphic extends CardGraphic
	{
		private var buttonBar:ButtonBarImp;
		private var msgBox:msgBox_MC;
		public function CheatGraphic()
		{
			msgBox= new msgBox_MC();
		}
		
		public function removeMessageBox():void
		{
			if(contains(msgBox))
				removeChild(msgBox);
		}
		public function putCall(playerCall:PlayerCall):void
		{
			msgBox.scaleX = 0.5;
			msgBox.scaleY = 0.5;
			Tweener.addTween(msgBox,{time:0.3,scaleX:1,scaleY:1,x:(CardDefenitins.CONTAINER_gameWidth / 2),y:(CardDefenitins.CONTAINER_gameHeight / 2), transition:"linear"})
			msgBox.amount_txt.text = playerCall.cardAmount + " Cards";
			msgBox.type_txt.text = "as " + buttonBar.makeString(playerCall.callNum);
			addChild(msgBox);
		}
		public function appendToPlayer(playerIndex:int):void
		{
			var rivalHand:RivalHand = rivalHandsArray[playerIndex];
			if(rivalHand == null) 
			{
				removeChild(msgBox);
				return;
			}
			var newPlayerIndex:int = rivalHand.rivalNum;
			
			var xPos:int;
			var yPos:int;
			
			if(newPlayerIndex== (CardDefenitins.playerNumber >2?1:2) )
			{
				xPos = CardDefenitins.playerXPositions[newPlayerIndex] + (CardDefenitins.cardHeight/2 - msgBox.width/3);
				yPos = CardDefenitins.CONTAINER_gameHeight/2;
			}
			else if(newPlayerIndex== (CardDefenitins.playerNumber >2?2:1) )
			{
				xPos = CardDefenitins.CONTAINER_gameWidth/2 ;
				yPos = msgBox.height/2;
			}
			else if(newPlayerIndex==3)
			{
				xPos = (msgBox.width-CardDefenitins.cardHeight)/2 ;
				yPos = CardDefenitins.CONTAINER_gameHeight/2;
			}	


			Tweener.addTween(msgBox,{time:0.3,scaleX:0.5,scaleY:0.5,x:xPos,y:yPos, transition:"linear"})
			//removeChild(msgBox);
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