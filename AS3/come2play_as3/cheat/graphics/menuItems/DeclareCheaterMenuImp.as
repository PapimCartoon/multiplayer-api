package come2play_as3.cheat.graphics.menuItems
{
	import come2play_as3.api.auto_copied.AS3_Timer;
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	public class DeclareCheaterMenuImp extends DeclareCheaterMenu
	{
		private var timePassed:AS3_Timer = new AS3_Timer("timePassed",1000)
		private var startTime:int
		private var canTrust:Boolean
		public function DeclareCheaterMenuImp()
		{
			cheat_txt.text = T.i18n("Cheater")
			notCheat_txt.text = T.i18n("Trust")
			AS3_vs_AS2.myAddEventListener("timePassed",timePassed,TimerEvent.TIMER,decreseSecond);
			addChild(trustButtonImp);
			addChild(doNotTrustButtonImp);
		}
		private function decreseSecond(ev:TimerEvent = null):void{
			var tmpTimePassed:int = (getTimer()-startTime)/1000;
			timeText.text = String(10-tmpTimePassed);
			if(tmpTimePassed >= 10){
				stopTimer()
				if(canTrust){
					trustButtonImp.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}else{
					doNotTrustButtonImp.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}	
		}
		public function reStartCount(num:int,count:int,canTrust:Boolean):void{
			this.canTrust = canTrust;
			trustButtonImp.visible = canTrust
			headerText.text = T.i18nReplace("$cardsNum$ cards claimed to be $cardType$",{cardsNum:count, cardType:num})
			startTime = getTimer();
			decreseSecond()
			timePassed.start();
		}
		public function stopTimer():void{
			timePassed.stop();
		}
	}
}