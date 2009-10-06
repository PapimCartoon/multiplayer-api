package come2play_as3.cheat.graphics.menuItems
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.API_Message;
	import come2play_as3.cheat.graphics.BlankCardGraphic;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class DeclareCardMenuImp extends DeclareCardMenu
	{
		public var lowerCardBtnImp:BlankCardGraphic
		public var higherCardBtnImp:BlankCardGraphic	
		private var rules_txt:TextField
		
		public function DeclareCardMenuImp()
		{
			rules_txt = new TextField()
			var tf:TextFormat = new TextFormat("Arial",13,0xFFFFFF,true)
			rules_txt.mouseEnabled = false;
			rules_txt.defaultTextFormat = tf
			rules_txt.setTextFormat(tf)
			orText_txt.text = T.i18n("- OR -")
			rules_txt.width = 237;
			rules_txt.height = 40
			rules_txt.selectable = false;
			rules_txt.x = 2
			rules_txt.y = 155	
			lowerCardBtnImp = BlankCardGraphic.getBlankCard(65,120)
			higherCardBtnImp =BlankCardGraphic.getBlankCard(170,120)
			lowerCardBtnImp.rotation = -10
			higherCardBtnImp.rotation = 10
			addChild(lowerCardBtnImp)
			addChild(higherCardBtnImp)
			addChild(rules_txt)
		}
		public function setVal(opponentCard:int):void{
			setMiddleAmount(0)
			rules_txt.text = T.i18n("- Draw a new card from the deck") +
			"\n"+T.i18n("- Cheat by selecting whetever");
			lowerCardBtnImp.setValue(opponentCard - 1)
			higherCardBtnImp.setValue(opponentCard + 1)
		}
		
		public function setMiddleAmount(value:int):void{
			if(value == 0){
				headerText.text = T.i18n("Choose cards")
				lowerCardBtnImp.mouseEnabled = lowerCardBtnImp.mouseChildren = lowerCardBtnImp.buttonMode = false
				higherCardBtnImp.mouseEnabled = higherCardBtnImp.mouseChildren = higherCardBtnImp.buttonMode = false
				rules_txt.visible = true;
			}else{
				headerText.text = T.i18n("Declare card value as")
				lowerCardBtnImp.mouseEnabled = lowerCardBtnImp.mouseChildren = lowerCardBtnImp.buttonMode = true
				higherCardBtnImp.mouseEnabled = higherCardBtnImp.mouseChildren  = higherCardBtnImp.buttonMode = true
				rules_txt.visible = false;
			}
		}
		
	}
}