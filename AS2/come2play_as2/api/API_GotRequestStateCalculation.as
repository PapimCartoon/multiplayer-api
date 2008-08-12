//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotRequestStateCalculation extends API_Message {
		public var secretSeed:Number;
		public var value:Object/*Serializable*/;
		public function API_GotRequestStateCalculation(secretSeed:Number, value:Object/*Serializable*/) { super('gotRequestStateCalculation',arguments); 
			this.secretSeed = secretSeed;
			this.value = value;
		}
		/*override*/ public function getParametersAsString():String { return 'secretSeed=' + JSON.stringify(secretSeed)+', value=' + JSON.stringify(value); }
	}
