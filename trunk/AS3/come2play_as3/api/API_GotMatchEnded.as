package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_GotMatchEnded extends API_Message {
		public var finishedPlayerIds:Array/*int*/;
		public function API_GotMatchEnded(finishedPlayerIds:Array/*int*/) { super('gotMatchEnded',arguments); 
			this.finishedPlayerIds = finishedPlayerIds;
		}
		override public function getParametersAsString():String { return 'finishedPlayerIds=' + JSON.stringify(finishedPlayerIds); }
	}
}
