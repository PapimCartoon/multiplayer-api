package come2play_as3.tests {
import come2play_as3.api.*;
import come2play_as3.util.*;

import flash.display.*;
import flash.events.*;
import flash.text.*;

public class TestClientGameAPI extends ClientGameAPI {
	//public var dp:DataProvider = new DataProvider();
	private var my_graphics:MovieClip;
	private var show_localconnection_messages:Boolean;
	private var test_Arr:Array;
	private static const shouldTestPassNumbers:Boolean = false;
	
	public function TestClientGameAPI(my_graphics:MovieClip) {
		trace("Constructor of TestClientGameAPI");
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(my_graphics);
		this.my_graphics = my_graphics;
		show_localconnection_messages = parameters["show_localconnection_messages"]=="true";		
		try {		
			if (shouldTestPassNumbers) {	
				test_Arr = getNumberArr();
				trace("test_Arr="+test_Arr);
			}
			
			addBtnHandler("do_store_trace");
			addBtnHandler("do_agree_on_match_over");
			addBtnHandler("do_start_my_turn");
			addBtnHandler("do_end_my_turn");
			addBtnHandler("do_client_protocol_error_with_description");
			addBtnHandler("do_store_match_state");
			addBtnHandler("do_send_message");
			addBtnHandler("do_set_timer");
			super(my_graphics);
			do_register_on_server();
		} catch (err:Error) { 
			handleError(err);
		}
	}
	
	override public function got_my_user_id(user_id:int):void {		
		if (shouldTestPassNumbers) do_send_message([user_id], test_Arr);
	}
	override public function got_message(user_id:int, value:Object):void {
		if (shouldTestPassNumbers) {
			trace("got_message="+value);
			for (var i:int=0; i<test_Arr.length; i++) {
				var val:int = test_Arr[i];
				var val2:int = value[i];
				if (val!=val2) {
					BaseGameAPI.throwError("Found different values, val="+val+" val2="+val2);
				}
			}			
		}
	}		
	public static function getNumberArr():Array {
		var res:Array = [];
		for (var i:int=0; i<4; i++) {
			var num:Number = Math.random()-0.5;
			while (num!=0 && num!=Number.NEGATIVE_INFINITY && num!=Number.POSITIVE_INFINITY && num!=Number.MAX_VALUE && num!=Number.MIN_VALUE) {					
				res.push(num);
				num = i<2 ? num/3.0 : num*3.0;
			}
		}
		return res; 
	}
	
	private function storeTrace(func:String, args:String):void {
		trace("storeTrace: func="+func+" args="+args);
		my_graphics.out_traces.text +=
			AS3_vs_AS2.getTimeString() + "\t" + func + "\t" + args + "\n";
		//dp.addItem({Time:(new Date().toLocaleTimeString()), Dir: is_to_container ? "->" : "<-", Function:func, Arguments:args});
	}
	private function handleError(err:Error):void { 
		storeTrace("ERROR", AS3_vs_AS2.error2String(err));
	}
	private function addBtnHandler(name:String):void {
		AS3_vs_AS2.addOnPress(my_graphics[name], AS3_vs_AS2.delegate(this, this.dispatchOperation, name) );   
	}
	private function dispatchOperation(name:String):void {
		trace("Pressed on "+name);
		try {
			switch (name) {
			case "do_store_trace":
				do_store_trace(getInputText("function"), getObject("arguments"));
				break;
			case "do_agree_on_match_over":
				var finished_players:Array/*PlayerMatchOver*/ = [];
				var finished_player_ids:Array/*int*/ = getIntArr("user_ids");
				var scores:Array/*int*/ = getIntArr("scores");
				var pot_percentages:Array/*int*/ = getIntArr("pot_percentages");
				for (var i:int = 0; i<finished_player_ids.length; i++) {
					finished_players[i] = new PlayerMatchOver(finished_player_ids[i], scores[i], pot_percentages[i]);
				}
				do_agree_on_match_over(finished_players);
				break;
			case "do_start_my_turn":
				do_start_my_turn();
				break;
			case "do_end_my_turn":
				do_end_my_turn(getIntArr("next_turn_of_player_ids"));
				break;
			case "do_client_protocol_error_with_description":
				do_client_protocol_error_with_description(getInputText("error_description"));
				break;
			case "do_store_match_state":
				do_store_match_state( new Entry(getInputText("state_key"), getObject("state_value")) );
				break;
			case "do_send_message":
				do_send_message(getIntArr("to_user_ids"), getObject("message_value"));
				break;
			case "do_set_timer":
				do_set_timer(getInt("in_seconds"), new Entry(getInputText("timer_key"), getObject("pass_back")) );
				break;
			}
		} catch (err:Error) { 
			handleError(err);			
		}
	}
	private function getInputText(name_id:String):String {
		return my_graphics["in_" + name_id].text; // can't use getChild, because it is not a movie clip
	}
	private function getObject(name_id:String):Object {
		return JSON.parse(getInputText(name_id));
	}
	private function getInt(name_id:String):int {
		return int(getInputText(name_id));
	}
	private function getIntArr(name_id:String):Array {
		var txt:String = getInputText(name_id);
		if (txt=="") return null;
		var txt_arr:Array = txt.split(",");
		var res:Array = [];
		for each (var t:String in txt_arr) {
			res.push(int(t));
		}
		return res;
	}
	override public function got_error(in_function_name:String, err:Error):void {
		storeTrace("got_error", "In function "+in_function_name+" error="+err);
	}	
    override protected function sendDoOperation(methodName:String, parameters:Array/*Object*/):void {
		storeTrace(methodName, parameters.join(" , "));
		super.sendDoOperation(methodName, parameters);
	}
    override public function localconnection_callback(methodName:String, parameters:Array/*Object*/):void {
		storeTrace(methodName, parameters.join(" , "));
		super.localconnection_callback(methodName, parameters); // to call do_finished_callback
	}
	override protected function sendOperation(connectionName:String, methodName:String, parameters:Array/*Object*/):void {
		if (show_localconnection_messages) storeTrace("LOCALCONNECTION", "connectionName="+connectionName+" methodName="+methodName+" parameters="+parameters);
		super.sendOperation(connectionName, methodName, parameters);
	}
}

}