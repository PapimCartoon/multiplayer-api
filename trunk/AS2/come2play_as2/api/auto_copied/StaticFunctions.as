	import come2play_as2.api.auto_generated.API_Message;
	
	
// Only StaticFunctions and JSON are copied to flex_utils 
import come2play_as2.api.auto_copied.*;
class come2play_as2.api.auto_copied.StaticFunctions
{			
public static var GOOGLE_REVISION_NUMBER:Number = 1002;
	public static var COME2PLAY_REVISION_NUMBER:Number = 4045;
	public static var ERRORS_THROWN_LOGGER:Logger = new Logger("Throw",5);
	public static function getRevision():String {
		return (SerializableClass.IS_IN_FRAMEWORK ? "Container" : "Game")+
			" g="+GOOGLE_REVISION_NUMBER+",c2p="+COME2PLAY_REVISION_NUMBER;		
	}
	
	public static var someMovieClip:MovieClip; // so we can display error messages on the stage	
	public static var ALLOW_DOMAINS:String = "*";//Specifying "*" does not include local hosts
	public static function allowDomainForLc(lc:LocalConnection):Void {
		if (ALLOW_DOMAINS != null)
			lc.allowDomain(ALLOW_DOMAINS)	 
	}
	private static var LOGGED_REVISIONS:Boolean = false;
	private static var REVISIONS_LOG:Logger = new Logger("REVISIONS",5);
	public static function allowDomains():Void {
		if (!LOGGED_REVISIONS) {
			LOGGED_REVISIONS = true;		
			REVISIONS_LOG.log( new ErrorHandler() );
			ErrorHandler.startLogMemoryInterval();
			REVISIONS_LOG.log("GOOGLE_REVISION_NUMBER=",GOOGLE_REVISION_NUMBER, " c2p=COME2PLAY_REVISION_NUMBER=",COME2PLAY_REVISION_NUMBER, " LAST_RAN_JAVA_DATE=",API_Message.LAST_RAN_JAVA_DATE);
			if (ALLOW_DOMAINS != null){
				REVISIONS_LOG.log("Allowing all domains access to : ",ALLOW_DOMAINS," saמdbox type :",System.security.sandboxType);
				System.security.allowDomain(ALLOW_DOMAINS);
			}
		}
	}
	
			
	private static var TMP_LOGGER:Logger = new Logger("TMP",80);
	private static var API_LOGGER:Logger = new Logger("API",20);
	private static var ALWAYS_LOGGER:Logger = new Logger("ALWAYS",100);
	private static var MSG_LOGGER:Logger = new Logger("MSG",20);
	private static var STORE_LOGGER:Logger = new Logger("STORE",50);
	public static function tmpTrace(obj:Object):Void {
		TMP_LOGGER.log(obj);
	}	
	public static function apiTrace(obj:Object):Void {
		API_LOGGER.log(obj);
	}		
	public static function alwaysTrace(obj:Object):Void { 
		ALWAYS_LOGGER.log(obj);
	}
	public static function msgTrace(obj:Object):Void {
		MSG_LOGGER.log(obj);
	}		
	public static function storeTrace(obj:Object):Void { 
		STORE_LOGGER.log(obj);
	}
	
	public static function pushAll(toArr:Array, fromArr:Array):Void {
		toArr.push.apply(null,fromArr);
	}
	public static function getTracesOfLoggers(loggers:Array/*Logger*/, maxTotal:Number):String {		
		var res:Array/*LoggerLine*/ = [];
		var p67:Number=0; for (var i67:String in loggers) { var logger:Logger = loggers[loggers.length==null ? i67 : p67]; p67++;
			pushAll(res, logger.getMyTraces());
		}		
		// I sort the traces		
		res.sort(function (arg1:LoggerLine, arg2:LoggerLine):Number {
			return arg1.traceId - arg2.traceId;
		});
		return arrToString(res, maxTotal);
	}
	private static var INDENT_DEPTHS:Array/*String*/ = ["","\t","\t\t","\t\t\t","\t\t\t\t","\t\t\t\t\t","\t\t\t\t\t\t"];
	private static function arrToString(arr:Array/*LoggerLine*/, maxTotal:Number):String {			
		var res:Array = new Array();
		var len:Number = 0;
		// the latest traces are the most important
		for (var i:Number = arr.length-1; i>=0; i--) {
			var l:LoggerLine = arr[i];
			var indent:String = INDENT_DEPTHS[Math.min(INDENT_DEPTHS.length-1, l.indent)]; 
			var line:String = "id="+l.traceId+"\tt="+l.traceTime+"\t"+indent+l.loggerName+"\t"+JSON.stringify(l.obj);
			var s:String = StaticFunctions.cutString(line, l.maxLen);
			len += s.length;
			if (len>=maxTotal) break;
			res.push(s); 
		}
		res.reverse();
		return "["+res.join(",\n")+"]";
	}
	public static var MAX_TOTAL:Number 	= 2000000;	//2000KB
	public static function getTraces():String {		
		var strRes:String = getTracesOfLoggers(Logger.ALL_LOGGERS,MAX_TOTAL);
		setClipboard(strRes);
		return strRes;
	}
	
