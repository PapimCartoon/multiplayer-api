package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	import come2play_as3.api.*
	public  class API_DoConnectedEndMatch extends API_Message {
		public var didWin:Boolean;
		public function API_DoConnectedEndMatch(didWin:Boolean) { super('doConnectedEndMatch',arguments); 
			this.didWin = didWin;
		}
		override public function getParametersAsString():String { return 'didWin=' + JSON.stringify(didWin); }
	}
}
