	
// Only StaticFunctions and JSON are copied to flex_utils 
import come2play_as2.api.auto_copied.*;
class come2play_as2.api.auto_copied.StaticFunctions
{			
	public static var SHOULD_SHOW_ERRORS:Boolean = true;
	public static var someMovieClip:MovieClip; // so we can display error messages on the stage
	public static var allTraces:Array = [];
	public static var MAX_TRACES_NUM:Number = 50;
	public static function storeTrace(obj/*:Object*/):Void {
		if (allTraces.length>=MAX_TRACES_NUM) allTraces.shift();
		allTraces.push(["Time: ", getTimer(), " Trace: ", obj]);
	}
	private static var DID_SHOW_ERROR:Boolean = false;
	public static function showError(msg:String):Void {
		if (DID_SHOW_ERROR) return;
		DID_SHOW_ERROR = true;
		var msg:String = "An ERRRRRRRRRRROR occurred:\n"+msg+"\n"+
			(allTraces.length==0 ? '' : 
				(allTraces.length<MAX_TRACES_NUM ? "All":"The last "+MAX_TRACES_NUM)+" stored traces are:\n"+
				allTraces.join("\n"));
		System.setClipboard(msg);
		if (SHOULD_SHOW_ERRORS) AS3_vs_AS2.showError(someMovieClip, msg);
		trace("\n\n\n"+msg+"\n\n\n");
	}
	public static function throwError(msg:String):Void {
		var err:Error = new Error(msg);
		showError("Throwing the following error="+AS3_vs_AS2.error2String(err));
		throw err;
	}		
	public static function assert(val:Boolean, args:Array):Void {
		if (!val) throwError("An assertion failed with the following arguments="+JSON.stringify(args));
	}
	
	public static function isEmptyChar(str:String):Boolean {
		return str==" " || str=="\n" || str=="\t" || str=="\r"; //String.fromCharCode(10)
	}
	public static function trim(str:String):String {
	   var j:Number, strlen:Number, k:Number;
	   strlen = str.length
	   j = 0;
	   while (isEmptyChar(str.charAt(j))) {
		  j++
	   } 
	   if(j>0) {
		  str = str.substring(j)
		  if(j == strlen) return str;
	   }
	   k = str.length - 1;
	   while(isEmptyChar(str.charAt(k))) {
		  k--;
	   }
	   return str.substring(0,k+1);
	}
	
	// e.g., random(0,2) returns either 0 or 1
	public static function random(fromInclusive:Number, toExclusive:Number):Number {
		var delta:Number = toExclusive - fromInclusive;
		return Math.floor( delta * Math.random() ) + fromInclusive;
	}
	public static function startsWith(str:String, start:String):Boolean {
		return str.substr(0, start.length)==start;
	}
	public static function endsWith(str:String, suffix:String):Boolean {
		return str.substr(str.length-suffix.length, suffix.length)==suffix;
	}
	
	private static var REFLECTION_PREFIX:String = "REFLECTION_";
	public static function performReflectionFromFlashVars(_someMovieClip:MovieClip):Void {		
		var parameters/*:Object*/ = AS3_vs_AS2.getLoaderInfoParameters(_someMovieClip);
		trace("performReflectionFromFlashVars="+JSON.stringify(parameters));
		for (var key:String in parameters) {
			if (startsWith(key,REFLECTION_PREFIX)) {
				var before:String = key.substr(REFLECTION_PREFIX.length);
				var after:String = parameters[key];
				trace("Perform reflection for: "+before+"="+after);
				performReflection2(before, after);	
			}			
		}
	}
	public static function performReflection(reflStr:String):Void {
		var eqIndex:Number = AS3_vs_AS2.stringIndexOf(reflStr,"=");
		assert(eqIndex>0, ["Missing '=' in the reflection string=",reflStr]);
		var before:String = reflStr.substr(0, eqIndex);
		var after:String = reflStr.substr(eqIndex+1);
		performReflection2(before, after);
	}
	public static function performReflection2(before:String, after:String):Void {
		var val_obj/*:Object*/ = JSON.parse(after);
		var dotIndex:Number = AS3_vs_AS2.stringLastIndexOf(before,".");
		var clzName:String = trim(before.substr(0, dotIndex));
		var fieldName:String = trim(before.substr(dotIndex+1));
		var ClassReference/*:Object*/ = AS3_vs_AS2.getClassByName(clzName);
		//trace("Setting field "+fieldName+" in class "+clzName+" to val="+val_obj); 
		ClassReference[fieldName] = val_obj;		
	}

	public static function replaceLastOccurance(str:String, searchFor:String, replaceWith:String):String {
		var lastIndex:Number = AS3_vs_AS2.stringLastIndexOf(str, searchFor);
		if (lastIndex==-1) showError("Did not find searchFor="+searchFor+" in string="+str);
		return str.substring(0,lastIndex) + replaceWith + str.substring(lastIndex+searchFor.length);
	}
}