	// for example,  
	//prefixZeros("3",3) returns  "003"
	//prefixZeros("23",3) returns "023"
	public static function prefixZeros(str:String, toLen:Number):String {
		var res:String = str;
		for (var i:Number=str.length; i<=toLen; i++)
			res = "0"+res;
		return res;
	}
	public static function cutString(str:String, toSize:Number):String {		
		if (str.length<toSize) return str;
		return str.substr(0,toSize)+"... (string cut)";
	}
	public static function setClipboard(msg:String):Void {
		try {			
			trace("Setting in clipboard message:")
			trace(cutString(msg,20));
			System.setClipboard(msg);
		} catch (err:Error) {
			// the flash gives an error if we try to set the clipboard not due to a user activity,
			// e.g., if the java disconnects then setClipboard throws an error.
		}
	}
	public static function showError(msg:String):Void {
		ErrorHandler.alwaysTraceAndSendReport(msg,"showError"); 
	}
	public static function throwError(msg:String):Void {
		var err:Error = new Error(msg);
		// I know the error should be caught, but in flash you do not always wrap everything in a catch clause
		// so I prefer to also send the error to the container now
		ERRORS_THROWN_LOGGER.log("Throwing the following error="+AS3_vs_AS2.error2String(err))
		throw err;
	}		
	public static function assert(val:Boolean, name:String/*InAS3: ...args*/):Void { var args:Array = arguments.slice(2); 
		if (name==null || name=='') throwError("When calling assert you must pass a non empty name! args="+JSON.stringify(args)); 
		if (!val) throwError("An assertion failed! name="+name+" arguments="+JSON.stringify(args));
	}
	
