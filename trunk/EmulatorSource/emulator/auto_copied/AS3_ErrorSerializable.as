// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_ErrorSerializable.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

public class AS3_ErrorSerializable extends AS3_NativeSerializable
{
public var stackTraces:String;
public var message:String;
public var errorId:int;
public function AS3_ErrorSerializable(err:Error=null) {
super("Error");
message = err==null ? null : err.message;
stackTraces = err==null ? null : err.getStackTrace();
errorId = err==null ? 0 : err.errorID;

// This is a AUTOMATICALLY GENERATED! Do not change!

}
override public function fromNative(obj:Object):AS3_NativeSerializable {
return obj is Error ? new AS3_ErrorSerializable(obj as Error) : null;
}
override public function postDeserialize():Object {
return new Error(message, errorId);
}
}
}
