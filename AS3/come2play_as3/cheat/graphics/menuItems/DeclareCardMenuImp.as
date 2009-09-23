package come2play_as3.cheat.graphics.menuItems
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.cheat.graphics.BlankCardGraphic;
	
	public class DeclareCardMenuImp extends DeclareCardMenu
	{
		public var lowerCardBtnImp:BlankCardGraphic
		public var higherCardBtnImp:BlankCardGraphic
		public function DeclareCardMenuImp()
		{
			orText_txt.text = T.i18n("- OR -")
			headerText.text = T.i18n("Declare card value as")
			lowerCardBtnImp = new BlankCardGraphic()
			higherCardBtnImp = new BlankCardGraphic()
			lowerCardBtnImp.rotation = -10
			higherCardBtnImp.rotation = 10
			lowerCardBtnImp.x = 40
			higherCardBtnImp.x = 200
			lowerCardBtnImp.y = higherCardBtnImp.y = 130;
			lowerCardBtnImp.buttonMode = higherCardBtnImp.buttonMode = true;
			addChild(lowerCardBtnImp)
			addChild(higherCardBtnImp)
		}
		public function setVal(opponentCard:int):void{
			setMiddleAmount(0)
			rules_txt.htmlText = T.i18nReplace("<U>Opponent declared '$OpponentCard$' you can:</U>",{OpponentCard:numberToLetter(opponentCard)})+
			"<BR>"+T.i18nReplace("- Place a lower '$lowerCard$' card/s",{lowerCard:(numberToLetter(opponentCard - 1))})+
			"<BR>"+T.i18nReplace("- Place a higher '$higherCard$' card/s",{higherCard:(numberToLetter(opponentCard + 1))})+
			"<BR>"+T.i18n("- Draw a new card from the deck")+
			"<BR>"+T.i18n("- Cheat by selecting whetever");
			lowerCardBtnImp.setValue(opponentCard - 1)
			higherCardBtnImp.setValue(opponentCard + 1)
		}
		private function numberToLetter(num:int):String{
			if(num == 0)	return "<B>K</B>"
			else if(num == 1)	return "<B>A</B>"
			else if(num<11){
				return "<B>"+num+"</B>"
			}else if(num == 11)	return "<B>J</B>"
			else if(num == 12)	return "<B>Q</B>"
			else if(num == 13)	return "<B>K</B>"
			else if(num == 14)	return "<B>A</B>"
			return ""
		}
		
		public function setMiddleAmount(value:int):void{
			if(value == 0){
				rules_txt.visible = true;
				headerText.visible = false
				orText_txt.visible = false
				lowerCardBtnImp.visible = false
				higherCardBtnImp.visible = false
			}else{
				rules_txt.visible = false;
				headerText.visible = true
				orText_txt.visible = true
				lowerCardBtnImp.visible = true
				higherCardBtnImp.visible = true
			}
		}
		
	}
}