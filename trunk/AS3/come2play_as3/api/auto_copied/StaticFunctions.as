package come2play_as3.api.auto_copied
{
	import come2play_as3.api.auto_generated.API_Message;
	
	import flash.display.*;
	import flash.system.*;
	import flash.utils.*;
	
// Only StaticFunctions and JSON are copied to flex_utils 
public final class StaticFunctions
{			
	public static var GOOGLE_REVISION_NUMBER:int = 971;
	public static var COME2PLAY_REVISION_NUMBER:int = 2778;
	public static function getRevision():String {
		return "g="+GOOGLE_REVISION_NUMBER+",c2p="+COME2PLAY_REVISION_NUMBER;		
	}
	
	public static var SHOULD_CALL_TRACE:Boolean = true; // in the online version we turn it off to save runtime
	public static var someMovieClip:DisplayObjectContainer; // so we can display error messages on the stage	
	public static var ALLOW_DOMAINS:String = "*";//Specifying "*" does not include local hosts	 
	
	private static var LOGGED_REVISIONS:Boolean = false;
	public static function allowDomains():void {
		if (!LOGGED_REVISIONS) {
			LOGGED_REVISIONS = true;			
			StaticFunctions.alwaysTrace( new ErrorHandler() );
			storeTrace(["GOOGLE_REVISION_NUMBER=",GOOGLE_REVISION_NUMBER, " COME2PLAY_REVISION_NUMBER=",COME2PLAY_REVISION_NUMBER, " LAST_RAN_JAVA_DATE=",API_Message.LAST_RAN_JAVA_DATE]);
		}
		
		if (ALLOW_DOMAINS != null){
			storeTrace(["Allowing all domains access to : ",ALLOW_DOMAINS," saמdbox type :",Security.sandboxType]);
			Security.allowDomain(ALLOW_DOMAINS);
		}
	}
			
	
	// Be careful that the traces will not grow too big to send to the java (limit of 1MB, enforced in Bytes2Object)
	public static var MAX_TRACES:Object = {TMP: 80, API:20, ALWAYS:100, MSG:20, STORE:50};
	public static function tmpTrace(obj:Object):void {
		p_storeTrace("TMP",obj);
	}	
	public static function apiTrace(obj:Object):void {		 		
		p_storeTrace("API",obj);
	}		
	public static function alwaysTrace(obj:Object):void { 
		p_storeTrace("ALWAYS",obj);
	}
	public static function msgTrace(obj:Object):void {
		p_storeTrace("MSG",obj);
	}		
	public static function storeTrace(obj:Object):void { 
		p_storeTrace("STORE",obj);
	}
	
	private static var keyTraces:Array = [];		
	private static function p_getArr(key:String):Array {
		if (keyTraces[key]==null) keyTraces[key] = new Array(); 
		return keyTraces[key];
	}	 
	public static var RANDOM_PREFIX:String = "Rnd"+int(100+Math.random()*900)+": "; 
	public static var TRACE_PREFIX:String = ""; // because in flashlog you see traces of many users and it is all mixed 
	private static function p_storeTrace(key:String, obj:Object):void {
		try {
			var arr:Array = p_getArr(key);	
			var maxT:int = MAX_TRACES[key];
			var traceLine:Array = ["Time: ", getTimer(), obj];
			limitedPush(arr, traceLine , maxT); // we discard old traces
			if (SHOULD_CALL_TRACE) trace(RANDOM_PREFIX+TRACE_PREFIX + key+":\t" + JSON.stringify(traceLine));
		} catch (err:Error) {
			if (SHOULD_CALL_TRACE) trace(RANDOM_PREFIX+TRACE_PREFIX + "\n\n\n\n\n\n\n\n\n\n\n\nERROR!!!!!!!!!!!!!!!!!!!!!!! err="+AS3_vs_AS2.error2String(err)+"\n\n\n\n\n\n\n\n\n\n\n");
		}
	}
	public static function getTraces():String {
		var res:Array = [];
		// I want to sort the keys (to make the order of traces deterministic
		var keys:Array = [];
		for (var k:String in keyTraces) keys.push(k);
		keys.sort();
		
		for each (var key:String in keys) {
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
	private static function arrToString(s:Object, sep:String):String {			
		var arr:Array = new Array();
		var isArr:Boolean = AS3_vs_AS2.isArray(s);			
		for(var o:String in s) {
			arr.push((isArr ? "" : o+"=")+JSON.stringify(s[o]));
		}
		return "["+arr.join(sep)+"]";
	}
	public static function cutString(str:String, toSize:int):String {		
		if (str.length<toSize) return str;
		return str.substr(0,toSize)+"... (string cut)";
	}
	public static function setClipboard(msg:String):void {
		try {			
			trace("Setting in clipboard message:")
			trace(cutString(msg,20));
			System.setClipboard(msg);
		} catch (err:Error) {
			// the flash gives an error if we try to set the clipboard not due to a user activity,
			// e.g., if the java disconnects then setClipboard throws an error.
		}
	}
	public static function showError(msg:String):void {
		ErrorHandler.alwaysTraceAndSendReport(msg,"showError"); 
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
	}
	
	public static function isEmptyChar(str:String):Boolean {
		return str==" " || str=="\n" || str=="\t" || str=="\r"; //String.fromCharCode(10)
	}
	public static function trim(str:String):String {
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
	   k = str.length - 1;
	   while(isEmptyChar(str.charAt(k))) {
		  k--;
	   }
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
			
		if (t=="object") {
			var x:String;	
			var allFields:Object = {};
			var c:int = 0;	
			for (x in o1) {
				allFields[x] = true;
				c++;
			}			
			for (x in o2) {
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
	}
	
	public static function subtractArray(arr:Array, minus:Array):Array {
		var res:Array = arr.concat();
		for each (var o:Object in minus) {
			var indexOf:int = AS3_vs_AS2.IndexOf(res, o);
			StaticFunctions.assert(indexOf!=-1, ["When subtracting minus=",minus," from array=", arr, " we did not find element ",o]);				
			res.splice(indexOf, 1);
		}
		return res;
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
		arr.push(element);
	}
	
	// e.g., random(0,2) returns either 0 or 1
	public static function random(fromInclusive:int, toExclusive:int):int {
		var delta:int = toExclusive - fromInclusive;
		return Math.floor( delta * Math.random() ) + fromInclusive;
	}
	public static function startsWith(str:String, start:String):Boolean {
		return str.substr(0, start.length)==start;
	}
	public static function endsWith(str:String, suffix:String):Boolean {
		return str.substr(str.length-suffix.length, suffix.length)==suffix;
	}
	
	private static const REFLECTION_PREFIX:String = "REFLECTION_";
	public static function performReflectionFromFlashVars(_someMovieClip:DisplayObjectContainer):void {		
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(_someMovieClip);		
		if (SHOULD_CALL_TRACE) trace("performReflectionFromFlashVars="+JSON.stringify(parameters));
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
		var fields2:Array = splitInTwo(package2[1], ".", false);
		var clzName:String = trim(package2[0]) + "::" + trim(fields2[0]);
		var fieldsName:String = trim(fields2[1]);
		var classReference:Object = AS3_vs_AS2.getClassByName(clzName);
		var oldVal:Object = null;
		var fieldsArr:Array = fieldsName.split(".");
		for (var i:int=0; i<fieldsArr.length; i++) {
			var fieldName:String = fieldsArr[i];
			if (i<fieldsArr.length-1)
				classReference = classReference[fieldName];
			else {
				oldVal = classReference[fieldName];
				classReference[fieldName] = valObj;
			}			
		} 		
		storeTrace(["Setting field ",fieldsName," in class ",clzName,": oldVal=",oldVal, " newVal=",valObj]);
	}


	/**
	 * Similar to replace with:  new RegExp(searchFor,"g")
	 * but we need to escape special characters from searchFor
	 * e.g., 
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
		return res;
	}
	
	private static var cacheShortName:Object = {};
	public static function getShortClassName(obj:Object):String {
		var className:String = AS3_vs_AS2.getClassName(obj);
		if (cacheShortName[className]!=null) return cacheShortName[className];
		var res:String = className.substr(AS3_vs_AS2.stringIndexOf(className,"::")+2);
		cacheShortName[className] = res;
		return res;		
	}
	
	
	
	// The Java auto generates all classes	
	private static function getClassFromMsg(msg:API_Message, fieldName:String):Object {
		var xlass:Class = AS3_vs_AS2.getClassOfInstance(msg);
		var res:Object = xlass[fieldName];
		assert(res!=null, ["Missing ",fieldName," in msg=",msg, " xlass=",xlass]);
		return res;
	}
	private static function getParamNames(msg:API_Message):Array/*String*/ {
		return AS3_vs_AS2.asArray(getClassFromMsg(msg,"METHOD_PARAMS"));
	}
	public static function getFunctionId(msg:API_Message):int { 
		return AS3_vs_AS2.as_int(getClassFromMsg(msg,"FUNCTION_ID"));
	}
	public static function getMethodName(msg:API_Message):String {
		return getClassFromMsg(msg,"METHOD_NAME").toString();		 
	} 	
	public static function getMethodParametersNum(msg:API_Message):int { 
		return getParamNames(msg).length;
	}
	public static function setMethodParameters(msg:API_Message, parameters:Array):void { 
		var names:Array = getParamNames(msg); 
		var pos:int = 0;
		for each (var name:String in names) {
			msg[name] = parameters[pos++];
		}
	}
	public static function getMethodParameters(msg:API_Message):Array { 
		var names:Array = getParamNames(msg);
		var res:Array = [];
		for each (var name:String in names) {
			res.push(msg[name]);
		}
		return res;
	}
}
}