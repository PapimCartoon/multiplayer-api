package come2play_as3.api.auto_copied
{
	
/**
 * A class extends SerializableClass
 * to get two features:
 * - serialization on LocalConnection
 * 	 by adding the field __CLASS_NAME__
 * - serialization to String
 *   by adding "toString()" method.
 *   The serialized string has JSON-like syntax:
 *   {$SHORT_CLASSNAME$ field1:value1 , field2:value2 , ... }
 *   For example: 
 *   {$EnumSupervisor$ name:"MiniSupervisor"}
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
 * - Your class may override
 *   public function postDeserialize():Object
 *   that may do post processing and even return a different object.
 *   This is useful in two cases:
 *   1) if you have fields that are derived from other fields (such as "__" fields).
 *   2) in Enum classes, postDeserialize may return a unique/interned object.   
 */
public class SerializableClass
{
	public static var IS_THROWING_EXCEPTIONS:Boolean = true; // in the online version we set it to false. (Consider the case that a hacker stores illegal values as secret data)
	
	public static const CLASS_NAME_FIELD:String = "__CLASS_NAME__";
	public var __CLASS_NAME__:String;
	public function SerializableClass(shortName:String) {
		__CLASS_NAME__ = shortName;
		register();
	}
	public function toString():String {
		var fieldNames:Array/*String*/ = AS3_vs_AS2.getFieldNames(this);
		var values:Object = {};			
		for each (var key:String in fieldNames) {
			if (StaticFunctions.startsWith(key,"__")) continue;
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
	public function register():void {
    	var xlass:Class = getClassOfInstance(this); 
    	var shortName:String = __CLASS_NAME__;
    	var oldXlass:Class = SHORTNAME_TO_CLASS[shortName];
    	if (oldXlass==xlass) return; // already entered this short name
    	
    	StaticFunctions.assert(oldXlass==null, ["Previously added shortName=",shortName, " with oldXlass=",oldXlass," and now with xlass=",xlass]);
    	SHORTNAME_TO_CLASS[shortName] = xlass; 
    	
    	AS3_vs_AS2.checkConstructorHasNoArgs(this);    	
    	StaticFunctions.storeTrace(["Registered class with shortName=",shortName," with exampleInstance=",this]);
    	// testing createInstance
    	var exampleInstance:SerializableClass = createInstance(shortName);    	
    }

	/**
	 * Static methods and variables.
	 */
 	private static var SHORTNAME_TO_CLASS:Object = {};
 	private static function getShortNameOfInstance(instance:SerializableClass):String {
 		var xlass:Class = getClassOfInstance(instance);
		for (var shortName:String in SHORTNAME_TO_CLASS) {
			if (SHORTNAME_TO_CLASS[shortName]==xlass)
				return shortName;
		}
		return null; 		
 	}
 	private static function getClassOfInstance(instance:SerializableClass):Class {
 		return AS3_vs_AS2.getClassOfInstance(instance);
 	}
	private static function createInstance(shortName:String):SerializableClass {
		var xlass:Class = SHORTNAME_TO_CLASS[shortName];		
		return xlass==null ? null : new xlass();
	}    
 	
	public static function deserialize(object:Object):Object {
		try {
			if (object==null) 
				return object;
			var isArray:Boolean = AS3_vs_AS2.isArray(object);
			var isObj:Boolean = isObject(object);
			var res:Object = object;
			if (isArray || isObj) {				
				var shortName:String = 
					object.hasOwnProperty(CLASS_NAME_FIELD) ? 
					object[CLASS_NAME_FIELD] : null;
				res = isArray ? [] : {}; // we create a new copy
		
				for (var key:String in object)
					res[key] = deserialize(object[key]); 
					
				if (shortName!=null) {					
					var newObject:SerializableClass = createInstance(shortName);
					if (newObject!=null) {
						for (key in res)
							newObject[key] = res[key]; // might throw an illegal assignment (due to type mismatch)

						AS3_vs_AS2.checkAllFieldsDeserialized(res, newObject);

						res = newObject.postDeserialize();
					}
				}
										
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
}