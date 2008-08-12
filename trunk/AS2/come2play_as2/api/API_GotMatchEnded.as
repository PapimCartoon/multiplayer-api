//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotMatchEnded extends API_Message {
		public var finishedPlayerIds:Array/*int*/;
		public function API_GotMatchEnded(finishedPlayerIds:Array/*int*/) { super('gotMatchEnded',arguments); 
			this.finishedPlayerIds = finishedPlayerIds;
		}
		/*override*/ public function getParametersAsString():String { return 'finishedPlayerIds=' + JSON.stringify(finishedPlayerIds); }
	}
