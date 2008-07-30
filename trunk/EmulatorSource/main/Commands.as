package main{
	import come2play_as3.api.*;
	public class Commands {
		/*		
			for each (var command_name:String in Commands.getCommandNames(true)) {
			}

			var args:Array = Commands.findCommand(command_name);
			var parameters:Array = [];
			for (i=0; i< args.length; i++) {
				var param:String = aParams[i].Value;
				var param_type:String = args[i][1];
				parameters.push( Commands.convertToType(param, param_type) );
			}
			
			var parameters:Array = Commands.findCommand(command_name);
			for (i=0; i<parameters.length; i++) {
				var param_name:String = parameters[i][0];
				var param_type:String = parameters[i][1];
				prm = aParams[i];
				prm.Label = param_name+":"+param_type;
				prm.visible = true;
			}
			btnSend.y = 32 * parameters.length + 35;
		*/
		private static var all_commands:Array = SummaryGameAPI.SUMMARY_API;
		{
			all_commands.push(['do_store_trace', [['name','String'] , ['message','Object']] ] );
		}

		public static function findCommand(name:String):Array {
			for each (var arr:Array in all_commands)
				if (arr[0]==name) return arr[1];
			throw new Error("Didn't find operation/callback called "+name);
		}
		public static function getCommandNames(is_got:Boolean):Array {
			var res:Array = [];	
			for each (var arr:Array in all_commands) {
				var command_name:String = arr[0];
				if ((is_got && command_name.substring(0,4)=="got_") || (!is_got && command_name.substring(0,3)=="do_"))
					res.push(command_name);
			}
			return res;
		}

		// types: int, String, boolean, Object, int[], String[], boolean[], Object[]
		private static function isOfType(obj:Object, type:String):Boolean {
			if (type=="int") return obj is int;
			if (type=="String") return obj is String;
			if (type=="boolean") return obj is Boolean;
			if (type=="Object") return true;
			if (type=="int[]" || type=="String[]" || type=="boolean[]" || type=="Object[]") {
				if (!(obj is Array)) return false;
				for each (var elem:Object in obj)
					if (!isOfType(elem, type.substring(0,type.length-2) )) return false;
				return true;
			}
			return false;
		}
		public static function convertToType(str:String, type:String):Object {
			if (type=="String") return str;
			var res:Object = JSON.parse(str);
			if (isOfType(res, type)) return res; 
			throw new Error("String '"+str+"' is not of type "+type);
		}
	}
}