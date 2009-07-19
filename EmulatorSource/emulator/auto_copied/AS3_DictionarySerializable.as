// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_DictionarySerializable.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

import flash.utils.Dictionary;

public class AS3_DictionarySerializable extends AS3_NativeSerializable
{
public var keyValArr:Array = [];
public function AS3_DictionarySerializable(dic:Dictionary=null) {
super("Dictionary");
if (dic!=null) {
for (var k:Object in dic)
keyValArr.push([k, dic[k]]);

// This is a AUTOMATICALLY GENERATED! Do not change!

}
}
override public function fromNative(obj:Object):AS3_NativeSerializable {
return obj is Dictionary ? new AS3_DictionarySerializable(obj as Dictionary) : null;
}
override public function postDeserialize():Object {
var res:Dictionary = new Dictionary();
for each (var keyVal:Array in keyValArr)
res[ keyVal[0] ] = keyVal[1];
return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

}
}
}
