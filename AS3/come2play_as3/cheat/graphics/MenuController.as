package come2play_as3.cheat.graphics
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.cheat.events.MenuClickEvent;
	import come2play_as3.cheat.graphics.menuItems.DeclareCardMenuImp;
	import come2play_as3.cheat.graphics.menuItems.DeclareCheaterMenuImp;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class MenuController extends Sprite
	{
		private var declareCheaterMenu:DeclareCheaterMenuImp
		private var declareCardMenu:DeclareCardMenuImp
		public function MenuController()
		{
			declareCardMenu = new DeclareCardMenuImp()
			declareCardMenu.headerText.text = T.i18n("choose action")
			AS3_vs_AS2.myAddEventListener("drawCardBtn",declareCardMenu.drawCardBtnImp,MouseEvent.CLICK,drawCard)
			AS3_vs_AS2.myAddEventListener("lowerCardBtn",declareCardMenu.lowerCardBtnImp,MouseEvent.CLICK,declareLower)
			AS3_vs_AS2.myAddEventListener("higherCardBtn",declareCardMenu.higherCardBtnImp,MouseEvent.CLICK,declareHigher)
			
			declareCheaterMenu = new DeclareCheaterMenuImp()	
			AS3_vs_AS2.myAddEventListener("trustButton",declareCheaterMenu.trustButtonImp,MouseEvent.CLICK,trustButton)
			AS3_vs_AS2.myAddEventListener("doNotTrustButton",declareCheaterMenu.doNotTrustButtonImp,MouseEvent.CLICK,doNotTrustButton)
		}
		public function showCardChoiseMenu():void{
			declareCardMenu.x = 120
			declareCardMenu.y = 23
			addChild(declareCardMenu)
		}
		public function showCheatChoiseMenu():void{
			declareCheaterMenu.x = 120
			declareCheaterMenu.y = 23
			addChild(declareCheaterMenu)
		}
		private function drawCard(ev:MouseEvent):void{
			dispatchEvent(new MenuClickEvent(MenuClickEvent.DRAW_CARD))
		}
		private function declareLower(ev:MouseEvent):void{
			dispatchEvent(new MenuClickEvent(MenuClickEvent.DECLARE_LOWER))
		}
		private function declareHigher(ev:MouseEvent):void{
			dispatchEvent(new MenuClickEvent(MenuClickEvent.DECLARE_HIGHER))
		}
		private function trustButton(ev:MouseEvent):void{
			dispatchEvent(new MenuClickEvent(MenuClickEvent.CALL_CHEATER))
		}
		private function doNotTrustButton(ev:MouseEvent):void{
			dispatchEvent(new MenuClickEvent(MenuClickEvent.DO_NOT_CALL_CHEATER))
		}
		
	}
}