package come2play_as3.cheat.graphics.menuItems
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.cheat.graphics.BlankCardGraphic;
	
	import flash.text.TextFormat;
	
	public class DeclareCardMenuImp extends DeclareCardMenu
	{
		public var lowerCardBtnImp:BlankCardGraphic
		public var higherCardBtnImp:BlankCardGraphic
		
		private var lowerCardPic:BlankCardGraphic
		private var higherCardPic:BlankCardGraphic
		private var choosenCardPic:BlankCardGraphic
			
		
		
		public function DeclareCardMenuImp()
		{
			orText_txt.text = T.i18n("- OR -")
			headerText.text = T.i18n("Declare card value as")
			var tf:TextFormat = rulesHeader_txt.defaultTextFormat;
			tf.underline = true;
			rulesHeader_txt.defaultTextFormat = tf;
			rulesHeader_txt.setTextFormat(tf)
			lowerCardPic = BlankCardGraphic.getBlankCard(115,110,13,true)
			higherCardPic = BlankCardGraphic.getBlankCard(220,110,13,true)
			choosenCardPic = BlankCardGraphic.getBlankCard(160,78,17,true)	
			lowerCardBtnImp = BlankCardGraphic.getBlankCard(65,130)
			higherCardBtnImp =BlankCardGraphic.getBlankCard(170,130)
			lowerCardBtnImp.rotation = -10
			higherCardBtnImp.rotation = 10
			lowerCardBtnImp.buttonMode = higherCardBtnImp.buttonMode = true;
			lowerCardPic.rotation = -10
			higherCardPic.rotation = 10
			addChild(choosenCardPic);
			addChild(lowerCardPic);
			addChild(higherCardPic);
			addChild(choosenCardPic);
			addChild(lowerCardBtnImp)
			addChild(higherCardBtnImp)
		}
		public function setVal(opponentCard:int):void{
			setMiddleAmount(0)
			choosenCardPic.setValue(opponentCard)
			lowerCardPic.setValue(opponentCard - 1)
			higherCardPic.setValue(opponentCard + 1)
			rulesHeader_txt.text = T.i18n("Opponent declared:")
			rules_txt.text = T.i18n("- Place a lower")+
			"            "+T.i18n("or a higher")+
			"\n"+T.i18n("- Draw a new card from the deck")+
			"\n"+T.i18n("- Cheat by selecting whetever");
			lowerCardBtnImp.setValue(opponentCard - 1)
			higherCardBtnImp.setValue(opponentCard + 1)
		}
		
		public function setMiddleAmount(value:int):void{
			if(value == 0){
				rules_txt.visible = true;
				rulesHeader_txt.visible = true
				choosenCardPic.visible = true
				lowerCardPic.visible = true
				higherCardPic.visible = true
				headerText.visible = false
				orText_txt.visible = false
				lowerCardBtnImp.visible = false
				higherCardBtnImp.visible = false
			}else{
				rules_txt.visible = false;
				rulesHeader_txt.visible = false
				choosenCardPic.visible = false
				lowerCardPic.visible = false
				higherCardPic.visible = false
				headerText.visible = true
				orText_txt.visible = true
				lowerCardBtnImp.visible = true
				higherCardBtnImp.visible = true
			}
		}
		
	}
}