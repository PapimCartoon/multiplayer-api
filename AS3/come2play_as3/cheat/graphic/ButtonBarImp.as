package come2play_as3.cheat.graphic
{
	
	import come2play_as3.cards.events.GraphicButtonClickEvent;
	
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class ButtonBarImp extends ButtonBar_MC
	{
		private var upNumImp:ButtonBarButtonImp;
		private var downNumImp:ButtonBarButtonImp;
		private var callCheaterButt:ButtonBarButtonImp;
		private var trustButt:ButtonBarButtonImp;
		private var okButt:ButtonBarButtonImp;
		private var cheaterTimer:Timer;
		private var textField:TextField;
		private var timeLeft:int;
		public function ButtonBarImp()
		{
			cheaterTimer = new Timer(1000,0);
			cheaterTimer.addEventListener(TimerEvent.TIMER,secondDone);
			callCheaterButt = new ButtonBarButtonImp("callCheater","Call Cheater");
			trustButt = new ButtonBarButtonImp("trust","Trust");
			okButt = new ButtonBarButtonImp("ok","Ok");
			okButt.x = 200;
			okButt.y = 60;
			trustButt.x = 50;
			trustButt.y = 60;
			callCheaterButt.x = 250
			callCheaterButt.y = 60;
			textField = new TextField();
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.defaultTextFormat = new TextFormat(null,20,0xffffff);
			addChild(textField)
		}
		public function set enableNumberButton(enabled:Boolean):void
		{
			downNumImp.disabled = upNumImp.disabled = (!enabled);
		}
		public function callCheater():void
		{
			textField.x = 122;
			textField.y = 50;
			timeLeft = 10;
			addChild(callCheaterButt);
			addChild(trustButt);
			cheaterTimer.start();
			textField.text = timeLeft+" Seconds left"
		}
		public function secondDone(ev:TimerEvent):void
		{
			timeLeft--;
			textField.text = timeLeft+" Seconds left";
			if(timeLeft == 0)
			{
				clear();
				dispatchEvent(new GraphicButtonClickEvent("trust"));
			}
		}
		public function makeString(numToStr:int):String
		{
			if(numToStr == 0)	return "K";
			if(numToStr == 1)	return "A";
			if(numToStr == 11)	return "J";
			if(numToStr == 12)	return "Q";
			if(numToStr == 13)	return "K";
			if(numToStr == 14)	return "A";
			return String(numToStr)
		}
		
		public function addNumButtons(currentNum:int):void
		{
			textField.x = 170;
			textField.y = 50;
			textField.text = "Call card\\s:"
			
			
			upNumImp = new ButtonBarButtonImp("upNum",makeString(currentNum + 1));
			downNumImp = new ButtonBarButtonImp("downNum",makeString(currentNum - 1));
			downNumImp.y = upNumImp.y = 60;
			downNumImp.x = 130;
			upNumImp.x = 275;
			downNumImp.disabled = upNumImp.disabled = true;
			addChild(downNumImp);
			addChild(upNumImp);
	
		}
		public function okMessage():void
		{
			addChild(okButt)
		}
		public function clear():void
		{
			cheaterTimer.reset();
			if(downNumImp!=null)
				if(contains(downNumImp))
					removeChild(downNumImp);
			if(upNumImp!=null)
				if(contains(upNumImp))
					removeChild(upNumImp);
			if(contains(callCheaterButt))
				removeChild(callCheaterButt);	
			if(contains(trustButt))
				removeChild(trustButt);	
			if(contains(okButt))
				removeChild(okButt);		
						
			textField.text = "";
		}
		
	}
}