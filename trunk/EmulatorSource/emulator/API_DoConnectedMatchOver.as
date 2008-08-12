package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class API_DoConnectedMatchOver extends API_Message {
		public var didWin:Boolean;
		public function API_DoConnectedMatchOver(didWin:Boolean) { super('doConnectedMatchOver',arguments); 
			this.didWin = didWin;
		}
		override public function getParametersAsString():String { return 'didWin=' + JSON.stringify(didWin); }
	}
}
