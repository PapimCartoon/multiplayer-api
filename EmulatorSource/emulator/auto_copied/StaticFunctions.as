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
	import flash.utils.*;
	
// Only StaticFunctions and JSON are copied to flex_utils 
public final class StaticFunctions
{			
	public static var SHOULD_SHOW_ERRORS:Boolean = true;
	public static var someMovieClip:MovieClip; // so we can display error messages on the stage
	public static var allTraces:Array = [];

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static var MAX_TRACES_NUM:int = 50;
	public static function storeTrace(obj:Object):void {
		if (allTraces.length>=MAX_TRACES_NUM) allTraces.shift();
		allTraces.push(["Time: ", getTimer(), " Trace: ", obj]);
	}
	private static var DID_SHOW_ERROR:Boolean = false;
	public static function showError(msg:String):void {
		if (DID_SHOW_ERROR) return;
		DID_SHOW_ERROR = true;
		var msg:String = "An ERRRRRRRRRRROR occurred:\n"+msg+"\n"+

// This is a AUTOMATICALLY GENERATED! Do not change!

			(allTraces.length==0 ? '' : 
				(allTraces.length<MAX_TRACES_NUM ? "All":"The last "+MAX_TRACES_NUM)+" stored traces are:\n"+
				allTraces.join("\n"));
		System.setClipboard(msg);
		if (SHOULD_SHOW_ERRORS) AS3_vs_AS2.showError(someMovieClip, msg);
		trace("\n\n\n"+msg+"\n\n\n");
	}
	public static function throwError(msg:String):void {
		var err:Error = new Error(msg);
		showError("Throwing the following error="+AS3_vs_AS2.error2String(err));

// This is a AUTOMATICALLY GENERATED! Do not change!

		throw err;
	}		
	public static function assert(val:Boolean, args:Array):void {
		if (!val) throwError("An assertion failed with the following arguments="+JSON.stringify(args));
	}
	
	public static function isEmptyChar(str:String):Boolean {
		return str==" " || str=="\n" || str=="\t" || str=="\r"; //String.fromCharCode(10)
	}
	public static function trim(str:String):String {

// This is a AUTOMATICALLY GENERATED! Do not change!

	   var j:int, strlen:int, k:int;
	   strlen = str.length
	   j = 0;
	   while (isEmptyChar(str.charAt(j))) {
		  j++
	   } 
	   if(j>0) {
		  str = str.substring(j)
		  if(j == strlen) return str;
	   }

// This is a AUTOMATICALLY GENERATED! Do not change!

	   k = str.length - 1;
	   while(isEmptyChar(str.charAt(k))) {
		  k--;
	   }
	   return str.substring(0,k+1);
	}
	
	// e.g., random(0,2) returns either 0 or 1
	public static function random(fromInclusive:int, toExclusive:int):int {
		var delta:int = toExclusive - fromInclusive;

// This is a AUTOMATICALLY GENERATED! Do not change!

		return Math.floor( delta * Math.random() ) + fromInclusive;
	}
	public static function startsWith(str:String, start:String):Boolean {
		return str.substr(0, start.length)==start;
	}
	public static function endsWith(str:String, suffix:String):Boolean {
		return str.substr(str.length-suffix.length, suffix.length)==suffix;
	}
	
	private static const REFLECTION_PREFIX:String = "REFLECTION_";

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function performReflectionFromFlashVars(_someMovieClip:MovieClip):void {		
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(_someMovieClip);
		trace("performReflectionFromFlashVars="+JSON.stringify(parameters));
		for (var key:String in parameters) {
			if (startsWith(key,REFLECTION_PREFIX)) {
				var before:String = key.substr(REFLECTION_PREFIX.length);
				var after:String = parameters[key];
				trace("Perform reflection for: "+before+"="+after);
				performReflection2(before, after);	
			}			

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
	}
	public static function performReflection(reflStr:String):void {
		var eqIndex:int = AS3_vs_AS2.stringIndexOf(reflStr,"=");
		assert(eqIndex>0, ["Missing '=' in the reflection string=",reflStr]);
		var before:String = reflStr.substr(0, eqIndex);
		var after:String = reflStr.substr(eqIndex+1);
		performReflection2(before, after);
	}
	public static function performReflection2(before:String, after:String):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		var val_obj:Object = JSON.parse(after);
		var dotIndex:int = AS3_vs_AS2.stringLastIndexOf(before,".");
		var clzName:String = trim(before.substr(0, dotIndex));
		var fieldName:String = trim(before.substr(dotIndex+1));
		var ClassReference:Object = AS3_vs_AS2.getClassByName(clzName);
		//trace("Setting field "+fieldName+" in class "+clzName+" to val="+val_obj); 
		ClassReference[fieldName] = val_obj;		
	}

	public static function replaceLastOccurance(str:String, searchFor:String, replaceWith:String):String {

// This is a AUTOMATICALLY GENERATED! Do not change!

		var lastIndex:int = AS3_vs_AS2.stringLastIndexOf(str, searchFor);
		if (lastIndex==-1) showError("Did not find searchFor="+searchFor+" in string="+str);
		return str.substring(0,lastIndex) + replaceWith + str.substring(lastIndex+searchFor.length);
	}
}
}
