package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	public  class API_Got_graphic_command extends API_Message {
		public var new_movie_parents:Array/*int*/;
		public var new_movie_name_ids:Array/*int*/;
		public var graphic_commands:Array/*Object*/;
		public function API_Got_graphic_command(new_movie_parents:Array/*int*/, new_movie_name_ids:Array/*int*/, graphic_commands:Array/*Object*/) { super('got_graphic_command',arguments); 
			this.new_movie_parents = new_movie_parents;
			this.new_movie_name_ids = new_movie_name_ids;
			this.graphic_commands = graphic_commands;
		}
		override public function getParametersAsString():String { return 'new_movie_parents=' + JSON.stringify(new_movie_parents)+', new_movie_name_ids=' + JSON.stringify(new_movie_name_ids)+', graphic_commands=' + JSON.stringify(graphic_commands); }
	}
}
