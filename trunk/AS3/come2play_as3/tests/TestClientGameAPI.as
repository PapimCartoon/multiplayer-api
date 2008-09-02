package come2play_as3.tests {
import come2play_as3.api.*;
import come2play_as3.api.auto_copied.*;
import come2play_as3.api.auto_generated.*;

import flash.display.*;
import flash.events.*;
import flash.text.*;

public class TestClientGameAPI extends ClientGameAPI {
	//public var dp:DataProvider = new DataProvider();
	private var my_graphics:MovieClip;	
	private var outTracesText:Object;
	private var exampleOperationsText:Object;
	private var operationInput:Object;
	
	private var test_Arr:Array;
	private static const shouldTestPassNumbers:Boolean = false;
	
	public function TestClientGameAPI(rootGraphics:MovieClip) {
		super(rootGraphics);
		trace("Constructor of TestClientGameAPI");
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(rootGraphics);		
		my_graphics = AS3_vs_AS2.createMovieInstance(rootGraphics, "TestClientGameGraphics","client");
		outTracesText = my_graphics.outTracesText;
		exampleOperationsText = my_graphics.exampleOperationsText;
		operationInput = my_graphics.operationInput;	
		
		var allOperationsWithParameters:Array = [];
		for each (var methodSummary:API_MethodsSummary in API_MethodsSummary.SUMMARY_API) {
			var methodName:String = methodSummary.methodName; 
			if (methodName.substring(0,2)!="do") continue;
			if (methodName=="doRegisterOnServer") continue;
			var args:Array = [];
			for (var i:int=0; i<methodSummary.parameterNames.length; i++) {
				args.push(methodSummary.parameterNames[i]+":"+methodSummary.parameterTypes[i]);
			}
			allOperationsWithParameters.push(methodName+"("+args.join(", ")+")");
		}
		
		// write about our classes that are used in do* operations: 
		allOperationsWithParameters.push("");
		var classPrefix:String = "{'"+
			SerializableClass.CLASS_NAME_FIELD+"': '"+SerializableClass.REPLACE_TO+
				".auto_generated"+(AS3_vs_AS2.isAS3 ? "::" : ".");
		allOperationsWithParameters.push(
			classPrefix+"PlayerMatchOver', 'playerId': int, 'score': int, 'potPercentage': int}");
		allOperationsWithParameters.push(
			classPrefix+"RevealEntry', 'key': String, 'userIds': int[], 'depth': int}");
		allOperationsWithParameters.push(
			classPrefix+"UserEntry', 'key': String, 'value': *, 'isSecret': boolean}");

		allOperationsWithParameters.push("\nExamples:");
		allOperationsWithParameters.push(
			"\ndoStoreState([{'__CLASS_NAME__':'COME2PLAY_PACKAGE.auto_generated::UserEntry', 'key': 'String', 'value': 'value', 'isSecret': false}])"+
			"\ndoAllSetTurn(42,10000)"+
			"\ndoAllEndMatch([{'__CLASS_NAME__': 'COME2PLAY_PACKAGE.auto_generated::PlayerMatchOver', 'playerId': 41, 'score': 1000, 'potPercentage': 20}])"+
			"\n"
			);
		exampleOperationsText.text = allOperationsWithParameters.join("\n");
		
		if (shouldTestPassNumbers) {	
			test_Arr = getNumberArr();
			trace("test_Arr="+test_Arr);
		}
		AS3_vs_AS2.addOnPress(my_graphics.sendOperation, AS3_vs_AS2.delegate(this, this.dispatchOperation) );
		doRegisterOnServer();			
	}
	
	override public function gotMyUserId(userId:int):void {		
		if (shouldTestPassNumbers) doStoreState([ UserEntry.create("test", test_Arr, false)]);
	}
	override public function gotStateChanged(serverEntries:Array/*ServerEntry*/):void { 
		if (shouldTestPassNumbers) {
			var state:ServerEntry = serverEntries[0];
			var value:Array = AS3_vs_AS2.asArray(state.value);  
			for (var i:int=0; i<test_Arr.length; i++) {
				var val:int = test_Arr[i];
				var val2:int = value[i];
				if (val!=val2) {
					LocalConnectionUser.throwError("Found different values, val="+val+" val2="+val2);
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
		outTracesText.text +=
			AS3_vs_AS2.getTimeString() + "\t" + func + "\t" + args + "\n";
		//dp.addItem({Time:(new Date().toLocaleTimeString()), Dir: is_to_container ? "->" : "<-", Function:func, Arguments:args});
	}
	private function handleError(err:Error):void { 
		storeTrace("ERROR", AS3_vs_AS2.error2String(err));
	}
	private function dispatchOperation():void {
		try {
			var inputStr:String = operationInput.text;
			inputStr = StaticFunctions.trim(inputStr);			
			if (inputStr=='') return;
			var firstParen:int = AS3_vs_AS2.stringIndexOf(inputStr,"(");
			if (firstParen==-1) return;
			var lastParen:int = AS3_vs_AS2.stringLastIndexOf(inputStr, ")");
			if (lastParen==-1) return;			
			var methodName:String = inputStr.substr(0,firstParen);
			var params:String = inputStr.substring(firstParen+1, lastParen);
			// I must call the constructor directly
			var className:String =
				"come2play_as3.api.auto_generated::API_"+ 
				methodName.substr(0,1).toUpperCase()+methodName.substr(1);
			var instanceObj:Object = AS3_vs_AS2.createInstanceOf(className);
			var instance:API_Message = instanceObj as API_Message;
			instance.setMethodParameters(AS3_vs_AS2.asArray(JSON.parse("["+params+"]")));
			sendMessage(instance);
		} catch (err:Error) { 
			handleError(err);			
		}
	}
    override public function sendMessage(msg:API_Message):void {
		if (!(msg is API_DoFinishedCallback)) 
			storeTrace(msg.getMethodName(), msg.getParametersAsString());
		super.sendMessage(msg);
	}
	override public function gotMessage(msg:API_Message):void {
		if (!(msg is API_GotKeyboardEvent)) 
			storeTrace(msg.getMethodName(), msg.getParametersAsString());
		super.gotMessage(msg);		
	}
}

}