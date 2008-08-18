//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllEndMatch extends API_Message {
		public var finishedPlayers:Array/*PlayerMatchOver*/;
		public function API_DoAllEndMatch(finishedPlayers:Array/*PlayerMatchOver*/) { super('doAllEndMatch',arguments); 
			this.finishedPlayers = finishedPlayers;
			for (var i:Number=0; i<finishedPlayers.length; i++) finishedPlayers[i] = PlayerMatchOver.object2PlayerMatchOver(finishedPlayers[i]);
		}
		/*override*/ public function getParametersAsString():String { return 'finishedPlayers=' + JSON.stringify(finishedPlayers); }
	}
