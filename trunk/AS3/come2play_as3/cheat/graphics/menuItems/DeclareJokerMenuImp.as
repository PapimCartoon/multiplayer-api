package come2play_as3.cheat.graphics.menuItems
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.cards.CardKey;
	import come2play_as3.cheat.ServerClasses.JokerValue;
	import come2play_as3.cheat.graphics.BlankCardGraphic;
	
	import flash.events.MouseEvent;
	
	public class DeclareJokerMenuImp extends DeclareJokerMenu
	{
		
		public function DeclareJokerMenuImp()
		{
			headerText.text = T.i18n("Declare joker value as");
			var blankCard:BlankCardGraphic
			for(var i:int = 1;i<=7;i++){
				blankCard = new BlankCardGraphic(15)
				blankCard = returnCard(i,i * 30,90)
				addChild(blankCard)
			}
			for(i = 1;i<=6;i++){
				blankCard = returnCard(i + 7,15 + i * 30,140)
				addChild(blankCard)
			}
		}
		private var jokerCardKey:CardKey
		public function setCardKey(cardKey:CardKey):void{
			jokerCardKey = cardKey;
		}
		private function returnCard(cardNum:int,xPos:int,yPos:int):BlankCardGraphic{
			var res:BlankCardGraphic = new BlankCardGraphic(15)
			res.x = xPos;
			res.y = yPos
			res.buttonMode = true;
			res.setValue(cardNum)
			AS3_vs_AS2.myAddEventListener("BlankCardGraphic",res,MouseEvent.CLICK,function(ev:MouseEvent):void{
				disaptchJokerClick(cardNum)
			})
			return res;
		}
		private function disaptchJokerClick(num:int):void{
			dispatchEvent(JokerValue.create(num,jokerCardKey))
		}
		
	}
}