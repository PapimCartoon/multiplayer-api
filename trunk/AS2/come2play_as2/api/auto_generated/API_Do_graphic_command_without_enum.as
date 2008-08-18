//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_Do_graphic_command_without_enum extends API_Message {
		public var movie_id:Number;
		public var func_name:String;
		public var func_args:Array/*Object*/;
		public function API_Do_graphic_command_without_enum(movie_id:Number, func_name:String, func_args:Array/*Object*/) { super('do_graphic_command_without_enum',arguments); 
			this.movie_id = movie_id;
			this.func_name = func_name;
			this.func_args = func_args;
		}
		/*override*/ public function getParametersAsString():String { return 'movie_id=' + JSON.stringify(movie_id)+', func_name=' + JSON.stringify(func_name)+', func_args=' + JSON.stringify(func_args); }
	}
