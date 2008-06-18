/**
 * All documentation for this class is online at:
 * http://www.come2play.com/ClientGameAPI/
 */ 
import flash.external.*;

class BaseGameAPI
{
	// we use a LocalConnection to communicate with the container
	private var lcUser:LocalConnection;  
	public var iChanel:Number;
	private var sDoChanel:String;
	private var sGotChanel:String;
	private var sPrefix:String = "";
	
	//Constructor
	public function BaseGameAPI(parameters:Object) {
		sPrefix = parameters["prefix"];
		if (sPrefix==undefined || sPrefix==null)
			throw new Error("You must pass the parameter 'prefix'. Please only test your games inside the Come2Play emulator");
		if (!(sPrefix.charAt(0)>='0' && sPrefix.charAt(0)<='9')) {
			// calling a javascript function that should return the random fixed id
			var js_result:Object = ExternalInterface.call(sPrefix);
			sPrefix = ''+js_result;
		}
		iChanel = Math.floor(Math.random() * 10000);
		
		lcUser = new LocalConnection();            
		lcUser.onStatus = function(infoObject:Object) {
			switch (infoObject.level) {
			case "error":
				passError("LocalConnection-onStatus", new Error());
				break;
		}
		}
		var obj:BaseGameAPI = this;
		lcUser.client = this;
		lcUser.localconnection_callback = function(methodName:String, parameters:Array/*Object*/):Void {
			obj.localconnection_callback(methodName, parameters);
		}
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
		if (obj instanceof Number || obj instanceof Boolean || obj instanceof String) return true;
		if (obj instanceof Array) {
			for (var i:Number = 0; i < obj.length;i++){
				if (!isSerializable(obj[i])) return false;
			}
			return true;
		}			
		return false;
	}
	private function passError(in_function_name:String, err:Error):Void {
		try{
			got_error(in_function_name, err);
		} catch (err2:Error) { 
			// to avoid an infinite loop, I can't call passError again.
			trace("Error occurred when calling got_error("+in_function_name+","+err+"). The error is="+err2);
		}
	}
	private function sendDoOperation(methodName:String, parameters:Array/*Object*/):Void {
		sendOperation(sDoChanel, methodName, parameters);
	}
	private function sendOperation(connectionName:String, methodName:String, parameters:Array/*Object*/):Void {
		try {
			//trace("sendOperation:"+connectionName+" methodName="+methodName+" parameters="+parameters);
			lcUser.send(connectionName, "localconnection_callback", methodName, parameters);  
		}catch(err:Error) { 
			passError(methodName, err);
		}      	
	}
	private function localconnection_callback(methodName:String, parameters:Array/*Object*/):Void {
		try{
			var func:Function = this[methodName];
			if (func!=null)
				func.apply(this, parameters);
		} catch(err:Error) { 
			passError(methodName, err);
		} finally {
			sendDoOperation("do_finished_callback", [methodName]);
		}
	}

	// In case of an error, you should probably call do_client_protocol_error_with_description
	// You should be very careful not to throw any exceptions in got_error, because they are silently ignored	
	public function got_error(in_function_name:String, err:Error):Void {}
		
	//Do functions. You may call these functions.
	public function do_register_on_server():Void {
		sendOperation("FRAMEWORK_SWF"+sPrefix, "do_register_on_server", [iChanel]);
	}
	public function do_store_trace(funcname:String, args:Object):Void {
		sendDoOperation("do_store_trace", arguments);
	}
}