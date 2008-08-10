	import come2play_as2.util.*;
	
	import flash.external.*;
	
	/**
	 * See http://code.google.com/p/multiplayer-api
	 */ 
import come2play_as2.api.*;
	class come2play_as2.api.BaseGameAPI extends API_TranslateInterface
	{
		// See method ClientGameAPI.got_user_info
		public static var USER_INFO_KEY_name:String = "name";
		public static var USER_INFO_KEY_avatar_url:String = "avatar_url";
		public static var USER_INFO_KEY_supervisor:String = "supervisor";
		public static var USER_INFO_KEY_credibility:String = "credibility";
		public static var USER_INFO_KEY_game_rating:String = "game_rating";
		
		// See method ClientGameAPI.got_general_info
		public static var GENERAL_INFO_KEY_logo_swf_full_url:String = "logo_swf_full_url";
		
		
		public static var DEFAULT_LOCALCONNECTION_PREFIX:String = "42";
		
		private static var someMovieClip:MovieClip;
		public static function error(msg:String):Void {
			var msg:String = "An ERRRRRRRRRRROR occurred:\n"+msg;
			System.setClipboard(msg);
			AS3_vs_AS2.showError(someMovieClip, msg);
			trace("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"+msg+"\n\n\n\n\n\n\n\n\n");
		}
		public static function throwError(msg:String):Void {
			error("Throwing an error with message="+msg+"." + (!AS3_vs_AS2.isAS3 ? "" :  "The error was thrown in this location="+AS3_vs_AS2.error2String(new Error())));
			throw new Error(msg);
		}		
		public static function assert(val:Boolean, args:Array):Void {
			if (!val) BaseGameAPI.throwError("Assertion failed with arguments: "+args.join(" , "));
		}
		public static function getDoChanelString(sPrefix:String):String {
			return "DO_CHANEL_"+sPrefix;
		}
		public static function getGotChanelString(sPrefix:String):String {
			return "GOT_CHANEL_"+sPrefix;
		}
		// we use a LocalConnection to communicate with the container
		private var lcUser:LocalConnection; 
		private var sDoChanel:String;
		private var sGotChanel:String;
		
		//Constructor
		public function BaseGameAPI(_someMovieClip:MovieClip) {
			try{
				someMovieClip = _someMovieClip;
				var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(someMovieClip);
				var sPrefix:String = parameters["prefix"];
				if (sPrefix==null) sPrefix = parameters["?prefix"];
				if (sPrefix==null) {
					trace("WARNING: didn't find 'prefix' in the loader info parameters. Probably because you are doing testing locally.\n\n\n\n\n\n");
					sPrefix = DEFAULT_LOCALCONNECTION_PREFIX;
					new SinglePlayerEmulator(_someMovieClip);
				}
				if (!(sPrefix.charAt(0)>='0' && sPrefix.charAt(0)<='9')) { //it is not necessarily a number (in InfoContainer we concatenate two numbers using '_')
					trace("calling a javascript function that should return the random fixed id");
					var js_result:Object = ExternalInterface.call(sPrefix);
					sPrefix = ''+js_result;
				}
				
				lcUser = new LocalConnection();
				AS3_vs_AS2.addStatusListener(lcUser, this, ["localconnection_callback"]);
				
				sDoChanel = getDoChanelString(sPrefix);
				sGotChanel = getGotChanelString(sPrefix);
				trace("Board connected on channel="+sGotChanel);
				lcUser.connect(sGotChanel);
			}catch (err:Error) { 
				passError("Constructor",err);
			}
		}
		// Make sure all your Object arguments are serializable
		public static function makeSerializable(obj:Object):Object {
			if (obj==null || 
				AS3_vs_AS2.isNumber(obj) || 
				AS3_vs_AS2.isBoolean(obj) || 
				AS3_vs_AS2.isString(obj)) return obj;
			if (AS3_vs_AS2.isArray(obj)) {
				var res:Array = [];
				for (var i90:Number=0; i90<obj.length; i90++) { var o:Object = obj[i90]; 
					res.push( makeSerializable(o) );
				}
				return res;
			}			
			return obj.toString();
		}
		public static function assertSerializable(obj:Object):Void {
			if (obj==null || 
				AS3_vs_AS2.isNumber(obj) || 
				AS3_vs_AS2.isBoolean(obj) || 
				AS3_vs_AS2.isString(obj)) return;
			if (AS3_vs_AS2.isArray(obj)) {
				for (var i103:Number=0; i103<obj.length; i103++) { var o:Object = obj[i103]; 
					assertSerializable(o);
				}
				return;
			}			
			throwError("The parameters to a do_* operation must be serializable! argument="+obj+" whose type="+AS3_vs_AS2.getClassName(obj));
		}
        private function passError(in_function_name:String, err:Error):Void {
        	try{
				error("Error occurred when calling "+in_function_name+", the error is="+AS3_vs_AS2.error2String(err));
				got_error(in_function_name, err);
			} catch (err2:Error) { 
				// to avoid an infinite loop, I can't call passError again.
				error("Another error occurred when calling got_error("+in_function_name+","+AS3_vs_AS2.error2String(err)+"). The error is="+AS3_vs_AS2.error2String(err2));
			}
        }
        private function sendDoOperation(methodName:String, parameters:Array/*Object*/):Void {
        	parameters = translateCallbackParameters(methodName, parameters);
        	store_api_trace(["send operation", arguments]);
			trace("sendOperation on channel="+sDoChanel+' for methodName='+methodName+' parameters='+parameters);
			assertSerializable(parameters); // must be outside the try block or we'll get infinite recursion!			  
			try{
				lcUser.send(sDoChanel, "localconnection_callback", methodName, parameters);  
			}catch(err:Error) { 
				passError(methodName, err);
			}      	
        }

        public function localconnection_callback(methodName:String, parameters:Array/*Object*/):Void {
        	try{
        		trace("got localconnection_callback methodName="+methodName+" parameters="+parameters);
        		var params:Array = translateCallbackParameters(methodName, parameters);	
        		store_api_trace(["got callback", methodName, params]);
				safeApplyFunction(methodName, params);
			} catch(err:Error) { 
				passError(methodName, err);
			} finally {
				sendDoOperation("do_finished_callback", [methodName]);
			}
        }
        private function getFunction(methodName:String):Function {
        	if (!AS3_vs_AS2.hasOwnProperty(this,methodName)) return null;
			return this[methodName] /*as Function*/;
        }
		private function safeApplyFunction(methodName:String, args:Array):Object {			
			var func:Function = getFunction(methodName);
			if (func==null) return null;
			return func.apply(this, args);
		}

		
		// In case of an error, you should probably call do_client_protocol_error_with_description
		// You should be very careful not to throw any exceptions in got_error, because they are silently ignored	
		public function got_error(in_function_name:String, err:Error):Void {}

		private function translateCallbackParameters(methodName:String, parameters:Array/*Object*/):Array/*Object*/ {
			var translate_name:String = "translate_"+methodName;
			if (getFunction(translate_name)==null) return parameters;
			return AS3_vs_AS2.asArray(safeApplyFunction(translate_name, parameters));
		}
		private function translate_entries(keys:Array/*String*/, values:Array/*Serializable*/, secret_levels:Array/*int*/):Array {
			var res:Array = [];
			var len:Number = keys.length;
			if (len!=values.length) throwError("keys="+keys+" and values="+values+" must have the same length!");
			for (var i:Number = 0; i<len; i++) {
				var entry:Entry = new Entry(AS3_vs_AS2.asString(keys[i]), values[i]);
				if (secret_levels!=null) entry.secret_level = EnumSecretLevel.getFromId(secret_levels[i]);
				res[i] = entry;
			}
			return res;
		}
		private function translate_user_entries(user_ids:Array/*int*/, keys:Array/*String*/, values:Array/*Serializable*/, secret_levels:Array/*int*/):Array {
			var res:Array = [];
			var len:Number = keys.length;
			if (len!=values.length || len!=user_ids.length) throwError("keys="+keys+" and values="+values+" and user_ids="+user_ids+" must have the same length!");
			for (var i:Number = 0; i<len; i++) {
				var entry:UserEntry = new UserEntry(AS3_vs_AS2.asString(keys[i]), values[i], AS3_vs_AS2.as_int(user_ids[i]));
				if (secret_levels!=null) entry.secret_level = EnumSecretLevel.getFromId(secret_levels[i]); 
				res[i] = entry;
			}
			return res;
		}
		public function translate_got_general_info(keys:Array/*String*/, values:Array/*Serializable*/):Array {
			return API_TranslateReturns.returns_got_general_info(translate_entries(keys, values, null));
		}
		public function translate_got_user_info(user_id:Number, keys:Array/*String*/, values:Array/*Serializable*/):Array {
			return API_TranslateReturns.returns_got_user_info(user_id, translate_entries(keys, values, null) );
		}
		public function translate_got_match_started(	
			all_player_ids:Array/*int*/, finished_player_ids:Array/*int*/, 
			extra_match_info:Object/*Serializable*/, match_started_time:Number, 
			user_ids:Array/*int*/, keys:Array/*String*/, values:Array/*Serializable*/, 
			secret_levels:Array/*int*/):Array {
			return API_TranslateReturns.returns_got_match_started(all_player_ids, finished_player_ids, extra_match_info, match_started_time, translate_user_entries(user_ids, keys, values, secret_levels) );
		}
		public function translate_got_stored_match_state(user_id:Number, keys:Array/*String*/, values:Array/*Serializable*/, secret_levels:Array/*int*/):Array {
			return API_TranslateReturns.returns_got_stored_match_state(user_id, translate_entries(keys, values, secret_levels) );
		}
		public function translate_do_store_match_state(entries:Array/*Entry*/):Array {
			var keys:Array/*String*/ = [];
			var values:Array/*Serializable*/ = [];
			var secret_levels:Array/*int*/ = [];
			for (var i205:Number=0; i205<entries.length; i205++) { var entry:Entry = entries[i205]; 
				keys.push(entry.key);
				values.push(entry.value);
				secret_levels.push(entry.secret_level.id);
			}
			return API_TranslateReturns.returns_do_store_match_state(keys, values, secret_levels);
		}
		public function translate_do_juror_end_match(finished_players:Array/*PlayerMatchOver*/):Array {
			var finished_player_ids:Array/*int*/ = [];
			var scores:Array/*int*/ = [];
			var pot_percentages:Array/*int*/ = [];
			for (var i:Number = 0; i<finished_players.length; i++) {
				var playerMatchOver:PlayerMatchOver = finished_players[i];
				finished_player_ids[i] = playerMatchOver.player_id;
				scores[i] = playerMatchOver.score;
				pot_percentages[i] = playerMatchOver.pot_percentage;
			}
			return API_TranslateReturns.returns_do_juror_end_match(finished_player_ids, scores, pot_percentages);
		}
		public function translate_do_agree_on_match_over(finished_players:Array/*PlayerMatchOver*/):Array {
			return translate_do_juror_end_match(finished_players);
		}
		public function translate_got_keyboard_event(is_key_down:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Array {
			if (is_key_down && (charCode==84 || charCode==116) // "T" or "t" 
					&& altKey && ctrlKey && shiftKey) {
				do_store_trace("API_TRACES", api_traces);
			} 
			return arguments;
		}

		private var api_traces:Array = [];
		// do not use this trace mechanism to debug your game,
		// use do_store_trace instead.
		// we only use these traces to check bugs in the emulator.
		private function store_api_trace(msg:Object):Void {
			if (api_traces.length>=100) api_traces.shift(); // I don't want the traces to occupy to much memory
			api_traces.push(msg);
		}
		
		public function do_register_on_server():Void {
			// Weird flash error: 
			// 1) Board listens on channel=GOT_CHANEL1439604_2620
			// 2) Board -> Container: called do_register_on_server on channel=FRAMEWORK_SWF1439604 with parameters=2620
			// 3) Container -> Board: called got_my_user_id on GOT_CHANEL1439604_2620
			// step 3 caused an error on the container localconnection (even if the container waited 10 seconds)
			// the only solution for this problem, was that the board should wait before calling do_register_on_server
			trace("Postponing calling  do_register_on_server"); 
			AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this,this.waitBeforeRegister), 100); 	
		}
		private function waitBeforeRegister():Void {
			trace("Now calling  do_register_on_server");
			sendDoOperation("do_register_on_server", []);
		}
		
		public function do_store_trace(funcname:String, args:Object):Void {
			sendDoOperation("do_store_trace", [funcname, makeSerializable(args)]);
		}
	}
