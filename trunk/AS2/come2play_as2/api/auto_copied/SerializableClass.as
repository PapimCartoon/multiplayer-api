/**
 * Subclasses of SerializableClass MUST be PUBLIC and 
 * have a constructor without arguments.
 *
 * Good Example:
 * package somePackage {
import come2play_as2.api.auto_copied.*;
 *   class come2play_as2.api.auto_copied.PublicClass1 extends SerializableClass {
 *     public static var staticVar:Number; // static vars will NOT be serialized
 * 
 *     public var serializedField1:Number;  
 *     private var serializedField2:Number; // private vars will be serialized
 *     private var serializedField3:Array; // serialization is recursive, and goes into Arrays
 *     private var serializedField4:PublicClass2; // again, serialization is recursive
 *
 *     // you must have a constructor without any arguments!
 *     public function PublicClass1() { 
 *     }
 *     ...
 *   }
 * }
 * package somePackage {
import come2play_as2.api.auto_copied.*;
 *   class come2play_as2.api.auto_copied.PublicClass2 extends SerializableClass {
 *     ...
 *   }
 * }
 * 
 * BAD Example:
 * package somePackage {
import come2play_as2.api.auto_copied.*;
 *   class come2play_as2.api.auto_copied.PublicClass extends SerializableClass {
 *     // The constructor must not have any arguments!
 *     public function PublicClass(argument:Number) {
 *       ...
 *     }
 *     ...
 *   }
 * }
 * class PrivateClass extends SerializableClass { 
 *   ...
 * }
 * 
 * Explanation on why private classes cannot be serialized:
 * Only public should inherit from SerializableClass.
 * If the class is not public,
 * then flash chooses some random name for its package.
 * For example, in the BAD code above,
 * the qualified name of PrivateClass will be:
 *  PublicClass.as$54::PrivateClass
 * And this number may change, if you recompile a slightly modified code.
 *
 * Explanation on the implementation of serialization:
 * - When an object is sent over a LocalConnection,
 * flash removes all type-information and turns that object into
 * a primitive object (that has only primitive types, Array and Object fields).
 * - When class A inherits from SerializableClass,
 * it gets the field __CLASS_NAME__, which is set in the constructor.
 * - When you deserialize an object, a new instance of the correct class
 * is created (that is why you must have an empty constructor),
 * and then we traverse and the object and set all the fields.
 * Note that  deserialize(object)  modifies the object.
 */
import come2play_as2.api.auto_copied.*;
class come2play_as2.api.auto_copied.SerializableClass
{
	public static var CLASS_NAME_FIELD:String = "__CLASS_NAME__";
	
	// Because the shared classes have different package names, 
	// I need to replace it before and after serialization
	public static var REPLACE_IN_NAME:String = "come2play_as2.api";
	public static var REPLACE_TO:String = "COME2PLAY_PACKAGE";
	
	// Only in the API we should deserialize user-defined classes
	// (in the emulator and framework, we should deserialize only COME2PLAY_PACKAGE   
	public static var isInAPI:Boolean =  REPLACE_IN_NAME=="come2play_as2."+"api";// I replace 'come2play_as2 . api .', so don't remove the  ."+"
	
	public var __CLASS_NAME__:String;
	public function SerializableClass() {
		__CLASS_NAME__ = AS3_vs_AS2.getClassName(this);
		if (__CLASS_NAME__==null || AS3_vs_AS2.stringIndexOf(__CLASS_NAME__,"$")!=-1) 
			StaticFunctions.throwError("Illegal class name '"+__CLASS_NAME__+"' for a class that extends SerializableClass. You should only use PUBLIC classes with SerializableClass");
		if (AS3_vs_AS2.isAS3)
			AS3_vs_AS2.checkConstructorHasNoArgs(this);
		
		
		if (StaticFunctions.startsWith(__CLASS_NAME__,REPLACE_IN_NAME)) {
			__CLASS_NAME__ = REPLACE_TO + __CLASS_NAME__.substr(REPLACE_IN_NAME.length);			
		}
	}
	public static function deserialize(object:Object):Object {
		if (object==null) 
			return object;
		var className:String = 
			object.hasOwnProperty(CLASS_NAME_FIELD) ? object[CLASS_NAME_FIELD] : null;

		var res:Object = object; // we modify the object itself (so we can recurse into arrays and objects)

		if (className!=null) {
			var isAPI_Package:Boolean =
				StaticFunctions.startsWith(className, REPLACE_TO);
			if (isAPI_Package) {
				className = REPLACE_IN_NAME + className.substr(REPLACE_TO.length);
			}			 
			if (isInAPI || isAPI_Package) {
				var newObject:Object = AS3_vs_AS2.createInstanceOf(className);
				if (newObject!=null) res = newObject;
			}
		}
		for (var key:String in object)
			res[key] = deserialize(object[key]);
		return res; 
	}	
}
