package emulator
{
	import emulator.auto_copied.JSON;
	import emulator.auto_generated.API_GotCustomInfo;
	import emulator.auto_generated.API_GotKeyboardEvent;
	import emulator.auto_generated.API_GotMatchEnded;
	import emulator.auto_generated.API_GotMatchStarted;
	import emulator.auto_generated.API_GotRequestStateCalculation;
	import emulator.auto_generated.API_GotStateChanged;
	import emulator.auto_generated.API_GotUserDisconnected;
	import emulator.auto_generated.API_GotUserInfo;
	import emulator.auto_generated.API_Message;
	
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	public class MessageBoxGraphic extends EntryWindow
	{
		private var messageNum:int;
		private var holdingWindow:Boolean;
		private var catchPosX:int;
		private var catchPosY:int;
		public function MessageBoxGraphic(func:Function)
		{
			messageNum = 0;
			windowBack.addEventListener(MouseEvent.MOUSE_DOWN,holdWindow);
			windowBack.addEventListener(MouseEvent.MOUSE_UP,leaveWindow);
			addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			nextBtn.addEventListener(MouseEvent.CLICK,function (ev:MouseEvent):void{holdingWindow = false;  func.apply(this);});
			MessageSent.autoSize = TextFieldAutoSize.RIGHT;
		}
		private function holdWindow(ev:MouseEvent):void{
		holdingWindow = true;
		catchPosX = ev.localX;
		catchPosY = ev.localY;
		}
		private function leaveWindow(ev:MouseEvent):void{holdingWindow = false;	}
		private function mouseMove(ev:MouseEvent):void{
			if(holdingWindow)
			{
				this.x = ev.stageX +this.width/2 - catchPosX;
				this.y = ev.stageY +this.height/2- catchPosY;
			}
		}
		public function setMessage(text:String):void
		{
			messageNum++;
			MessageSent.text = text + "Message" +messageNum;	
		}
		public function changeMessage(msg:API_Message):void
		{
			if(msg is API_GotCustomInfo)
				setMessage("GotCustomInfo");
			else if(msg is API_GotKeyboardEvent)
				setMessage("GotKeyboardEvent");
			else if(msg is API_GotMatchEnded)
				setMessage("GotMatchEnded");
			else if(msg is API_GotMatchStarted)
				setMessage("GotMatchStarted");
			else if(msg is API_GotRequestStateCalculation)
				setMessage("GotRequestStateCalculation");
			else if(msg is API_GotStateChanged)
				setMessage("GotStateChanged");
			else if(msg is API_GotUserDisconnected)
				setMessage("GotUserDisconnected");
			else if(msg is API_GotUserInfo)
				setMessage("GotUserInfo");
			MessageData.text = JSON.stringify(msg)
		}
		{
			
		}

	}
}