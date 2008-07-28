package come2play_as3.api {
	import come2play_as3.util.*;
	
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.utils.*;
	
	/**
	 * See http://code.google.com/p/multiplayer-api
	 */ 
	public class BaseGameAPI
	{
		public static function error(msg:String):void {
			trace("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n An ERRRRRRRRRRROR occurred:\n"+msg+"\n\n\n\n\n\n\n\n\n");
		}
		public static function throwError(msg:String):void {
			error("Throwing an error with message="+msg);
			throw new Error(msg);
		}
		public static function getDoChanelString(sPrefix:String, iChanel:int):String {
			return "DO_CHANEL"+sPrefix+"_" + iChanel;
		}
		public static function getGotChanelString(sPrefix:String, iChanel:int):String {
			return "GOT_CHANEL"+sPrefix+"_" + iChanel;
		}
		public static function getHandshakeString(sPrefix:String):String {
			return "FRAMEWORK_SWF"+sPrefix;
		}
		// we use a LocalConnection to communicate with the container
		private var lcUser:LocalConnection;  
		private var iChanel:int;
		private var sDoChanel:String;
		private var sGotChanel:String;
		private var sPrefix:String;
		
		//Constructor
		public function BaseGameAPI(parameters:Object) {
			sPrefix = parameters["prefix"];
			if (sPrefix==null) sPrefix = parameters["?prefix"];
			if (sPrefix==null) 
				throwError("You must pass the parameter 'prefix'. Please only test your games inside the Come2Play emulator. parameters passed="+JSON.stringify(parameters));
			if (!(sPrefix.charAt(0)>='0' && sPrefix.charAt(0)<='9')) {
				// calling a javascript function that should return the random fixed id
				var js_result:Object = ExternalInterface.call(sPrefix);
				sPrefix = ''+js_result;
			}
			iChanel = Math.floor(Math.random() * 10000);
			
			lcUser = new LocalConnection();
			AS3_vs_AS2.addStatusListener(lcUser, this, ["localconnection_callback"]);
			
			sDoChanel = getDoChanelString(sPrefix, iChanel);
			sGotChanel = getGotChanelString(sPrefix, iChanel);
			try{
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
				for each (var o:Object in obj) {
					res.push( makeSerializable(o) );
				}
				return res;
			}			
			return obj.toString();
		}
		public static function assertSerializable(obj:Object):void {
			if (obj==null || 
				AS3_vs_AS2.isNumber(obj) || 
				AS3_vs_AS2.isBoolean(obj) || 
				AS3_vs_AS2.isString(obj)) return;
			if (AS3_vs_AS2.isArray(obj)) {
				for each (var o:Object in obj) {
					assertSerializable(o);
				}
				return;
			}			
			throwError("The parameters to a do_* operation must be serializable! argument="+obj+" whose type="+AS3_vs_AS2.getClassName(obj));
		}
        private function passError(in_function_name:String, err:Error):void {
        	try{
				got_error(in_function_name, err);
			} catch (err2:Error) { 
				// to avoid an infinite loop, I can't call passError again.
				error("Error occurred when calling got_error("+in_function_name+","+AS3_vs_AS2.error2String(err)+"). The error is="+AS3_vs_AS2.error2String(err2));
			}
        }
        protected function sendDoOperation(methodName:String, parameters:Array/*Object*/):void {
			sendOperation(sDoChanel, methodName, translateCallbackParameters(methodName, parameters));
        }
        protected function sendOperation(connectionName:String, methodName:String, parameters:Array/*Object*/):void {
			trace("sendOperation on channel="+connectionName+' for methodName='+methodName+' parameters='+parameters);
			assertSerializable(parameters); // must be outside the try block or we'll get infinite recursion!			  
			try{
				lcUser.send(connectionName, "localconnection_callback", methodName, parameters);  
			}catch(err:Error) { 
				passError(methodName, err);
			}      	
        }

		private var saved_parameters_for_got_match_started:Array;
		private var saved_finished_player_ids:Array;
        public function localconnection_callback(methodName:String, parameters:Array/*Object*/):void {
        	try{
        		trace("got localconnection_callback methodName="+methodName+" parameters="+parameters);
				if (methodName=="got_match_started") {
					saved_parameters_for_got_match_started = parameters;
					saved_finished_player_ids = null;
					return;
				}
				
				if (saved_parameters_for_got_match_started!=null) {
					if (methodName=="got_match_over") {
						if (saved_finished_player_ids!=null) throwError("got_match_over can be called only once after got_match_started before we pass the match state");
						saved_finished_player_ids = parameters[0];
						return;						
					}
					var is_got_secure_stored_match_state:Boolean = methodName=="got_secure_stored_match_state";
					var is_got_stored_match_state:Boolean = methodName=="got_stored_match_state";
					if (!is_got_stored_match_state && !is_got_secure_stored_match_state)
						throwError("The first API callback after got_match_started must be stored_match_state, and we got="+methodName);
					methodName = "got_match_started";
					if (is_got_secure_stored_match_state) {
						// got_secure_stored_match_state(secret_levels:Array/*int*/, user_ids:Array/*int*/, keys:Array/*String*/, values:Array/*Serializable*/)
						// I remove secret_levels from parameters
						parameters.shift();
					}
					if (saved_finished_player_ids==null) saved_finished_player_ids = [];
					parameters = [saved_finished_player_ids].concat(saved_parameters_for_got_match_started.concat(parameters));
					saved_parameters_for_got_match_started = null;
				}
				safeApplyFunction(methodName, translateCallbackParameters(methodName, parameters) );
			} catch(err:Error) { 
				passError(methodName, err);
			} finally {
				sendDoOperation("do_finished_callback", [methodName]);
			}
        }
        private function getFunction(methodName:String):Function {
        	if (!AS3_vs_AS2.hasOwnProperty(this,methodName)) return null;
			return this[methodName] as Function;
        }
		private function safeApplyFunction(methodName:String, args:Array):Object {			
			var func:Function = getFunction(methodName);
			if (func==null) return null;
			return func.apply(this, args);
		}

		
		// In case of an error, you should probably call do_client_protocol_error_with_description
		// You should be very careful not to throw any exceptions in got_error, because they are silently ignored	
		public function got_error(in_function_name:String, err:Error):void {
			error("got_error in_function_name="+in_function_name+" err="+AS3_vs_AS2.error2String(err));
		}

		protected function translateCallbackParameters(methodName:String, parameters:Array/*Object*/):Array/*Object*/ {
			var translate_name:String = "translate_"+methodName;
			if (getFunction(translate_name)==null) return parameters;
			return AS3_vs_AS2.asArray(safeApplyFunction(translate_name, parameters));
		}
		private function translate_entries(keys:Array/*String*/, values:Array/*Serializable*/):Array {
			var res:Array = [];
			var len:int = keys.length;
			if (len!=values.length) throwError("keys="+keys+" and values="+values+" must have the same length!");
			for (var i:int = 0; i<len; i++)
				res[i] = new Entry(AS3_vs_AS2.asString(keys[i]), values[i]);
			return res;
		}
		private function translate_user_entries(user_ids:Array/*int*/, keys:Array/*String*/, values:Array/*Serializable*/):Array {
			var res:Array = [];
			var len:int = keys.length;
			if (len!=values.length || len!=user_ids.length) throwError("keys="+keys+" and values="+values+" and user_ids="+user_ids+" must have the same length!");
			for (var i:int = 0; i<len; i++)
				res[i] = new UserEntry(AS3_vs_AS2.asString(keys[i]), values[i], AS3_vs_AS2.as_int(user_ids[i]));
			return res;
		}
		public function translate_got_general_info(keys:Array/*String*/, values:Array/*Serializable*/):Array {
			//got_general_info(entries:Array/*Entry*/)
			return [translate_entries(keys, values)];
		}
		public function translate_got_user_info(user_id:int, keys:Array/*String*/, values:Array/*Serializable*/):Array {
			//got_user_info(user_id:int, entries:Array/*Entry*/)
			return [user_id, translate_entries(keys, values)];
		}
		public function translate_got_match_started(
			finished_player_ids:Array/*int*/,
			player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:int,
			user_ids:Array/*int*/, keys:Array/*String*/, values:Array/*Serializable*/):Array {
			//got_match_started(player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:int, match_state:Array/*UserEntry*/)
			return [player_ids, finished_player_ids, extra_match_info, match_started_time, translate_user_entries(user_ids, keys, values) ];
		}		
		private function assert_length(arr:Array, len:int):void {
			if (arr.length!=len) throwError("Array "+arr+" length="+len);
		}
		public function translate_got_stored_match_state(user_ids:Array/*int*/, keys:Array/*String*/, values:Array/*Serializable*/):Array {
			//"All arrays in got_stored_match_state (except the first after got_match_started) should be of length 1
			assert_length(user_ids,1);
			assert_length(keys,1);
			assert_length(values,1);
			//got_stored_match_state(user_entry:UserEntry)
			return [new UserEntry(keys[0], values[0], user_ids[0])];
		}		
		public function translate_got_secure_stored_match_state(secret_levels:Array/*int*/, user_ids:Array/*int*/, keys:Array/*String*/, values:Array/*Serializable*/):Array {
			assert_length(secret_levels,1);
			//got_secure_stored_match_state(secret_level:int, user_entry:UserEntry)
			return [AS3_vs_AS2.as_int(secret_levels[0])].concat(translate_got_stored_match_state(user_ids, keys, values));
		}
		public function translate_do_set_timer(in_seconds:int, entry:Entry):Array {
			//do_set_timer(key:String, in_seconds:int, pass_back:Object/*Serializable*/)
			return [entry.key, in_seconds, entry.value];
		}
		public function translate_got_timer(from_user_id:int, key:String, in_seconds:int, pass_back:Object/*Serializable*/):Array {
			//got_timer(in_seconds:int, user_entry:UserEntry)
			return [in_seconds, new UserEntry(key, pass_back, from_user_id)];
		}		
		public function translate_do_juror_store_match_state(secret_level:int, user_entry:UserEntry):Array {
			//do_juror_store_match_state(secret_level:int, key:String, value:Object/*Serializable*/, for_user_id:int)
			return [secret_level, user_entry.key, user_entry.value, user_entry.user_id];
		}
		public function translate_do_user_store_match_state(secret_level:int, entry:Entry):Array {
			//do_user_store_match_state(secret_level:int, key:String, value:Object/*Serializable*/)
			return [secret_level, entry.key, entry.value];
		}
		public function translate_do_store_match_state(entry:Entry):Array {
			//do_store_match_state(key:String, value:Object/*Serializable*/)
			return [entry.key, entry.value];
		}
		public function translate_do_juror_end_match(finished_players:Array/*PlayerMatchOver*/):Array {
			var finished_player_ids:Array/*int*/ = [];
			var scores:Array/*int*/ = [];
			var pot_percentages:Array/*int*/ = [];
			for (var i:int = 0; i<finished_players.length; i++) {
				var playerMatchOver:PlayerMatchOver = finished_players[i];
				finished_player_ids[i] = playerMatchOver.player_id;
				scores[i] = playerMatchOver.score;
				pot_percentages[i] = playerMatchOver.pot_percentage;
			}
			//do_juror_end_match(finished_player_ids:Array/*int*/, scores:Array/*int*/, pot_percentages:Array/*int*/)
			return [finished_player_ids, scores, pot_percentages];
		}		
		public function translate_do_agree_on_match_over(finished_players:Array/*PlayerMatchOver*/):Array {
			//do_agree_on_match_over(player_ids:Array/*int*/, scores:Array/*int*/, pot_percentages:Array/*int*/)
			return translate_do_juror_end_match(finished_players);
		}

		
		public function do_register_on_server():void {
			// Weird flash error: 
			// 1) Board listens on channel=GOT_CHANEL1439604_2620
			// 2) Board -> Container: called do_register_on_server on channel=FRAMEWORK_SWF1439604 with parameters=2620
			// 3) Container -> Board: called got_my_user_id on GOT_CHANEL1439604_2620
			// step 3 caused an error on the container localconnection (even if the container waited 10 seconds)
			// the only solution for this problem, was that the board should wait before calling do_register_on_server
			trace("Postponing calling  do_register_on_server"); 
			AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this,this.waitBeforeRegister), 100); 	
		}
		private function waitBeforeRegister():void {
			trace("Now calling  do_register_on_server");
			sendOperation(getHandshakeString(sPrefix), "do_register_on_server", [iChanel]);
		}
		
		public function do_store_trace(funcname:String, args:Object):void {
			sendDoOperation("do_store_trace", [funcname, makeSerializable(args)]);
		}
	}
}