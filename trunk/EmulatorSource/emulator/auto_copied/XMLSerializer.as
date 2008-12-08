// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/XMLSerializer.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

public final class XMLSerializer
{
	public static function test():void {			
		var test:Object = [1,2,"c",true,null, -4,"<&&boo>",{a:null,x: new SerializableClass(), b:["","b"]}];
		var xml:XML = XMLSerializer.toXML(test);
		var test2:Object = SerializableClass.deserialize(XMLSerializer.xml2Object(xml));
		trace("XMLSerializer xml=\n"+xml+" test2="+JSON.stringify(test2));
		StaticFunctions.assert(StaticFunctions.areEqual(test,test2),[test,test2]);		
	}
	public static function xml2Object(xml:XML):Object {

// This is a AUTOMATICALLY GENERATED! Do not change!

		var name:String = AS3_vs_AS2.xml_getName(xml);
		if (name==RESERVED_NAMES.nullName) return null;
		if (name==RESERVED_NAMES.num || 
			name==RESERVED_NAMES.bool || 
			name==RESERVED_NAMES.str) {
			var simpleContent:String = AS3_vs_AS2.xml_getSimpleContent(xml);
			if (name==RESERVED_NAMES.num)
				return Number(simpleContent);
			if (name==RESERVED_NAMES.bool)
				return Boolean(simpleContent);

// This is a AUTOMATICALLY GENERATED! Do not change!

			return simpleContent;
		}
		var children:Array/*XML*/ = AS3_vs_AS2.xml_getChildren(xml);
		if (name==RESERVED_NAMES.arr) {
			var arr:Array = [];
			for each (var child2:XML in children) {
				arr.push( xml2Object(child2) );
			}
			return arr;					
		} else {

// This is a AUTOMATICALLY GENERATED! Do not change!

			var obj:Object = {};
			if (name!=RESERVED_NAMES.obj)
				obj[SerializableClass.CLASS_NAME_FIELD] = name;
				
			for each (var child:XML in children) {
				var singleGrandChild:Array = 
					AS3_vs_AS2.xml_getChildren(child);
				StaticFunctions.assert(singleGrandChild.length==1, ["A field should have a single value! Illegal child=",child]);
				obj[ AS3_vs_AS2.xml_getName(child) ] =
					xml2Object( singleGrandChild[0] );

// This is a AUTOMATICALLY GENERATED! Do not change!

			}
			return obj;
		}
	}
    public static function toXML(arg:Object):XML {
    	return AS3_vs_AS2.xml_create(toString(arg));	    		    	
    }	    
    public static function toString(arg:Object):String {
    	var res:Array = [];
    	p_toString("", res, arg);

// This is a AUTOMATICALLY GENERATED! Do not change!

    	return res.join("");	    	
    }
    public static function escapeXML(str:String):String {
    	// escaping &<>  to &amp;&lt;&gt;
		return 	StaticFunctions.replaceAll(
				StaticFunctions.replaceAll(
				StaticFunctions.replaceAll(str,"&","&amp;"),
				 							"<","&lt;"),
				 							">","&gt;");					 							
    }

// This is a AUTOMATICALLY GENERATED! Do not change!

    public static function isReserved(s:String):Boolean {
    	for each (var str:String in RESERVED_NAMES) {
    		if (s==str) return true;	    		
    	}
    	return false;
    }
    private static var RESERVED_NAMES:Object =
    	{ nullName: "null",
    	  num: "num",
    	  bool: "bool",

// This is a AUTOMATICALLY GENERATED! Do not change!

    	  str: "str",
    	  arr: "arr",
    	  obj: "obj" };
    private static function p_toString(indentStr:String, res:Array, arg:Object):void {
    	var i:int;
    	var elementType:String = 
    		arg==null ? RESERVED_NAMES.nullName :
    		AS3_vs_AS2.isNumber(arg) ? RESERVED_NAMES.num :
    		AS3_vs_AS2.isBoolean(arg) ? RESERVED_NAMES.bool :
    		AS3_vs_AS2.isString(arg) ? RESERVED_NAMES.str : 

// This is a AUTOMATICALLY GENERATED! Do not change!

    		null;
    	var childrenKeys:Array = null;
    	var isArr:Boolean = AS3_vs_AS2.isArray(arg);
    	if (elementType==null) {
    		// complex element
    		if (isArr) {
    			elementType = RESERVED_NAMES.arr;
    			childrenKeys = [];
    			for (i = 0; i < arg.length; ++i) {
    				childrenKeys.push(i);

// This is a AUTOMATICALLY GENERATED! Do not change!

    			}
    		} else {
    			var serObj:SerializableClass = 
    				AS3_vs_AS2.isSerializableClass(arg) ?
    					AS3_vs_AS2.asSerializableClass(arg) : null;
    			elementType = serObj==null ? 
    				RESERVED_NAMES.obj : serObj.__CLASS_NAME__;
    			childrenKeys = serObj!=null ? serObj.getFieldNames() : JSON.getSortedKeys(arg);
    			if (serObj!=null) childrenKeys.sort();	
    		}

// This is a AUTOMATICALLY GENERATED! Do not change!

    	}
    	StaticFunctions.assert(elementType!=null, ["Internal error! missing elementType"]);
    	
    	if (childrenKeys==null) {
    		var simpleContent:String = arg==null ? "" : escapeXML(arg.toString());
    		res.push(indentStr+
    			(simpleContent=="" ? "<"+elementType+"/>" :	    		
    			"<"+elementType+">" + simpleContent + "</"+elementType+">")+
    			"\n");
    	} else { 

// This is a AUTOMATICALLY GENERATED! Do not change!

    		res.push(indentStr+"<"+elementType+">\n");
    		for each (var childKey:String in childrenKeys) {
	    		var esc:String;
	    		if (!isArr) {
		    		esc = escapeXML(childKey);
			    	res.push(indentStr + "\t<"+esc+">\n");
			    }
		    	p_toString(indentStr+(isArr ? "\t" : "\t\t"),res, arg[childKey]);
		    	if (!isArr) 
		    		res.push(indentStr + "\t</"+esc+">\n");	    			

// This is a AUTOMATICALLY GENERATED! Do not change!

    		}
    		res.push(indentStr+"</"+elementType+">\n");
    	}	    		    	 	
    }

}
}
