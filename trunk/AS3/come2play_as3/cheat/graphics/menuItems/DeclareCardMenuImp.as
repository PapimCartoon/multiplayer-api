package come2play_as3.cheat.graphics.menuItems
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.cheat.graphics.BlankCardGraphic;
	import come2play_as3.cheat.graphics.WrapButton;
	
	public class DeclareCardMenuImp extends DeclareCardMenu
	{
		public var drawCardBtnImp:WrapButton
		public var lowerCardBtnImp:BlankCardGraphic
		public var higherCardBtnImp:BlankCardGraphic
		public function DeclareCardMenuImp()
		{
			orText_txt.text = T.i18n("- OR -")
			drawCardBtnImp = new WrapButton(drawCardBtn,T.i18n("DRAW"))
			lowerCardBtnImp = new BlankCardGraphic()
			higherCardBtnImp = new BlankCardGraphic()
			lowerCardBtnImp.rotation = -10
			higherCardBtnImp.rotation = 10
			lowerCardBtnImp.x = 40
			higherCardBtnImp.x = 200
			lowerCardBtnImp.y = higherCardBtnImp.y = 130;
			lowerCardBtnImp.buttonMode = higherCardBtnImp.buttonMode = true;
			drawCardBtnImp.visible = false
			addChild(drawCardBtnImp)
			addChild(lowerCardBtnImp)
			addChild(higherCardBtnImp)
		}
		override public function set y(value:Number):void{
			drawCardBtnImp.visible = (value == -30);
			super.y = value;
		}
		public function setVal(value:int):void{
			setMiddleAmount(0)
			lowerCardBtnImp.setValue(value - 1)
			higherCardBtnImp.setValue(value + 1)
		}
		public function setMiddleAmount(value:int):void{
			if(value == 0){
				headerText.text = T.i18n("Choose up to 6 cards or draw")
			}else{
				headerText.text = T.i18n("Declare card value as")
			}
		}
		
	}
}