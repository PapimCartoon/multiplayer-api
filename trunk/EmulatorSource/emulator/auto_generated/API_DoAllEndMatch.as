package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	public  class API_DoAllEndMatch extends API_Message {
		public var finishedPlayers:Array/*PlayerMatchOver*/;
		public function API_DoAllEndMatch(finishedPlayers:Array/*PlayerMatchOver*/) { super('doAllEndMatch',arguments); 
			this.finishedPlayers = finishedPlayers;
			for (var i:int=0; i<finishedPlayers.length; i++) finishedPlayers[i] = PlayerMatchOver.object2PlayerMatchOver(finishedPlayers[i]);
		}
		override public function getParametersAsString():String { return 'finishedPlayers=' + JSON.stringify(finishedPlayers); }
	}
}
