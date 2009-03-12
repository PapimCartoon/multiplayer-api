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

	import flash.display.*;
	import flash.system.*;
	import flash.utils.*;
	
// Only StaticFunctions and JSON are copied to flex_utils 
public final class StaticFunctions
{			
	public static var GOOGLE_REVISION_NUMBER:int = 811;
	public static var COME2PLAY_REVISION_NUMBER:int = 1863;
	public static function getRevision():String {

// This is a AUTOMATICALLY GENERATED! Do not change!

		return "g="+GOOGLE_REVISION_NUMBER+",c2p="+COME2PLAY_REVISION_NUMBER;		
	}
	
	public static var SHOULD_CALL_TRACE:Boolean = true; // in the online version we turn it off to save runtime
	public static var someMovieClip:DisplayObjectContainer; // so we can display error messages on the stage	
	public static var ALLOW_DOMAINS:String = "*";//Specifying "*" does not include local hosts	 
	
	private static var LOGGED_REVISIONS:Boolean = false;
	public static function allowDomains():void {
		if (!LOGGED_REVISIONS) {

// This is a AUTOMATICALLY GENERATED! Do not change!

			LOGGED_REVISIONS = true;			
			StaticFunctions.alwaysTrace( new ErrorHandler() );
			storeTrace(["GOOGLE_REVISION_NUMBER=",GOOGLE_REVISION_NUMBER, " COME2PLAY_REVISION_NUMBER=",COME2PLAY_REVISION_NUMBER]);
		}
		
		if (ALLOW_DOMAINS != null){
			storeTrace("Allowing all domains access to : "+ALLOW_DOMAINS+" saמdbox type :"+Security.sandboxType);
			Security.allowDomain(ALLOW_DOMAINS);
		}
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

			
	
	// Be careful that the traces will not grow too big to send to the java (limit of 1MB, enforced in Bytes2Object)
	public static var MAX_TRACES:Object = {TMP: 80, API:20, ALWAYS:100, MSG:20, STORE:50};
	public static function tmpTrace(obj:Object):void {
		p_storeTrace("TMP",obj);
	}	
	public static function apiTrace(obj:Object):void {		 		
		p_storeTrace("API",obj);
	}		

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function alwaysTrace(obj:Object):void { 
		p_storeTrace("ALWAYS",obj);
	}
	public static function msgTrace(obj:Object):void {
		p_storeTrace("MSG",obj);
	}		
	public static function storeTrace(obj:Object):void { 
		p_storeTrace("STORE",obj);
	}
	

// This is a AUTOMATICALLY GENERATED! Do not change!

	private static var keyTraces:Array = [];		
	private static function p_getArr(key:String):Array {
		if (keyTraces[key]==null) keyTraces[key] = new Array(); 
		return keyTraces[key];
	}	 
	public static var TRACE_PREFIX:String = ""; // because in flashlog you see traces of many users and it is all mixed 
	private static function p_storeTrace(key:String, obj:Object):void {
		try {
			var arr:Array = p_getArr(key);	
			var maxT:int = MAX_TRACES[key];

// This is a AUTOMATICALLY GENERATED! Do not change!

			var traceLine:Array = ["Time: ", getTimer(), obj];
			limitedPush(arr, traceLine , maxT); // we discard old traces
			if (SHOULD_CALL_TRACE) trace(TRACE_PREFIX + key+":\t" + JSON.stringifyWithNewLine(traceLine));
		} catch (err:Error) {
			if (SHOULD_CALL_TRACE) trace(TRACE_PREFIX + "\n\n\n\n\n\n\n\n\n\n\n\nERROR!!!!!!!!!!!!!!!!!!!!!!! err="+AS3_vs_AS2.error2String(err)+"\n\n\n\n\n\n\n\n\n\n\n");
		}
	}
	public static function getTraces():String {
		var res:Array = [];
		for (var key:String in keyTraces) {

// This is a AUTOMATICALLY GENERATED! Do not change!

			var tracesOfKey:Array = keyTraces[key];
			res.push(key + " "+tracesOfKey.length+" traces:"+
				(tracesOfKey.length<MAX_TRACES[key] ? "" : " (REACHED MAX TRACES)"));
			res.push( arrToString(tracesOfKey,",\n") );
			res.push("\n");
		}		
		var strRes:String = res.join("\n");
		setClipboard(strRes);
		return strRes;
	}	

// This is a AUTOMATICALLY GENERATED! Do not change!

	private static function arrToString(s:Object, sep:String):String {			
		var arr:Array = new Array();
		var isArr:Boolean = AS3_vs_AS2.isArray(s);			
		for(var o:String in s) {
			arr.push((isArr ? "" : o+"=")+JSON.stringify(s[o]));
		}
		return "["+arr.join(sep)+"]";
	}
	public static function setClipboard(msg:String):void {
		try {			

// This is a AUTOMATICALLY GENERATED! Do not change!

			trace("Setting in clipboard message:")
			trace(msg);
			System.setClipboard(msg);
		} catch (err:Error) {
			// the flash gives an error if we try to set the clipboard not due to a user activity,
			// e.g., if the java disconnects then setClipboard throws an error.
		}
	}
	public static function showError(msg:String):void {
		ErrorHandler.alwaysTraceAndSendReport(msg,"showError"); 

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static function throwError(msg:String):void {
		var err:Error = new Error(msg);
		// I know the error should be caught, but in flash you do not always wrap everything in a catch clause
		// so I prefer to also send the error to the container now
		showError("Throwing the following error="+AS3_vs_AS2.error2String(err));
		throw err;
	}		
	public static function assert(val:Boolean, args:Array):void {
		if (!val) throwError("An assertion failed with the following arguments="+JSON.stringify(args));

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	
	public static function isEmptyChar(str:String):Boolean {
		return str==" " || str=="\n" || str=="\t" || str=="\r"; //String.fromCharCode(10)
	}
	public static function trim(str:String):String {
	   var j:int, strlen:int, k:int;
	   strlen = str.length
	   j = 0;
	   while (isEmptyChar(str.charAt(j))) {

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

	   return str.substring(0,k+1);
	}
	public static function areEqual(o1:Object, o2:Object):Boolean {
		if (o1===o2) return true; // because false==[] or {} was true!
		if (o1==null || o2==null) return false;
		var t:String = typeof(o1);
		if (t!=typeof(o2)) 
			return false;
		if (AS3_vs_AS2.getClassName(o1)!=AS3_vs_AS2.getClassName(o2))
			return false;

// This is a AUTOMATICALLY GENERATED! Do not change!

			
		if (t=="object") {
			var x:String;	
			var allFields:Object = {};
			var c:int = 0;	
			for (x in o1) {
				allFields[x] = true;
				c++;
			}			
			for (x in o2) {

// This is a AUTOMATICALLY GENERATED! Do not change!

				if (allFields[x]==null) return false;
				c--;
			}
			if (c!=0) return false; // not the same number of dynamic properties
			if (AS3_vs_AS2.isAS3) {
				// for static properties we use describeType
				// because o1 and o2 have the same type, it is enough to use the fields of o1.
				var fieldsArr:Array = AS3_vs_AS2.getFieldNames(o1);
				for each (var field:String in fieldsArr) {
					allFields[field] = true;

// This is a AUTOMATICALLY GENERATED! Do not change!

				}
			}
			for (x in allFields) 	
				if (!o1.hasOwnProperty(x) || 
					!o2.hasOwnProperty(x) || 
					!areEqual(o1[x], o2[x])) return false;
			return true;
		} else {
			return o1==o2;
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	
	public static function subtractArray(arr:Array, minus:Array):Array {
		var res:Array = arr.concat();
		for each (var o:Object in minus) {
			var indexOf:int = AS3_vs_AS2.IndexOf(res, o);
			StaticFunctions.assert(indexOf!=-1, ["When subtracting minus=",minus," from array=", arr, " we did not find element ",o]);				
			res.splice(indexOf, 1);
		}
		return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	// returns true if the element was in arr
	public static function removeElement(arr:Array, element:Object):Boolean {
		var index:int = AS3_vs_AS2.IndexOf(arr,element);
		var isContained:Boolean = index!=-1;			
		if (isContained) arr.splice(index,1);	
		return isContained;		
	}
	public static function limitedPush(arr:Array, element:Object, maxSize:int):void {
		if (arr.length>=maxSize) arr.shift(); // we discard old elements (in a queue-like manner)

// This is a AUTOMATICALLY GENERATED! Do not change!

		arr.push(element);
	}
	
	// e.g., random(0,2) returns either 0 or 1
	public static function random(fromInclusive:int, toExclusive:int):int {
		var delta:int = toExclusive - fromInclusive;
		return Math.floor( delta * Math.random() ) + fromInclusive;
	}
	public static function startsWith(str:String, start:String):Boolean {
		return str.substr(0, start.length)==start;

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static function endsWith(str:String, suffix:String):Boolean {
		return str.substr(str.length-suffix.length, suffix.length)==suffix;
	}
	
	private static const REFLECTION_PREFIX:String = "REFLECTION_";
	public static function performReflectionFromFlashVars(_someMovieClip:DisplayObjectContainer):void {		
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(_someMovieClip);		
		ErrorHandler.setErrorReportUrl(parameters);
		if (SHOULD_CALL_TRACE) trace("performReflectionFromFlashVars="+JSON.stringify(parameters));

// This is a AUTOMATICALLY GENERATED! Do not change!

		for (var key:String in parameters) {
			if (startsWith(key,REFLECTION_PREFIX)) {
				var before:String = key.substr(REFLECTION_PREFIX.length);
				var after:String = parameters[key];
				performReflectionString(before, after);	
			}			
		}
	}
	public static function performReflection(reflStr:String):void {		
		var two:Array = splitInTwo(reflStr, "=", false);

// This is a AUTOMATICALLY GENERATED! Do not change!

		performReflectionString(two[0], two[1]);
	}
	public static function performReflectionString(fullClassName:String, valStr:String):void {
		performReflectionObject(fullClassName, SerializableClass.deserializeString(valStr));
	}
	public static function performReflectionObject(fullClassName:String, valObj:Object):void {
		//fullClassName = come2play_as3.util::EnumMessage.CouldNotConnect.__minDelayMilli 
		//after = 2000
		if (SHOULD_CALL_TRACE) trace("Perform reflection for: "+fullClassName+"="+JSON.stringify(valObj));
		var package2:Array = splitInTwo(fullClassName, "::", false);

// This is a AUTOMATICALLY GENERATED! Do not change!

		var fields2:Array = splitInTwo(package2[1], ".", false);
		var clzName:String = trim(package2[0]) + "::" + trim(fields2[0]);
		var fieldsName:String = trim(fields2[1]);
		var classReference:Object = AS3_vs_AS2.getClassByName(clzName);
		storeTrace("Setting field "+fieldsName+" in class "+clzName+" to val="+valObj);
		var fieldsArr:Array = fieldsName.split(".");
		for (var i:int=0; i<fieldsArr.length; i++) {
			var fieldName:String = fieldsArr[i];
			if (i<fieldsArr.length-1)
				classReference = classReference[fieldName];

// This is a AUTOMATICALLY GENERATED! Do not change!

			else
				classReference[fieldName] = valObj;			
		} 		
	}


	/**
	 * Similar to replace with:  new RegExp(searchFor,"g")
	 * but we need to escape special characters from searchFor
	 * e.g., 

// This is a AUTOMATICALLY GENERATED! Do not change!

	 * 	StaticFunctions.replaceAll("$y'+knkjh$y'+$y'+uoiuoiu$y'+8y$y'+", "$y'+","REPLACED") ==
	 * 							"REPLACEDknkjhREPLACEDREPLACEDuoiuoiuREPLACED8yREPLACED"		
	 */
	public static function replaceAll(str:String, searchFor:String, replaceWith:String):String {		
		var index:int = 0;
		var lastIndex:int = 0;
		var res:Array = [];
		while ( (index = AS3_vs_AS2.stringIndexOf(str, searchFor, index)) != -1) {
			res.push( str.substring(lastIndex,index) );
			res.push( replaceWith );

// This is a AUTOMATICALLY GENERATED! Do not change!

			index += searchFor.length;
			lastIndex = index;			
		}
		res.push( str.substring(lastIndex) );
		return res.join("");
	}
	public static function splitInTwo(str:String, searchFor:String, isLast:Boolean):Array {
		var index:int = isLast ? AS3_vs_AS2.stringLastIndexOf(str, searchFor) : AS3_vs_AS2.stringIndexOf(str, searchFor);
		if (index==-1) showError("Did not find searchFor="+searchFor+" in string="+str);
		return [str.substring(0,index),str.substring(index+searchFor.length)];

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static function replaceLastOccurance(str:String, searchFor:String, replaceWith:String):String {
		var two:Array = splitInTwo(str, searchFor, true);
		return two[0] + replaceWith + two[1];
	}
	public static function instance2Object(instance:Object, fields:Array/*String*/):Object {
		var res:Object = {};
		for each (var field:String in fields) {
			res[field] = instance[field];
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

		return res;
	}
	
	private static var cacheShortName:Object = {};
	public static function getShortClassName(obj:Object):String {
		var className:String = AS3_vs_AS2.getClassName(obj);
		if (cacheShortName[className]!=null) return cacheShortName[className];
		var res:String = className.substr(AS3_vs_AS2.stringIndexOf(className,"::")+2);
		cacheShortName[className] = res;
		return res;		

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
}
}