	public static function isEmptyChar(str:String):Boolean {
		return str==" " || str=="\n" || str=="\t" || str=="\r"; //String.fromCharCode(10)
	}
	public static function trim(str:String):String {
		if (str==null) return null;
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
		// Array and ImmutableArray are considered equal identical
		var isArr1:Boolean = AS3_vs_AS2.isArray(o1); 
		var isArr2:Boolean = AS3_vs_AS2.isArray(o2); 
		if (isArr1!=isArr2) return false;
		if (!isArr1 && AS3_vs_AS2.getClassName(o1)!=AS3_vs_AS2.getClassName(o2))
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
				var p189:Number=0; for (var i189:String in fieldsArr) { var field:String = fieldsArr[fieldsArr.length==null ? i189 : p189]; p189++;
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
	
	public static function sortAndCountOccurrences(arr:Array/*String*/):Array/*String*/ {
		arr.sort();
		if (arr.length>0) arr.push(""); // to handle the last string in arr
		var res:Array/*String[]*/ = [];
		var lastStr:String = null;
		var lastCount:Number = 0;
		var p209:Number=0; for (var i209:String in arr) { var str:String = arr[arr.length==null ? i209 : p209]; p209++;
			if (lastStr!=str) {
				if (lastStr!=null) res.push([lastCount, lastCount+" occurrences of: "+lastStr]);
				lastCount = 1;
				lastStr = str;
			} else {
				lastCount++;
			}			
		}
		res.sort(function (arr1:Array,arr2:Array):Number {
			return arr2[0] - arr1[0]; // DESC order
		});
		var res2:Array/*String*/ = [];
		var p222:Number=0; for (var i222:String in res) { var countArr:Array = res[res.length==null ? i222 : p222]; p222++;
			res2.push(countArr[1]);
		}
		return res2;
	}
	public static function subtractArray(arr:Array, minus:Array):Array {
		var res:Array = arr.concat();
		var p229:Number=0; for (var i229:String in minus) { var o:Object = minus[minus.length==null ? i229 : p229]; p229++;
			var indexOf:Number = AS3_vs_AS2.IndexOf(res, o);
			StaticFunctions.assert(indexOf!=-1, "When subtracting minus=",[minus," from array=", arr, " we did not find element ",o]);				
			res.splice(indexOf, 1);
		}
		return res;
	}
	// returns true if the element was in arr
	public static function removeElement(arr:Array, element:Object):Boolean {
		var index:Number = AS3_vs_AS2.IndexOf(arr,element);
		var isContained:Boolean = index!=-1;			
		if (isContained) arr.splice(index,1);	
		return isContained;		
	}
	public static function limitedPush(arr:Array, element:Object, maxSize:Number):Void {
		Logger.limitedPush(arr,element,maxSize);
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
	
	public static var REFLECTION_PREFIX:String = "REFLECTION_";
	private static var REFLECTION_LOG:Logger = new Logger("REFLECTION",100);
	public static function performReflectionFromFlashVars(_someMovieClip:MovieClip):Void {		
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(_someMovieClip);		
		performReflectionFromObject(parameters);		
	}
	public static function performReflectionFromObject(parameters:Object):Void {
		REFLECTION_LOG.log("performReflectionFromFlashVars=",parameters);
		// e.g., REFLECTION_come2play_as2.util::General.isDoingTrace=true
		for (var key:String in parameters) {
			if (startsWith(key,REFLECTION_PREFIX)) {
				var before:String = key.substr(REFLECTION_PREFIX.length);
				var after:String = parameters[key];
				// e.g., 
				// before=come2play_as2.util::General.isDoingTrace
				// after=true
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
		REFLECTION_LOG.log("Perform reflection for: ",fullClassName,"=",valObj);
		try {
			var package2:Array = splitInTwo(fullClassName, "::", false);
			var fields2:Array = splitInTwo(package2[1], ".", false);
			var clzName:String = trim(package2[0]) + "::" + trim(fields2[0]);
			var fieldsName:String = trim(fields2[1]);
			var classReference:Object = AS3_vs_AS2.getClassByName(clzName);
			var oldVal:Object = null;
			var fieldsArr:Array = fieldsName.split(".");
			for (var i:Number=0; i<fieldsArr.length; i++) {
				var fieldName:String = fieldsArr[i];
				if (i<fieldsArr.length-1)
					classReference = classReference[fieldName];
				else {
					oldVal = classReference[fieldName];
					classReference[fieldName] = valObj;
				}			
			} 		
			REFLECTION_LOG.log("Setting field ",fieldsName," in class ",clzName,": oldVal=",oldVal, " newVal=",valObj);
		} catch (e:Error) {
			REFLECTION_LOG.log("An error occurred while doing reflection:",e);			
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
		
		if (res.length==0) return str; // an optimization only
		
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
		var p348:Number=0; for (var i348:String in fields) { var field:String = fields[fields.length==null ? i348 : p348]; p348++;
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
		var xlass:Object/*Class*/ = AS3_vs_AS2.getClassOfInstance(msg);
		var res:Object = xlass[fieldName];
		assert(res!=null, "getClassFromMsg",["Missing ",fieldName," in msg=",msg, " xlass=",xlass]);
		return res;
	}
	private static function getParamNames(msg:API_Message):Array/*String*/ {
		return AS3_vs_AS2.asArray(getClassFromMsg(msg,"METHOD_PARAMS"));
	}
	public static function getFunctionId(msg:API_Message):Number { 
		return AS3_vs_AS2.as_int(getClassFromMsg(msg,"FUNCTION_ID"));
	}
	public static function getMethodName(msg:API_Message):String {
		return getClassFromMsg(msg,"METHOD_NAME").toString();		 
	} 	
	public static function getMethodParametersNum(msg:API_Message):Number { 
		return getParamNames(msg).length;
	}
	public static function setMethodParameters(msg:API_Message, parameters:Array):Void { 
		var names:Array = getParamNames(msg); 
		var pos:Number = 0;
		var p387:Number=0; for (var i387:String in names) { var name:String = names[names.length==null ? i387 : p387]; p387++;
			msg[name] = parameters[pos++];
		}
	}
	public static function getMethodParameters(msg:API_Message):Array { 
		var names:Array = getParamNames(msg);
		var res:Array = [];
		var p394:Number=0; for (var i394:String in names) { var name:String = names[names.length==null ? i394 : p394]; p394++;
			res.push(msg[name]);
		}
		return res;
	}
}
