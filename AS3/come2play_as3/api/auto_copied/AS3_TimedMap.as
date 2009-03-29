package come2play_as3.api.auto_copied
{
import flash.utils.Dictionary;
import flash.utils.getTimer;
	
public final class AS3_TimedMap 
	extends SerializableClass { // just for toString()
	
	public var maxMillisStayInMap:int;
	public var dic:Dictionary = new Dictionary(); // mapping key -> DebugInfo
	
	public function AS3_TimedMap(maxSecondsStayInMap:int=0) {
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
		return AS3_vs_AS2.dictionarySize(dic);
	}
}
}

import come2play_as3.api.auto_copied.SerializableClass;	
class DebugInfo extends SerializableClass {
	public var time:int;
	public var val:Object;
}