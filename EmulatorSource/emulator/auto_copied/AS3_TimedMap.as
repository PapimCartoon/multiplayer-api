// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_TimedMap.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

import flash.utils.Dictionary;
import flash.utils.getTimer;
	
public final class AS3_TimedMap 
	extends SerializableClass { // just for toString()
	
	public var maxMillisStayInMap:int;
	public var dic:Dictionary = new Dictionary(); // mapping key -> DebugInfo
	
	public function AS3_TimedMap(maxSecondsStayInMap:int=0) {

// This is a AUTOMATICALLY GENERATED! Do not change!

		this.maxMillisStayInMap = 1000*maxSecondsStayInMap;
		ErrorHandler.myInterval("AS3_TimedMap with maxMillisStayInMap="+maxMillisStayInMap, ticked, maxMillisStayInMap);			
	}
	private function ticked():void {		
		var now:int = getTimer();
		for each (var debug:DebugInfo in dic) {			
			StaticFunctions.assert( (now-debug.time) < maxMillisStayInMap, ["AS3_TimedMap: an entry stayed more than ",maxMillisStayInMap, " entry=",debug, " now=",now, this]);
		}
	}
	public function add(key:Object, val:Object):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		StaticFunctions.assert( dic[key]==null, ["AS3_TimedMap: key already exists! key=",key,this]);
		var debug:DebugInfo = new DebugInfo();		
		debug.time = getTimer();
		debug.val = val;
		dic[key] = debug;
	}
	// returns the val
	public function remove(key:Object):Object {
		var debug:DebugInfo = dic[key];
		StaticFunctions.assert(debug!=null, ["AS3_TimedMap: missing key=",key, this]);		

// This is a AUTOMATICALLY GENERATED! Do not change!

		delete dic[key];
		return debug.val;
	}
	public function contains(key:Object):Boolean {
		return dic[key]!=null;
	}
	public function clear():void {
		dic = new Dictionary();
	}
	public function size():int {

// This is a AUTOMATICALLY GENERATED! Do not change!

		return AS3_vs_AS2.dictionarySize(dic);
	}
}
}

import emulator.auto_copied.SerializableClass;	
class DebugInfo extends SerializableClass {
	public var time:int;
	public var val:Object;
}
