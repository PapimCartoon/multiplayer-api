// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/StaticFunctions.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

	import flash.display.MovieClip;
	import flash.system.System;
	
// Only StaticFunctions and JSON are copied to flex_utils 
public final class StaticFunctions
{			
	public static var SHOULD_SHOW_ERRORS:Boolean = true;
	public static var someMovieClip:MovieClip; // so we can display error messages on the stage
	public static function showError(msg:String):void {
		var msg:String = "An ERRRRRRRRRRROR occurred:\n"+msg;

// This is a AUTOMATICALLY GENERATED! Do not change!

		System.setClipboard(msg);
		if (SHOULD_SHOW_ERRORS) AS3_vs_AS2.showError(someMovieClip, msg);
		trace("\n\n\n"+msg+"\n\n\n");
	}
	public static function throwError(msg:String):void {
		var err:Error = new Error(msg);
		showError("Throwing the following error="+AS3_vs_AS2.error2String(err));
		throw err;
	}		
	public static function assert(val:Boolean, args:Array):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		if (!val) throwError("An assertion failed with the following arguments="+JSON.stringify(args));
	}
	
	public static function isEmptyChar(str:String):Boolean {
		return str==" " || str=="\n" || str=="\t" || str=="\r"; //String.fromCharCode(10)
	}
	public static function trim(str:String):String {
	   var j:int, strlen:int, k:int;
	   strlen = str.length
	   j = 0;

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

	   }
	   return str.substring(0,k+1);
	}
	
	// e.g., random(0,2) returns either 0 or 1
	public static function random(fromInclusive:int, toExclusive:int):int {
		var delta:int = toExclusive - fromInclusive;
		return Math.floor( delta * Math.random() ) + fromInclusive;
	}
	public static function startsWith(str:String, start:String):Boolean {

// This is a AUTOMATICALLY GENERATED! Do not change!

		return str.substr(0, start.length)==start;
	}
	public static function endsWith(str:String, suffix:String):Boolean {
		return str.substr(str.length-suffix.length, suffix.length)==suffix;
	}
	
	private static const REFLECTION_PREFIX:String = "REFLECTION_";
	public static function performReflectionFromFlashVars(_someMovieClip:MovieClip):void {		
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(_someMovieClip);
		trace("performReflectionFromFlashVars="+JSON.stringify(parameters));

// This is a AUTOMATICALLY GENERATED! Do not change!

		for (var key:String in parameters) {
			if (startsWith(key,REFLECTION_PREFIX)) {
				var before:String = key.substr(REFLECTION_PREFIX.length);
				var after:String = parameters[key];
				trace("Perform reflection for: "+before+"="+after);
				performReflection2(before, after);	
			}			
		}
	}
	public static function performReflection(reflStr:String):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		var eqIndex:int = AS3_vs_AS2.stringIndexOf(reflStr,"=");
		assert(eqIndex>0, ["Missing '=' in the reflection string=",reflStr]);
		var before:String = reflStr.substr(0, eqIndex);
		var after:String = reflStr.substr(eqIndex+1);
		performReflection2(before, after);
	}
	public static function performReflection2(before:String, after:String):void {
		var val_obj:Object = JSON.parse(after);
		var dotIndex:int = AS3_vs_AS2.stringLastIndexOf(before,".");
		var clzName:String = trim(before.substr(0, dotIndex));

// This is a AUTOMATICALLY GENERATED! Do not change!

		var fieldName:String = trim(before.substr(dotIndex+1));
		var ClassReference:Object = AS3_vs_AS2.getClassByName(clzName);
		//trace("Setting field "+fieldName+" in class "+clzName+" to val="+val_obj); 
		ClassReference[fieldName] = val_obj;		
	}
}
}
