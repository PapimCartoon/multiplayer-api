package come2play_as3.cheat.graphics.menuItems
{
	import come2play_as3.api.auto_copied.AS3_Timer;
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.cheat.graphics.WrapButton;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	public class DeclareCheaterMenuImp extends DeclareCheaterMenu
	{
		public var trustButtonImp:WrapButton
		public var doNotTrustButtonImp:WrapButton
		private var timePassed:AS3_Timer = new AS3_Timer("timePassed",1000)
		private var startTime:int
		public function DeclareCheaterMenuImp()
		{
			trustButtonImp = new WrapButton(trustButton,T.i18n("Trust"));
			doNotTrustButtonImp = new WrapButton(doNotTrustButton,T.i18n("Call cheater"));
			AS3_vs_AS2.myAddEventListener("timePassed",timePassed,TimerEvent.TIMER,decreseSecond);
			addChild(trustButtonImp);
			addChild(doNotTrustButtonImp);
		}
		private function decreseSecond(ev:TimerEvent):void{
			var tmpTimePassed:int = (getTimer()-startTime)/1000;
			timeText.text = String(10-tmpTimePassed);
			if(tmpTimePassed >= 10){
				timePassed.stop();
				trustButtonImp.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}	
		}
		public function reStartCount(num:int,count:int):void{
			headerText.text = T.i18nReplace("$cardsNum$ cards claimed to be $cardType$",{cardsNum:count, cardType:num})
			startTime = getTimer();
			stopTimer();
		}
		public function stopTimer():void{
			timePassed.start();
		}
	}
}