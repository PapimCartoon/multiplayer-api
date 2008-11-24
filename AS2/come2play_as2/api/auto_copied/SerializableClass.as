	
/**
 * A class may extend SerializableClass
 * 	to get the following features:
 * - field __CLASS_NAME__ contains a unique name,
 * 	 by default it is the class name (without the package name).  
 * - serialization on LocalConnection
 * 	 using the method "toObject()".
 * - serialization to String
 *   using the method "toString()".
 *   The serialized string has JSON-like syntax:
 *   {$SHORT_CLASSNAME$ field1:value1 , field2:value2 , ... }
 *   For example: 
 *   {$EnumSupervisor$ name:"MiniSupervisor"}
 * - serialization to XML
 *   by adding "toXML():XMLNode" method.
 * 
 * Static functions to do deserialization:
 * - deserializeXML
 * - deserializeString
 * 
 * Restriction:
 * - serialized fields must be public (non-static)
 * - constructor without arguments
 * - You must call 
 *   register()
 * 
 * Other features:
 * - fields starting with "__" are not serialized to String 
 *   (but they are serialized on LocalConnection)
 * - Your class may override postDeserialize
 *   to do post processing and even return a different object.
 *   This is useful in two cases:
 *   1) if you have fields that are derived from other fields (such as "__" fields).
 *   2) in Enum classes, postDeserialize may return a unique/interned object.
 * 
 * Event fields: 
 * 	
 *    
 */
import come2play_as2.api.auto_copied.*;
class come2play_as2.api.auto_copied.SerializableClass /*<InAPI>extends Event</InAPI>*/
{
	public static var EVENT_FIELDS:Array
		/*<InAPI> = ["type", "bubbles", "cancelable", "currentTarget", "eventPhase", "target"]</InAPI>*/;
	public static var IS_THROWING_EXCEPTIONS:Boolean = true; // in the online version we set it to false. (Consider the case that a hacker stores secret data which is illegal values)
	public static var IS_TESTING_SAME_REGISTER:Boolean = true; // for efficiency the online version turns it off
	public static var IS_TRACE_REGISTER:Boolean = false;
	
	// this code changes when the java auto-copies the code (we replace come2play_as2.api with the new package name, which is either come2play_as2 or emulator)
	public static var IS_IN_GAME:Boolean = "come2play_as2.api" == "come2play_as2" + ".api";
	public static var IS_IN_FRAMEWORK:Boolean = "come2play_as2.api" == "come2play_as2"; 
	
	public static var CLASS_NAME_FIELD:String = "__CLASS_NAME__";
	public var __CLASS_NAME__:String;
	public function SerializableClass(shortName:String /*<InAS3>= null</InAS3>*/
			/*<InAPI>, bubbles:Boolean = false, cancelable:Boolean = false</InAPI>*/
			) {
		__CLASS_NAME__ = shortName==null ? StaticFunctions.getShortClassName(this) : shortName;
		/*<InAPI>super(__CLASS_NAME__,bubbles, cancelable);</InAPI>*/
		StaticFunctions.assert(!XMLSerializer.isReserved(__CLASS_NAME__),["The shortName=",__CLASS_NAME__," is a reserved word, please use another shortName."]); 
		StaticFunctions.assert(AS3_vs_AS2.stringIndexOf(__CLASS_NAME__,"$")==-1,["Illegal shortName in SerializableClass! shortName=",shortName]);
		register();
	}	
	public function getFieldNames():Array/*String*/ {
		var res:Array/*String*/ = [];
		var fieldNames:Array/*String*/ = AS3_vs_AS2.getFieldNames(this);	
		for (var i68:Number=0; i68<fieldNames.length; i68++) { var key:String = fieldNames[i68]; 
			if (StaticFunctions.startsWith(key,"__")) continue;
			if (EVENT_FIELDS!=null && AS3_vs_AS2.IndexOf(EVENT_FIELDS,key)!=-1) continue;
			res.push(key);
		}
		return res;
	}
		
