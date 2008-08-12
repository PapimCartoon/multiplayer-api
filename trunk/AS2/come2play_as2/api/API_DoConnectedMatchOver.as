//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoConnectedMatchOver extends API_Message {
		public var didWin:Boolean;
		public function API_DoConnectedMatchOver(didWin:Boolean) { super('doConnectedMatchOver',arguments); 
			this.didWin = didWin;
		}
		/*override*/ public function getParametersAsString():String { return 'didWin=' + JSON.stringify(didWin); }
	}
