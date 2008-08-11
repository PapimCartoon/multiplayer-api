//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoConnectedMatchOver extends API_Message {
		public var did_win:Boolean;
		public function API_DoConnectedMatchOver(did_win:Boolean) { super('do_connected_match_over',arguments); 
			this.did_win = did_win;
		}
		/*override*/ public function toString():String { return '{API_DoConnectedMatchOver' + ': did_win=' + JSON.stringify(did_win)+'}'; }
	}