	public function toObject():Object {
		var values:Object = {};		
		values[CLASS_NAME_FIELD] = __CLASS_NAME__;	
		for (var i79:Number=0; i79<getFieldNames().length; i79++) { var key:String = getFieldNames()[i79]; 
			values[key] = serializable2Object(this[key]); 
		}
		return values;		
	}
	/*<InAPI>public function eventToString():String { return super.toString(); }</InAPI>*/
	/*<InAPI>override</InAPI>*/ public function toString():String {
		var values:Object = {}; // shallow object - we do not change the inner serializables to Object		
		for (var i87:Number=0; i87<getFieldNames().length; i87++) { var key:String = getFieldNames()[i87]; 
			values[key] = this[key]; 
		}	
		return JSON.instanceToString(__CLASS_NAME__, values);
	}
	public function isEqual(other:SerializableClass):Boolean {
		return ObjectDictionary.areEqual(this, other);
	}
	public function postDeserialize():SerializableClass {
		return this;
	}
	public function register():Void {
    	// In Enum classes in $cinit(), we call register in the ctor, and the class have not yet loaded.
    	// var xlass:Object/*Class*/ = getClassOfInstance(this); 
    	var shortName:String = __CLASS_NAME__;
    	var oldInstance:Object = SHORTNAME_TO_INSTANCE[shortName];
    	if (oldInstance!=null) {
    		// already entered this short name  
    		if (IS_TESTING_SAME_REGISTER) {
	    		var newXlass:String = AS3_vs_AS2.getClassName(this);
		    	var oldXlass:String = AS3_vs_AS2.getClassName(oldInstance);
	    		StaticFunctions.assert(oldXlass==newXlass, ["Previously added shortName=",shortName, " with oldXlass=",oldXlass," and now with newXlass=",newXlass]);
	    	}
    		return;
    	}
    	SHORTNAME_TO_INSTANCE[shortName] = this; 
    	
    	AS3_vs_AS2.checkConstructorHasNoArgs(this);    	
    	if (IS_TRACE_REGISTER) 
    		StaticFunctions.storeTrace(["Registered class with shortName=",shortName," with exampleInstance=",this]);
    	// testing createInstance
    	//var exampleInstance:SerializableClass = createInstance(shortName);    	
    }

	/**
	 * Static methods and variables.
	 */
 	private static var SHORTNAME_TO_INSTANCE:Object = {};
 	
 	private static function getClassOfInstance(instance:SerializableClass):Object/*Class*/ {
 		return AS3_vs_AS2.getClassOfInstance(instance);
 	}
 	private static function getClassOfShortName(shortName:String):Object/*Class*/ {
 		var instance:SerializableClass = SHORTNAME_TO_INSTANCE[shortName];
 		StaticFunctions.assert(instance!=null, ["You forgot to call SerializableClass.register for shortName=",shortName]); 
 		return getClassOfInstance(instance); 		
 	}
	private static function createInstance(shortName:String):SerializableClass {
		var xlass:Object/*Class*/ = getClassOfShortName(shortName);		
		return xlass==null ? null : new xlass();
	}    
 	
	//todo: public static function deserializeXML(xml:String):Object {
	//	return deserialize( JSON.parse(str) );
	//}
	public static function deserializeString(str:String):Object {
		return deserialize( JSON.parse(str) );
	}
	
	public static function serializable2Object(object:Object):Object {	
		if (object==null) return null;	
		if (AS3_vs_AS2.isSerializableClass(object)) 
			return AS3_vs_AS2.asSerializableClass(object).toObject();
		var isArray:Boolean = AS3_vs_AS2.isArray(object);
		var isObj:Boolean = isObject(object);
		var res:Object = object;
		if (isArray || isObj) {
			res = isArray ? [] : {}; // we create a new copy	
			for (var key:String in object)
				res[key] = serializable2Object(object[key]);
		}
		return res;
	}
	public static function shallowDeserialize(object:Object):Object {
		var shortName:String = 
					object.hasOwnProperty(CLASS_NAME_FIELD) ? 
					object[CLASS_NAME_FIELD] : null;
		if (shortName!=null && 
			(IS_IN_GAME || SHORTNAME_TO_INSTANCE[shortName]!=null)) {				
			var newObject:SerializableClass = createInstance(shortName);
			if (newObject!=null) {
				for (var key:String in object)
					newObject[key] = object[key]; // might throw an illegal assignment (due to type mismatch)

				AS3_vs_AS2.checkAllFieldsDeserialized(object, newObject);

				object = newObject.postDeserialize();
			}
		}
		return object;
	}
	public static function deserialize(object:Object):Object {
		try {
			if (object==null) return null;
			var isArray:Boolean = AS3_vs_AS2.isArray(object);
			var isObj:Boolean = isObject(object);
			var res:Object = object;
			if (isArray || isObj) {				
				
				res = isArray ? [] : {}; // we create a new copy
		
				for (var key:String in object)
					res[key] = deserialize(object[key]); 
				
				res = shallowDeserialize(res);						
			}
			//trace(JSON.stringify(object)+" object="+object+" res="+res+" isArray="+isArray+" isObj="+isObj);
			return res; 						
		} catch (err:Error) {
			// I can't throw an exception, because if a hacker stored illegal value in shortName, 
			//	then it will cause an error (that may be discovered only in the reveal stage)
			// instead the client should call setMaybeHackerUserId before processing secret data.
			StaticFunctions.storeTrace("Exception thrown in deserialize:"+AS3_vs_AS2.error2String(err));
			if (IS_THROWING_EXCEPTIONS)
				throw err;
		}
		return object;
	}	
	public static function isToStringObject(str:String):Boolean {
		return str=="[object Object]";
	}
	public static function isObject(o:Object):Boolean {
		return isToStringObject(o.toString());	
	}
}
