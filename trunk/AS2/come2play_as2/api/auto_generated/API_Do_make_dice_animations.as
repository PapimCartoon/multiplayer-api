//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_Do_make_dice_animations extends API_Message {
		public var with_animation:Boolean;
		public function API_Do_make_dice_animations(with_animation:Boolean) { super('do_make_dice_animations',arguments); 
			this.with_animation = with_animation;
		}
		/*override*/ public function getParametersAsString():String { return 'with_animation=' + JSON.stringify(with_animation); }
	}
