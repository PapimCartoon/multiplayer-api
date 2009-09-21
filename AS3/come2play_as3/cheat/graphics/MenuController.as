package come2play_as3.cheat.graphics
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.cards.CardKey;
	import come2play_as3.cheat.CheatSoundControl;
	import come2play_as3.cheat.ServerClasses.CardsToHold;
	import come2play_as3.cheat.ServerClasses.JokerValue;
	import come2play_as3.cheat.caurina.transitions.Tweener;
	import come2play_as3.cheat.events.MenuClickEvent;
	import come2play_as3.cheat.graphics.menuItems.DeclareCardMenuImp;
	import come2play_as3.cheat.graphics.menuItems.DeclareCheaterMenuImp;
	import come2play_as3.cheat.graphics.menuItems.DeclareJokerMenuImp;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class MenuController extends Sprite
	{
		private var declareCheaterMenu:DeclareCheaterMenuImp
		private var declareCardMenu:DeclareCardMenuImp
		private var declareJokerMenu:DeclareJokerMenuImp
		private var showingMenu:Sprite
		
		public function MenuController()
		{
			declareCardMenu = new DeclareCardMenuImp()
			AS3_vs_AS2.myAddEventListener("BlankCardGraphic",declareCardMenu.lowerCardBtnImp,MouseEvent.CLICK,declareLower)
			AS3_vs_AS2.myAddEventListener("BlankCardGraphic",declareCardMenu.higherCardBtnImp,MouseEvent.CLICK,declareHigher)
			
			declareCheaterMenu = new DeclareCheaterMenuImp()	
			AS3_vs_AS2.myAddEventListener("trustButton",declareCheaterMenu.trustButtonImp,MouseEvent.CLICK,trustButton)
			AS3_vs_AS2.myAddEventListener("doNotTrustButton",declareCheaterMenu.doNotTrustButtonImp,MouseEvent.CLICK,doNotTrustButton)
		
			declareJokerMenu = new DeclareJokerMenuImp()
			AS3_vs_AS2.myAddEventListener("declareJokerMenu",declareJokerMenu,"JokerValue",dispatchJokerEvent)
		}
		private function removeShowingMenu(sp:Sprite):void{
			if(showingMenu!=null){
				Tweener.removeTweens(showingMenu);
				removeChild(showingMenu);
			}
			showingMenu = sp;
			showingMenu.x = 160
			showingMenu.y = -200
			addChild(showingMenu)
			
			Tweener.addTween(showingMenu, {time:0.4, y:((showingMenu is DeclareCardMenuImp)?-30:-20), transition:"linear"})
		}
		public function close():void{
			var sp:Sprite = this;
			Tweener.removeTweens(showingMenu);
			Tweener.addTween(showingMenu, {time:0.2, y:-200, transition:"linear",onComplete:function():void{
				if(sp.parent!=null){	
					if(sp.parent.contains(sp))
						sp.parent.removeChild(sp);
				}
				
			}})
		}
		public function showCardChoiseMenu(opponentCard:int):void{
			declareCardMenu.setVal(opponentCard)
			removeShowingMenu(declareCardMenu)	
		}
		public function showCheatChoiseMenu(cardsToHold:CardsToHold,canTrust:Boolean):void{
			declareCheaterMenu.reStartCount(cardsToHold.declaredValue,cardsToHold.keys.length,canTrust)
			removeShowingMenu(declareCheaterMenu)
		}
		public function showJokerChoiceMenu(cardKey:CardKey):void{
			declareJokerMenu.setCardKey(cardKey)
			removeShowingMenu(declareJokerMenu)
		}
		
		public function setMiddleAmount(value:int):void{
			declareCardMenu.setMiddleAmount(value)
		}
		private function dispatchJokerEvent(ev:JokerValue):void{
			CheatSoundControl.playClick();
			var jokerValue:JokerValue = JokerValue.create(ev.jokerValue,ev.cardKey)
			dispatchEvent(jokerValue)
		}
		private function drawCard(ev:MouseEvent):void{
			CheatSoundControl.playClick();
			dispatchEvent(new MenuClickEvent(MenuClickEvent.DRAW_CARD))
		}
		private function declareLower(ev:MouseEvent):void{
			CheatSoundControl.playClick();
			dispatchEvent(new MenuClickEvent(MenuClickEvent.DECLARE_LOWER))
		}
		private function declareHigher(ev:MouseEvent):void{
			CheatSoundControl.playClick();
			dispatchEvent(new MenuClickEvent(MenuClickEvent.DECLARE_HIGHER))
		}
		public function stopCheatTimer():void{
			declareCheaterMenu.stopTimer()
		}
		
		private function trustButton(ev:MouseEvent):void{
			stopCheatTimer()
			CheatSoundControl.playClick();
			dispatchEvent(new MenuClickEvent(MenuClickEvent.DO_NOT_CALL_CHEATER))
		}
		private function doNotTrustButton(ev:MouseEvent):void{
			stopCheatTimer()
			CheatSoundControl.playClick();
			dispatchEvent(new MenuClickEvent(MenuClickEvent.CALL_CHEATER))
		}
		
	}
}