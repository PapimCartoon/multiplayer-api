// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/LoggerLine.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

import flash.utils.getTimer;

public final class LoggerLine
{
private static var CURR_TRACE_ID:int = 0;
public static var LINE_INDENT:int = 0;

public var maxLen:int;
public var traceId:int;
public var traceTime:int;

// This is a AUTOMATICALLY GENERATED! Do not change!

public var loggerName:String;
public var obj:Object;
public var indent:int;

public function LoggerLine(maxLen:int, loggerName:String,obj:Object) {
traceId = ++CURR_TRACE_ID;
traceTime = getTimer();
indent = LINE_INDENT;
this.maxLen = maxLen;
this.loggerName = loggerName;

// This is a AUTOMATICALLY GENERATED! Do not change!

this.obj = obj;
}
}
}
