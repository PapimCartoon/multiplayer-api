	
import come2play_as2.api.auto_copied.*;
class come2play_as2.api.auto_copied.StaticFunctions
{		
	
	public static function trim(str:String):String {
	   var j:Number, strlen:Number, k:Number;
	   strlen = str.length
	   j = 0;
	   while (str.charAt(j) == " ") {
		  j++
	   } 
	   if(j>0) {
		  str = str.substring(j)
		  if(j == strlen) return str;
	   }
	   k = str.length - 1;
	   while(str.charAt(k) == " ") {
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
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(_someMovieClip);
		for (var key:String in parameters) {
			if (startsWith(key,REFLECTION_PREFIX))
				performReflection(parameters[key]);				
		}
	}
	public static function performReflection(reflStr:String):Void {
		var eqIndex:Number = AS3_vs_AS2.stringIndexOf(reflStr,"=");
		LocalConnectionUser.assert(eqIndex>0, ["Missing '=' in the reflection string=",reflStr]);
		var before:String = reflStr.substr(0, eqIndex);
		var after:String = reflStr.substr(eqIndex+1);
		var val_obj:Object = JSON.parse(after);
		var dotIndex:Number = AS3_vs_AS2.stringLastIndexOf(before,".");
		var clzName:String = trim(before.substr(0, dotIndex));
		var fieldName:String = trim(before.substr(dotIndex+1));
		var ClassReference:Object = AS3_vs_AS2.getClassByName(clzName);
		//trace("Setting field "+fieldName+" in class "+clzName+" to val="+val_obj); 
		ClassReference[fieldName] = val_obj;		
	}
}
