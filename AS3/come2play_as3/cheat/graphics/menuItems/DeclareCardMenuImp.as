package come2play_as3.cheat.graphics.menuItems
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.cheat.graphics.WrapButton;
	
	public class DeclareCardMenuImp extends DeclareCardMenu
	{
		public var drawCardBtnImp:WrapButton
		public var lowerCardBtnImp:WrapButton
		public var higherCardBtnImp:WrapButton
		public function DeclareCardMenuImp()
		{
			drawCardBtnImp = new WrapButton(drawCardBtn,T.i18n("Draw"))
			lowerCardBtnImp = new WrapButton(lowerCardBtn,T.i18n("Put Lower"))
			higherCardBtnImp = new WrapButton(higherCardBtn,T.i18n("Put Higher"))
			addChild(drawCardBtnImp)
			addChild(lowerCardBtnImp)
			addChild(higherCardBtnImp)
		}
		
	}
}