import come2play_as2.api.*;
import come2play_as2.api.auto_generated.*;
import come2play_as2.api.auto_copied.*;	


import flash.text.*;

import come2play_as2.tests.*;
class come2play_as2.tests.TestClientGameAPI extends ClientGameAPI {
	//public var dp:DataProvider = new DataProvider();
	private var my_graphics:MovieClip;	
	private var outTracesText:Object;
	private var exampleOperationsText:Object;
	private var operationInput:Object;
	
	private var test_Arr:Array;
	private static var shouldTestPassNumbers:Boolean = false;
	
	public function TestClientGameAPI(my_graphics:MovieClip) {
		try {		
			trace("Constructor of TestClientGameAPI");
			var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(my_graphics);
			this.my_graphics = my_graphics;	
			outTracesText = my_graphics.outTracesText;
			exampleOperationsText = my_graphics.exampleOperationsText;
			operationInput = my_graphics.operationInput;	
			
			var allOperationsWithParameters:Array = [];
			for (var i30:Number=0; i30<API_MethodsSummary.SUMMARY_API.length; i30++) { var methodSummary:API_MethodsSummary = API_MethodsSummary.SUMMARY_API[i30]; 
				if (methodSummary.methodName.substring(0,2)!="do") continue;
				var args:Array = [];
				for (var i:Number=0; i<methodSummary.parameterNames.length; i++) {
					args.push(methodSummary.parameterNames[i]+":"+methodSummary.parameterTypes[i]);
				}
				allOperationsWithParameters.push(methodSummary.methodName+"("+args.join(", ")+")");
			}
			exampleOperationsText.text = allOperationsWithParameters.join("\n");
			
			if (shouldTestPassNumbers) {	
				test_Arr = getNumberArr();
				trace("test_Arr="+test_Arr);
			}
			AS3_vs_AS2.addOnPress(my_graphics.sendOperation, AS3_vs_AS2.delegate(this, this.dispatchOperation) );
			super(my_graphics);
		} catch (err:Error) { 
			handleError(err);
		}
	}
	
	/*override*/ public function gotMyUserId(userId:Number):Void {		
		if (shouldTestPassNumbers) doStoreState([ UserEntry.create("test", test_Arr, false)]);
	}
	/*override*/ public function gotStateChanged(serverEntries:Array/*ServerEntry*/):Void { 
		if (shouldTestPassNumbers) {
			var state:ServerEntry = serverEntries[0];
			var value:Array = AS3_vs_AS2.asArray(state.value);  
			for (var i:Number=0; i<test_Arr.length; i++) {
				var val:Number = test_Arr[i];
				var val2:Number = value[i];
				if (val!=val2) {
					LocalConnectionUser.throwError("Found different values, val="+val+" val2="+val2);
				}
			}			
		}
	}		
	public static function getNumberArr():Array {
		var res:Array = [];
		for (var i:Number=0; i<4; i++) {
			var num:Number = Math.random()-0.5;
			while (num!=0 && num!=Number.NEGATIVE_INFINITY && num!=Number.POSITIVE_INFINITY && num!=Number.MAX_VALUE && num!=Number.MIN_VALUE) {					
				res.push(num);
				num = i<2 ? num/3.0 : num*3.0;
			}
		}
		return res; 
	}
	
	private function storeTrace(func:String, args:String):Void {
		trace("storeTrace: func="+func+" args="+args);
		outTracesText.text +=
			AS3_vs_AS2.getTimeString() + "\t" + func + "\t" + args + "\n";
		//dp.addItem({Time:(new Date().toLocaleTimeString()), Dir: is_to_container ? "->" : "<-", Function:func, Arguments:args});
	}
	private function handleError(err:Error):Void { 
		storeTrace("ERROR", AS3_vs_AS2.error2String(err));
	}
	private function dispatchOperation():Void {
		try {
			var inputStr:String = operationInput.text;
			if (inputStr=='') return;
			var firstParen:Number = inputStr./*String*/indexOf("(");
			if (firstParen==-1) return;
			var lastParen:Number = inputStr./*String*/lastIndexOf(")");
			if (lastParen==-1) return;			
			var methodName:String = inputStr.substr(0,firstParen);
			var params:String = inputStr.substring(firstParen+1, lastParen);
			// I must call the constructor directly
			var className:String =
				"come2play_as3.api.auto_generated::API_"+ 
				methodName.substr(0,1).toUpperCase()+methodName.substr(1);
			var instanceObj:Object = AS3_vs_AS2.createInstanceOf(className);
			var instance:API_Message = API_Message(instanceObj);
			instance.setMethodParameters(AS3_vs_AS2.asArray(JSON.parse("["+params+"]")));
			sendMessage(instance);
		} catch (err:Error) { 
			handleError(err);			
		}
	}
    /*override*/ public function sendMessage(msg:API_Message):Void {
		storeTrace(msg.getMethodName(), msg.getParametersAsString());
		super.sendMessage(msg);
	}
	/*override*/ public function gotMessage(msg:API_Message):Void {
		storeTrace(msg.getMethodName(), msg.getParametersAsString());
		super.gotMessage(msg);		
	}
}

