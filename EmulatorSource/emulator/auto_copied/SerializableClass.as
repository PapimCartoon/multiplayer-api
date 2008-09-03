// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/SerializableClass.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!


public class SerializableClass
{
	public static const CLASS_NAME_FIELD:String = "__CLASS_NAME__";
	
	// Because the shared classes have different package names, 
	// I need to replace it before and after serialization
	public static const REPLACE_IN_NAME:String = "emulator";
	public static const REPLACE_TO:String = "COME2PLAY_PACKAGE";
	

// This is a AUTOMATICALLY GENERATED! Do not change!

	// Only in the API we should deserialize user-defined classes
	// (in the emulator and framework, we should deserialize only COME2PLAY_PACKAGE   
	public static const isInAPI:Boolean =  REPLACE_IN_NAME=="come2play_as3."+"api";// I replace 'come2play_as3 . api .', so don't remove the  ."+"
	
	public var __CLASS_NAME__:String;
	public function SerializableClass() {
		__CLASS_NAME__ = AS3_vs_AS2.getClassName(this);
		if (__CLASS_NAME__==null || AS3_vs_AS2.stringIndexOf(__CLASS_NAME__,"$")!=-1) 
			StaticFunctions.throwError("Illegal class name '"+__CLASS_NAME__+"' for a class that extends SerializableClass. You should only use PUBLIC classes with SerializableClass");
		if (AS3_vs_AS2.isAS3)

// This is a AUTOMATICALLY GENERATED! Do not change!

			AS3_vs_AS2.checkConstructorHasNoArgs(this);
		
		
		if (StaticFunctions.startsWith(__CLASS_NAME__,REPLACE_IN_NAME)) {
			__CLASS_NAME__ = REPLACE_TO + __CLASS_NAME__.substr(REPLACE_IN_NAME.length);			
		}
	}
	public static function deserialize(object:Object):Object {
		if (object==null) 
			return object;

// This is a AUTOMATICALLY GENERATED! Do not change!

		var className:String = 
			object.hasOwnProperty(CLASS_NAME_FIELD) ? object[CLASS_NAME_FIELD] : null;

		var res:Object = object; // we modify the object itself (so we can recurse into arrays and objects)

		if (className!=null) {
			var isAPI_Package:Boolean =
				StaticFunctions.startsWith(className, REPLACE_TO);
			if (isAPI_Package) {
				className = REPLACE_IN_NAME + className.substr(REPLACE_TO.length);

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

}
}
