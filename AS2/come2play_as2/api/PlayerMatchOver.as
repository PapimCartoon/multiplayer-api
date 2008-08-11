//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.PlayerMatchOver  {
		public var player_id:Number;
		public var score:Number;
		public var pot_percentage:Number;
		public function PlayerMatchOver(player_id:Number, score:Number, pot_percentage:Number) {
			this.player_id = player_id;
			this.score = score;
			this.pot_percentage = pot_percentage;
		}
		public static function object2PlayerMatchOver(obj:Object):PlayerMatchOver {
			if (obj.player_id==null) throw new Error('Missing field player_id in creating object of type PlayerMatchOver in object='+JSON.stringify(obj));
			if (obj.score==null) throw new Error('Missing field score in creating object of type PlayerMatchOver in object='+JSON.stringify(obj));
			if (obj.pot_percentage==null) throw new Error('Missing field pot_percentage in creating object of type PlayerMatchOver in object='+JSON.stringify(obj));
			return new PlayerMatchOver(obj.player_id, obj.score, obj.pot_percentage)
		}
		public function toString():String { return '{PlayerMatchOver' + ': player_id=' + JSON.stringify(player_id) + ': score=' + JSON.stringify(score) + ': pot_percentage=' + JSON.stringify(pot_percentage) + '}'; }
	}
