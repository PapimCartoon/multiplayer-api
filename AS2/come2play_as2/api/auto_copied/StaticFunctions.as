	
// Only StaticFunctions and JSON are copied to flex_utils 
import come2play_as2.api.auto_copied.*;
class come2play_as2.api.auto_copied.StaticFunctions
{			
	public static var SHOULD_SHOW_ERRORS:Boolean = true;
	public static var SHOULD_CALL_TRACE:Boolean = true; // in the online version we turn it off to save runtime
	public static var someMovieClip:MovieClip; // so we can display error messages on the stage
	public static var allTraces:Array = [];
	public static var MAX_TRACES_NUM:Number = 50;
	public static function storeTrace(obj:Object):Void {
		if (allTraces.length>=MAX_TRACES_NUM) allTraces.shift();
		var arr:Array = ["Time: ", getTimer(), " Trace: ", obj];
		if (SHOULD_CALL_TRACE) trace( arr.join("") );
		allTraces.push(arr);
	}
	public static var DID_SHOW_ERROR:Boolean = false;
	public static function getTraces():String {
		return (allTraces.length==0 ? '' : 
				(allTraces.length<MAX_TRACES_NUM ? "All":"The last "+MAX_TRACES_NUM)+" stored traces are:\n"+
				allTraces.join("\n"));
	}
	public static function setClipboard(msg:String):Void {
		try {			
			System.setClipboard(msg);
		} catch (err:Error) {
			// the flash gives an error if we try to set the clipboard not due to a user activity,
			// e.g., if the java disconnects then setClipboard throws an error.
		}
	}
	public static function showError(msg:String):Void {
		if (DID_SHOW_ERROR) return;
		DID_SHOW_ERROR = true;
		var msg:String = "An ERRRRRRRRRRROR occurred:\n"+msg+"\n"+ getTraces();
		setClipboard(msg);
		if (SHOULD_SHOW_ERRORS) AS3_vs_AS2.showError(someMovieClip, msg);
		if (SHOULD_CALL_TRACE) trace("\n\n\n"+msg+"\n\n\n");
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
			var c:Number = 0;	
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
				for (var i96:Number=0; i96<fieldsArr.length; i96++) { var field:String = fieldsArr[i96]; 
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
		for (var i112:Number=0; i112<minus.length; i112++) { var o:Object = minus[i112]; 
			var indexOf:Number = AS3_vs_AS2.IndexOf(res, o);
			StaticFunctions.assert(indexOf!=-1, ["When subtracting minus=",minus," from array=", arr, " we did not find element ",o]);				
			res.splice(indexOf, 1);
		}
		return res;
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
		if (SHOULD_CALL_TRACE) trace("performReflectionFromFlashVars="+JSON.stringify(parameters));
		for (var key:String in parameters) {
			if (startsWith(key,REFLECTION_PREFIX)) {
				var before:String = key.substr(REFLECTION_PREFIX.length);
				var after:String = parameters[key];
				performReflectionString(before, after);	
			}			
		}
	}
	public static function performReflection(reflStr:String):Void {		
		var two:Array = splitInTwo(reflStr, "=", false);
		performReflectionString(two[0], two[1]);
	}
	public static function performReflectionString(fullClassName:String, valStr:String):Void {
		performReflectionObject(fullClassName, SerializableClass.deserializeString(valStr));
	}
	public static function performReflectionObject(fullClassName:String, valObj:Object):Void {
		//fullClassName = come2play_as2.util::EnumMessage.CouldNotConnect.__minDelayMilli 
		//after = 2000
		if (SHOULD_CALL_TRACE) trace("Perform reflection for: "+fullClassName+"="+JSON.stringify(valObj));
		var package2:Array = splitInTwo(fullClassName, "::", false);
		var fields2:Array = splitInTwo(package2[1], ".", false);
		var clzName:String = trim(package2[0]) + "::" + trim(fields2[0]);
		var fieldsName:String = trim(fields2[1]);
		var classReference:Object = AS3_vs_AS2.getClassByName(clzName);
		storeTrace("Setting field "+fieldsName+" in class "+clzName+" to val="+valObj);
		var fieldsArr:Array = fieldsName.split(".");
		for (var i:Number=0; i<fieldsArr.length; i++) {
			var fieldName:String = fieldsArr[i];
			if (i<fieldsArr.length-1)
				classReference = classReference[fieldName];
			else
				classReference[fieldName] = valObj;			
		} 		
	}


	/**
	 * Similar to replace with:  new RegExp(searchFor,"g")
	 * but we need to escape special characters from searchFor
	 * e.g., 
	 * 	StaticFunctions.replaceAll("$y'+knkjh$y'+$y'+uoiuoiu$y'+8y$y'+", "$y'+","REPLACED") ==
	 * 							"REPLACEDknkjhREPLACEDREPLACEDuoiuoiuREPLACED8yREPLACED"		
	 */
	public static function replaceAll(str:String, searchFor:String, replaceWith:String):String {		
		var index:Number = 0;
		var lastIndex:Number = 0;
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
		var index:Number = isLast ? AS3_vs_AS2.stringLastIndexOf(str, searchFor) : AS3_vs_AS2.stringIndexOf(str, searchFor);
		if (index==-1) showError("Did not find searchFor="+searchFor+" in string="+str);
		return [str.substring(0,index),str.substring(index+searchFor.length)];
	}
	public static function replaceLastOccurance(str:String, searchFor:String, replaceWith:String):String {
		var two:Array = splitInTwo(str, searchFor, true);
		return two[0] + replaceWith + two[1];
	}
	public static function instance2Object(instance:Object, fields:Array/*String*/):Object {
		var res:Object = {};
		for (var i203:Number=0; i203<fields.length; i203++) { var field:String = fields[i203]; 
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
			
}
