package come2play_as3.pseudoCode
{
		import flash.utils.*;
public class SerializableClass {
	private var className:String;
	public function SerializableClass() {
		className = getQualifiedClassName(this);		
	}
	public static function deserialize(object:Object):SerializableClass {
		var className:String = object["className"]; 
		if (className==null) throw Error("Missing className in object");
		var _Class:Class = getDefinitionByName(className) as Class;
		var res:Object = new _Class();
		for (var key:String in object)
			res[key] = object[key];
		return res as SerializableClass; 
	}	
}
}