// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/Profiler.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

import flash.utils.Dictionary;
import flash.utils.getTimer;
public final class Profiler
{
public static function measure(name:String, func:Function, args:Array):Object {
started(name);
var res:Object = func.apply(null,args); // I don't care about exceptions: I'll just trim the stack
ended(name);
return res;
}

// This is a AUTOMATICALLY GENERATED! Do not change!

public static function started(name:String):void {
var now:int = getTimer();
if (MAIN_LOG==null) init(now);
var len:int = stack.length;
if (len>0) {
// update self time
var entry:StackEntry = stack[len-1];
entry.selfTotal = now - entry.selfStarted;
} else {
ALL_STAT.cumulativeTime.add(now-CODE_FINISHED_ON);

// This is a AUTOMATICALLY GENERATED! Do not change!

}
var newEntry:StackEntry = new StackEntry(now,name);
stack.push(newEntry);
}
public static function ended(name:String):void {
// if there is an exception, then the top of the stack is not "name"
var top:StackEntry;
do {
if (stack.length==0) {
ERR_LOG.log("stack became empty when called 'ended' with name=",name);

// This is a AUTOMATICALLY GENERATED! Do not change!

return;
}
top = stack.pop();
if (top.name==name) break;
ERR_LOG.log("The top of stack is ",top.name," when called 'ended' with name=",name);
} while (true);

// finished with top
var now:int = getTimer();
var self:int = top.selfTotal + (now - top.selfStarted);

// This is a AUTOMATICALLY GENERATED! Do not change!

var cumulative:int = now - top.cumulativeStarted;
var stat:StatEntry = getStat(name);
stat.selfTime.add(self);
stat.cumulativeTime.add(cumulative);
if (stack.length>0) {
var prevEntry:StackEntry = stack[stack.length-1];
prevEntry.selfStarted = now;
} else {
ALL_STAT.selfTime.add(cumulative);
CODE_FINISHED_ON = now;

// This is a AUTOMATICALLY GENERATED! Do not change!

}
}

private static var ERR_LOG:Logger = new Logger("ProfilerErrors",10);
private static var stats:Dictionary/*String->StatEntry*/ = new Dictionary();
private static var stack:Array/*Entry*/ = [];
private static function getStat(name:String):StatEntry {
var res:StatEntry = stats[name];
if (res==null) {
res = new StatEntry(name);

// This is a AUTOMATICALLY GENERATED! Do not change!

stats[name] = res;
}
return res;
}


private static var MAIN_LOG:Logger;
// to gather stats comparing render time vs code time (adding an artificial StackEntry won't help cause we never call 'ended' for it)
private static var ALL_STAT:StatEntry;
private static var CODE_FINISHED_ON:int;

// This is a AUTOMATICALLY GENERATED! Do not change!

public static var BUCKET_SIZE:int = 50;
public static var BUCKET_NUM:int = 5;
public static function createStatGather():StatGather {
return new StatGather(BUCKET_SIZE,BUCKET_NUM);
}

private static function init(now:int):void {
CODE_FINISHED_ON = now;
ALL_STAT = getStat("ALL (special)");
MAIN_LOG = new Logger("ProfilerEntries",2);

// This is a AUTOMATICALLY GENERATED! Do not change!

MAIN_LOG.hugeLog(new Profiler());
}
public static var SHOW_TOP_X:int = 50;
public static var NAME_LEN:int = 60;
public static var DATA_LEN:int = 9; // 1 hour = 3,600,000
public function toString():String {
var allStats:Array = [];
var e:StatEntry;
for each (e in stats) {
allStats.push({sortBy: e.selfTime.getSum(), e: e});

// This is a AUTOMATICALLY GENERATED! Do not change!

}
allStats.sortOn("sortBy", Array.DESCENDING | Array.NUMERIC);
var res:Array = [
"\n"+
StaticFunctions.suffixSpaces("",NAME_LEN)];
addData(res,""); // count
addData(res,"| self ");//sum
addData(res,"time");//avg
addData(res,"");//max
addData(res,"   | ");//min

// This is a AUTOMATICALLY GENERATED! Do not change!

addData(res,"| cumulative ");//sum
addData(res,"time");//avg
addData(res,"");//max
addData(res," | Buckets of 100 milliseconds\n");
res.push(StaticFunctions.suffixSpaces("name",NAME_LEN));
addData(res,"count");
addData(res,"|sum");
addData(res,"avg");
addData(res,"max");
addData(res,"min|");

// This is a AUTOMATICALLY GENERATED! Do not change!

addData(res,"|sum");
addData(res,"avg");
addData(res,"max");
addData(res,"min|");
res.push("selfBuckets\t\t\t");
res.push("cumulativeBuckets");
res.push("\n");
res.push("ALL (sepcial) uses 'self time' for the CODE time, and 'cumulative time' for the GRAPHICS rendering (and quite) time\n");
for each (var o:Object in allStats) {
e = o.e;

// This is a AUTOMATICALLY GENERATED! Do not change!

var self:StatGather = e.selfTime;
var cum:StatGather = e.cumulativeTime;
res.push(StaticFunctions.suffixSpaces(e.name,NAME_LEN));
addData(res,""+self.getCount());
addData(res,""+self.getSum());
addData(res,""+self.getAvgStr());
addData(res,""+self.getMax());
addData(res,""+self.getMin());
addData(res,""+cum.getSum());
addData(res,""+cum.getAvgStr());

// This is a AUTOMATICALLY GENERATED! Do not change!

addData(res,""+cum.getMax());
addData(res,""+cum.getMin());
res.push(self.getBuckets()); res.push("\t");
res.push(cum.getBuckets()); res.push("\n");
}
return res.join("");
}
private static function addData(res:Array,data:String):void {
res.push(StaticFunctions.suffixSpaces(data,DATA_LEN));
}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
}

import emulator.auto_copied.StatGather;
import emulator.auto_copied.Profiler;
class StatEntry {
public var name:String;
// 100 milliseconds per bucket, with 5 buckets
public var selfTime:StatGather = Profiler.createStatGather();
public var cumulativeTime:StatGather = Profiler.createStatGather();

// This is a AUTOMATICALLY GENERATED! Do not change!


public function StatEntry(name:String) {
this.name = name;
}
}
class StackEntry {
public var name:String;
public var cumulativeStarted:int;
public var selfStarted:int;
public var selfTotal:int = 0;

// This is a AUTOMATICALLY GENERATED! Do not change!


public function StackEntry(now:int, name:String) {
this.name = name;
cumulativeStarted = now;
selfStarted = now;
}
}
