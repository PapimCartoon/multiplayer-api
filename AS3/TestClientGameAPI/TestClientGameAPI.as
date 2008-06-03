package {
	import flash.display.*;
	import flash.text.*;
	import fl.data.DataProvider;
	import fl.controls.*;
	
	public class TestClientGameAPI extends MovieClip {
		private var api:MyAPI;
		
		public function TestClientGameAPI() {
			//trace("TestClientGameAPI");
			api = new MyAPI(loaderInfo.parameters, this);
			/*myDataGrid.columns = ["Time", "Dir", "Function", "Arguments"];
			myDataGrid.horizontalScrollPolicy = ScrollPolicy.ON;
			myDataGrid.dataProvider = api.dp;*/
			this.stop();
		}
	}
}
import flash.display.*;
import flash.text.*;
import flash.events.*;
import fl.data.DataProvider;
import fl.controls.*;

class MyAPI extends ClientGameAPI {
	//public var dp:DataProvider = new DataProvider();
	private var my_graphics:TestClientGameAPI;
	private var show_localconnection_messages:Boolean;
	/*
		do_store_trace(function:String, arguments:Object)
		do_agree_on_match_over(user_ids:int[], scores:int[], pot_percentages:int[])
		do_start_my_turn()
		do_end_my_turn(next_turn_of_player_ids:int[])
		do_client_protocol_error_with_description(error_description:Object)
		do_store_match_state(state_key:String, state_value:Object)
		do_send_message(to_user_ids:int[], message_value:Object)
		do_set_timer(timer_key:String, in_seconds:int, pass_back:Object)
	 */
	private function storeTrace(func:String, args:String):void {
		my_graphics.out_traces.appendText(
			(new Date().toLocaleTimeString()) + "\t" + func + "\t" + args + "\n");
		my_graphics.out_traces.verticalScrollPosition = int.MAX_VALUE;
		//dp.addItem({Time:(new Date().toLocaleTimeString()), Dir: is_to_container ? "->" : "<-", Function:func, Arguments:args});
	}
	public function MyAPI(parameters:Object, my_graphics:TestClientGameAPI) {
		this.my_graphics = my_graphics;
		show_localconnection_messages = parameters["show_localconnection_messages"]=="true";
		var txtArea:TextArea = my_graphics.out_traces;
		txtArea.wordWrap = false;
		txtArea.horizontalScrollPolicy = ScrollPolicy.ON;
		try {
			addBtnHandler("do_store_trace");
			addBtnHandler("do_agree_on_match_over");
			addBtnHandler("do_start_my_turn");
			addBtnHandler("do_end_my_turn");
			addBtnHandler("do_client_protocol_error_with_description");
			addBtnHandler("do_store_match_state");
			addBtnHandler("do_send_message");
			addBtnHandler("do_set_timer");
			super(parameters);
			do_register_on_server();
			storeTrace("do_register_on_server", ""); // because  do_register_on_server is special and it is send using another connection name
		} catch (err:Error) { 
			storeTrace("ERROR", err.toString());
		}
	}
	private function addBtnHandler(name:String):void {
		my_graphics[name].addEventListener(MouseEvent.CLICK , function () { dispatchOperation(name); });
	}
	private function dispatchOperation(name:String):void {
		switch (name) {
		case "do_store_trace":
			do_store_trace(getInputText("function"), getObject("arguments"));
			break;
		case "do_agree_on_match_over":
			do_agree_on_match_over(getIntArr("user_ids"), getIntArr("scores"), getIntArr("pot_percentages"));
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
			do_store_match_state(getInputText("state_key"), getObject("state_value"));
			break;
		case "do_send_message":
			do_send_message(getIntArr("to_user_ids"), getObject("message_value"));
			break;
		case "do_set_timer":
			do_set_timer(getInputText("timer_key"), getInt("in_seconds"), getObject("pass_back"));
			break;
		}
	}
	private function getInputText(name_id:String):String {
		return my_graphics["in_" + name_id].text;
	}
	private function getObject(name_id:String):Object {
		return getInputText(name_id);
	}
	private function getInt(name_id:String):int {
		return int(getInputText(name_id));
	}
	private function getIntArr(name_id:String):Array {
		var txt:String = getInputText(name_id);
		if (txt=="") return null;
		var txt_arr:Array = txt.split(",");
		var res:Array = [];
		for each (var t:String in txt_arr)
			res.push(int(t));
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
	}
	override protected function sendOperation(connectionName:String, methodName:String, parameters:Array/*Object*/):void {
		if (show_localconnection_messages) storeTrace("LOCALCONNECTION", "connectionName="+connectionName+" methodName="+methodName+" parameters="+parameters);
		super.sendOperation(connectionName, methodName, parameters);
	}
}