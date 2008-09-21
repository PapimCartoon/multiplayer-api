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
	
	private var myUserId:int;
	private var allPlayerIds:Array/*int*/;
	public static var shouldTest:Boolean = true;
	
	public function TestClientGameAPI(rootGraphics:MovieClip) {
		super(rootGraphics);
		trace("Constructor of TestClientGameAPI version 2");
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
		AS3_vs_AS2.addOnPress(my_graphics.sendOperation, AS3_vs_AS2.delegate(this, this.dispatchOperation) );
		doRegisterOnServer();			
	}
	
	override public function gotMyUserId(userId:int):void {	
		myUserId = userId;	
	}
	private function generateKey():Object {
		var obj:Object = {};
		var order:Boolean = Math.random()>0.5;
		obj[order ? "a" : "b"] = order ? 't' : 42;
		obj[!order ? "a" : "b"] = !order ? 't' : 42;
		// obj is the same, regardless of the order
		return [42,true,obj];
	}
	
	private var testDoubleNumbers:Boolean = false;
	override public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object, matchStartedTime:int, serverEntries:Array/*ServerEntry*/):void {
		this.allPlayerIds = allPlayerIds;
		if (!shouldTest) return;
		var test_Arr:Array = null;
		if (myUserId==allPlayerIds[0]) {
			test_Arr = testDoubleNumbers ? getNumberArr() : [Math.sqrt(2)]; 		
		}		
		expect(
		function ():void {
			if (myUserId==allPlayerIds[0]) {
				doStoreState([ UserEntry.create("testNumbers"+myUserId, test_Arr, false)]);			
			}				
		},
		function (entries:Array):void {
			var entry:ServerEntry = entries[0];	
			require(entry.key=="testNumbers"+allPlayerIds[0]);
			require(entry.visibleToUserIds==null);
			require(entry.storedByUserId==allPlayerIds[0]);
			if (myUserId==allPlayerIds[0]) require(ObjectDictionary.areEqual(entry.value, test_Arr));	
		});
		/*myCodeStart*/
		expect(
		function ():void {
			if (myUserId==allPlayerIds[0]) {
				doStoreState([ UserEntry.create("a","b", true),UserEntry.create("b","c", true),UserEntry.create("c","d", true),UserEntry.create("d","e", true),UserEntry.create("e","f", true),UserEntry.create("f","g", true),UserEntry.create("g","h", true),UserEntry.create("h","i", true),UserEntry.create("i","j", true),UserEntry.create("j","k", true),UserEntry.create("k","x", true)]);							
			}
		},
		function (entries:Array):void {
			var entry:ServerEntry = entries[0];	
			require(entries.length == 11);
			require(entry.visibleToUserIds != null);
		});
		expect(
		function ():void {
			doAllRevealState([RevealEntry.create("a",null,3),RevealEntry.create("e",[2],0)]);
		},
		function (entries:Array):void {
			var entry0:ServerEntry = entries[0];
			var entry1:ServerEntry = entries[1];
			var entry2:ServerEntry = entries[2];
			var entry3:ServerEntry = entries[3];
			var entry4:ServerEntry = entries[4];
			require(entry0.visibleToUserIds == null)
			require(entry1.visibleToUserIds == null)
			require(entry2.visibleToUserIds == null)
			require(entry3.visibleToUserIds == null)
			require(entry4.visibleToUserIds != null)
		});
		/*myCodeEnd*/
		expect(
		function ():void {
			// testing doAllStoreState with public and secret entries.
			doAllStoreState( 
				[ 
				UserEntry.create("doAllStoreState-public","val-doAllStoreState-public",false), 
				UserEntry.create("doAllStoreState-secret","val-doAllStoreState-secret",true) 
				]);		
			
		},
		function (entries:Array):void {		
			require(entries.length==2);
			var entry1:ServerEntry = entries[0];
			var entry2:ServerEntry = entries[1];
			require(entry1.storedByUserId==-1);
			require(entry2.storedByUserId==-1);
			require(entry1.key=="doAllStoreState-public");
			require(entry1.visibleToUserIds==null);		
			require(entry1.value=="val-doAllStoreState-public");
			require(entry2.key=="doAllStoreState-secret");
			require(entry2.visibleToUserIds.length==0);
			require(entry2.value==null);			
		});
		
				
		var key:Object = generateKey();
		var sameKey:Object = generateKey();
		expect(
		function ():void {
			// We test reveal	
			doAllStoreState([UserEntry.create(key, "val-doStoreState1",false) ]);
			
		},
		function (entries:Array):void {	
			var entry:ServerEntry = entries[0];		
			require(ObjectDictionary.areEqual(entry.key, sameKey));
			require(entry.visibleToUserIds==null);
			require(entry.storedByUserId==-1);		
			require(entry.value=="val-doStoreState1");		
		});
					
		expect(
		function ():void {
			// we test storing the same key with different values&secret
			doAllStoreState([UserEntry.create(sameKey, "val-doStoreState2",true) ]);
			
		},
		function (entries:Array):void {
			var entry:ServerEntry = entries[0];	
			require(ObjectDictionary.areEqual(entry.key, sameKey));
			require(entry.visibleToUserIds.length==0);
			require(entry.storedByUserId==-1);		
			require(entry.value==null);				
		});
				
		expect(
		function ():void {
			// reveal all secret values
			doAllRevealState([RevealEntry.create(key)]);			
		},
		function (entries:Array):void {	
			var entry:ServerEntry = entries[0];	
			require(ObjectDictionary.areEqual(entry.key, sameKey));
			require(entry.visibleToUserIds==null);
			require(entry.storedByUserId==-1);		
			require(entry.value=="val-doStoreState2");				
		});
		
		
			
		expect(
		function ():void {
			// test reveal with depth>0
			var userEntries:Array = [];
			var i:int;
			for (i=1; i<12; i++)
				userEntries.push( UserEntry.create(i, i+1,true) );
			doAllStoreState(userEntries);
			
		},
		function (entries:Array):void {	
			for (var j:int=1; j<12; j++) {
				var entry:ServerEntry = entries[j-1];
				require(entry.key==j);
				require(entry.visibleToUserIds.length==0);
				require(entry.storedByUserId==-1);
				require(entry.value==null);
			}								
		});
		
				
		expect(
		function ():void {
			doAllRevealState(
			[ 
				// this will reveal 6 entries to all players
				RevealEntry.create(1,null,5), //keys 1..6
				RevealEntry.create(3,null,1), // will not reveal anything new
				RevealEntry.create(4,null,3), // key 7
				// this will reveal entries 9 till 11 to the first player
				RevealEntry.create(9,[allPlayerIds[0]],100) 
			]);					
		},
		function (entries:Array):void {		
			require(entries.length==7+3);
			var entry:ServerEntry;
			var j:int;
			for (j=1; j<=7; j++) {
				entry = entries[j-1];
				require(entry.key==j);
				require(entry.visibleToUserIds==null);
				require(entry.storedByUserId==-1);
				require(entry.value==j+1);
			}			
			for (j=9; j<12; j++) {		
				entry = entries[7+j-9];
				require(entry.key==j);
				require(entry.visibleToUserIds.length==1 && entry.visibleToUserIds[0]==allPlayerIds[0]);
				require(entry.storedByUserId==-1);
				require(entry.value== (allPlayerIds[0]==myUserId ? j+1 : null) );
			}							
		});	
		
		if (allPlayerIds.length>=2) {
			expect(
			function ():void {
				doAllRevealState(
				[ 
					RevealEntry.create(1,null,5), // will not reveal anything new
					RevealEntry.create(9,[allPlayerIds[0]]), // will not reveal anything new
					// this will reveal entries 10 till 11 to the second player as well
					RevealEntry.create(10,[allPlayerIds[0], allPlayerIds[1]],100) // note that I entered the id of player 0 again! to make sure it is filtered.
				]);					
			},
			function (entries:Array):void {			
				require(entries.length==2);
				var entry:ServerEntry;
				var j:int;
				for (j=10; j<12; j++) {		
					entry = entries[j-10];
					require(entry.key==j);
					require(entry.visibleToUserIds.length==2 && entry.visibleToUserIds[1]==allPlayerIds[1]);
					require(entry.storedByUserId==-1);
					require(entry.value== (allPlayerIds[0]==myUserId || allPlayerIds[1]==myUserId ? j+1 : null) );
				}
			});
		}
		
			
		expect(
		function ():void {
			// test shuffle - shuffle will cause these entries to be invisible
			doAllShuffleState([5,6,7,8,9]);			
		},
		function (entries:Array):void {		
			require(entries.length==5);
			var entry:ServerEntry;
			var j:int;
			for (j=5; j<=9; j++) {
				entry = entries[j-5];	
				require(entry.key==j);
				require(entry.visibleToUserIds.length==0);
				require(entry.storedByUserId==-1);
				require(entry.value==null);
			}		
		});
		
			
			
		expect(
		function ():void {
			var revealEntries:Array = [];
			for (var i:int=5; i<=9; i++)
				revealEntries.push(RevealEntry.create(i,null,0));		
			doAllRevealState(revealEntries);			
		},
		function (entries:Array):void {		
			require(entries.length==5);		
			var entry:ServerEntry;
			var j:int;
			var sum:int = 0;
			for (j=5; j<=9; j++) {
				entry = entries[j-5];	
				require(entry.key==j);
				require(entry.visibleToUserIds==null);
				require(entry.storedByUserId==-1);			
				// the values were shuffled, so I just check the sum of all values did not change.	
				sum += j+1;
				sum -= entry.value;
			}		
			require(sum==0);
		});
		
		
		// to end the game I simulate a real-time game:
		// the first one to store a certain value will win!
		var didSendEndMatch:Boolean = false;
		for (var i:int=0; i<allPlayerIds.length; i++)
			expect(
			function ():void {
				if (!didSendEndMatch)
					doStoreState([UserEntry.create("winner","I won!",true)]);
			},
			function (entries:Array):void {		
				require(entries.length==1);
				var entry:ServerEntry = entries[0];
				var winnerId:int = entry.storedByUserId;	
				require(entry.key=="winner");
				require(entry.visibleToUserIds.length==1 && entry.visibleToUserIds[0]==winnerId);
				require(winnerId!=-1);
				require(entry.value== (myUserId==winnerId ? "I won!" : null) );		
				
				if (!didSendEndMatch) {
					didSendEndMatch = true;
					var finishedPlayers:Array = [];
					for each (var id:int in allPlayerIds) {
						finishedPlayers.push( PlayerMatchOver.create(id, id==winnerId ? 1000 : -1000, id==winnerId ? 100 : 0) );		
					}
					doAllEndMatch(finishedPlayers);
				}			
			});
			
		// start the first transaction
		doTransaction();
	}
	override public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void {
		require(funcResArr.length==0);
		require(funcDoArr.length==0);
		lastTime = 0;
	}
	private function doTransaction():void {
		var funcDo:Function = funcDoArr.shift();
		trace("doTransaction");
		funcDo();		
	}
		
	private var funcResArr:Array/*Function*/ = [];
	private var funcDoArr:Array/*Function*/ = [];
	private var lastTime:int = 0;
	private function require(bool:Boolean):void {
		if (!bool) StaticFunctions.throwError("require failed!")
	}
	private function expect(funcDo:Function, funcRes:Function):void {
		funcDoArr.push(funcDo);
		funcResArr.push(funcRes);	
	}
	override public function gotStateChanged(serverEntries:Array/*ServerEntry*/):void {
		var entry:ServerEntry = serverEntries[0];	
		require(lastTime<=entry.changedTimeInMilliSeconds);
		lastTime = entry.changedTimeInMilliSeconds;
		
		require(funcResArr.length>0);  
		var funcRes:Function = funcResArr.shift();
		funcRes(serverEntries);
		if (funcResArr.length>0) doTransaction();
	}		
	public static function getNumberArr():Array {
		var res:Array = [];
		for (var i:int=0; i<2; i++) {
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