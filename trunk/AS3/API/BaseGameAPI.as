package {
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	
	/**
	 * See http://code.google.com/p/multiplayer-api
	 */ 
	public class BaseGameAPI
	{
		// we use a LocalConnection to communicate with the container
		private var lcUser:LocalConnection;  
		private var iChanel:int;
		private var sDoChanel:String;
		private var sGotChanel:String;
		private var sPrefix:String="";
		
		//Constructor
		public function BaseGameAPI(parameters:Object):void {
			sPrefix = parameters["prefix"];
			if (sPrefix==null) 
				throw new Error("You must pass the parameter 'prefix'. Please only test your games inside the Come2Play emulator");
			if (!(sPrefix.charAt(0)>='0' && sPrefix.charAt(0)<='9')) {
				// calling a javascript function that should return the random fixed id
				var js_result:Object = ExternalInterface.call(sPrefix);
				sPrefix = ''+js_result;
			}
			iChanel = Math.floor(Math.random() * 10000);
			
			lcUser = new LocalConnection();            
			lcUser.addEventListener(StatusEvent.STATUS, onStatus);
			lcUser.client = this;
			sDoChanel = "DO_CHANEL"+sPrefix+"_" + iChanel;
			sGotChanel = "GOT_CHANEL"+sPrefix+"_" + iChanel;
			try{
				lcUser.connect(sGotChanel);
			}catch (err:Error) { 
				passError("Constructor",err);
			}
		}
		// Make sure all your Object arguments are serializable
		public function isSerializable(obj:Object):Boolean {
			if (obj is int || obj is Boolean || obj is String) return true;
			if (obj is Array) {
				for each (var o:Object in obj)
					if (!isSerializable(o)) return false;
				return true;
			}			
			return false;
		}
        private function onStatus(event:StatusEvent):void {
            switch (event.level) {
                case "error":
                    passError("LocalConnection-onStatus", new Error());
                    break;
            }
        }
        private function passError(in_function_name:String, err:Error):void {
        	try{
				got_error(in_function_name, err);
			} catch (err2:Error) { 
				// to avoid an infinite loop, I can't call passError again.
				trace("Error occurred when calling got_error("+in_function_name+","+err+"). The error is="+err2);
			}
        }
        protected function sendDoOperation(methodName:String, parameters:Array/*Object*/):void {
        	sendOperation(sDoChanel, methodName, parameters);
        }
        protected function sendOperation(connectionName:String, methodName:String, parameters:Array/*Object*/):void {
			try{
				lcUser.send(connectionName, "localconnection_callback", methodName, parameters);  
			}catch(err:Error) { 
				passError(methodName, err);
			}      	
        }
        public function localconnection_callback(methodName:String, parameters:Array/*Object*/):void {
        	try{
				var func:Function = this[methodName] as Function;
				if (func!=null)
					func.apply(this, parameters);
			} catch(err:Error) { 
				passError(methodName, err);
			}  
        }
		
		// In case of an error, you should probably call do_client_protocol_error_with_description
		// You should be very careful not to throw any exceptions in got_error, because they are silently ignored	
		public function got_error(in_function_name:String, err:Error):void {}
		
		
		public function do_register_on_server():void {
			sendOperation("FRAMEWORK_SWF"+sPrefix, "do_register_on_server", [iChanel]);
		}
		public function do_store_trace(funcname:String, args:Object):void {
			sendDoOperation("do_store_trace", arguments);
		}
	}
}