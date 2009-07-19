// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_XMLSerializable.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

public class AS3_XMLSerializable extends AS3_NativeSerializable
{
public var xmlStr:String;
public function AS3_XMLSerializable(xml:XML=null) {
super("XML");
xmlStr = xml==null ? null : xml.toXMLString();
}
override public function fromNative(obj:Object):AS3_NativeSerializable {
return obj is XML ? new AS3_XMLSerializable(obj as XML) : null;
}

// This is a AUTOMATICALLY GENERATED! Do not change!

override public function postDeserialize():Object {
return AS3_vs_AS2.xml_create(xmlStr);
}

}
}
