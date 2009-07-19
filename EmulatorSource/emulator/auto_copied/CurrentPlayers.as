// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/CurrentPlayers.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

import emulator.auto_generated.API_GotMatchEnded;
import emulator.auto_generated.API_GotMatchStarted;
import emulator.auto_generated.API_Message;

public final class CurrentPlayers
{
// null means the game is not in progress
private var allPlayerIds:Array/*int*/;
private var currentPlayerIds:Array/*int*/;
// Note that we may have currentPlayerIds.length==0, but the game is still in progress

// This is a AUTOMATICALLY GENERATED! Do not change!

// E.g., when a game finishes, and we go back a move, then I pass:
// $API_GotMatchStarted$ "allPlayerIds":[42,41] , "finishedPlayerIds":[42,41]
// because a game might assume that for every GotMatchStarted it will get GotMatchEnded.

public function toString():String {
return "allPlayerIds="+allPlayerIds+" currentPlayerIds"+currentPlayerIds;
}
public function isInProgress():Boolean {
return currentPlayerIds!=null;
}

// This is a AUTOMATICALLY GENERATED! Do not change!

public function getCurrentPlayerIds():Array/*int*/ {
return currentPlayerIds;
}
public function getAllPlayerIds():Array/*int*/ {
return allPlayerIds;
}
public function getFinishedPlayerIds():Array/*int*/ {
if (currentPlayerIds==null) return null;
return StaticFunctions.subtractArray(allPlayerIds, currentPlayerIds);
}

// This is a AUTOMATICALLY GENERATED! Do not change!

public function isInPlayers(playerId:int):Boolean {
return AS3_vs_AS2.IndexOf(currentPlayerIds, playerId)!=-1;
}
public function isAllInPlayers(playerIds:Array/*int*/):Boolean {
StaticFunctions.assert(currentPlayerIds!=null, "playerIds used in a DoAll command are no longer playing - the match has already ended! playerIds=",playerIds);
StaticFunctions.assert(playerIds.length>=1, "used an empty array of playerIds in a DoAll command.");
for each (var playerId:int in playerIds) {
if (!isInPlayers(playerId)) return false;
}
return true;

// This is a AUTOMATICALLY GENERATED! Do not change!

}
public function assertInProgress(inProgress:Boolean, msg:API_Message):void {
StaticFunctions.assert(inProgress == isInProgress(), "assertInProgress",["The game must ",inProgress?"" : "not"," be in progress when passing msg=",msg]);
}
public function finishedPlayerIds(finishedPlayerIds:Array/*int*/):void {
currentPlayerIds = StaticFunctions.subtractArray(currentPlayerIds, finishedPlayerIds);
if (currentPlayerIds.length==0) {
currentPlayerIds = null;
allPlayerIds = null;
}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
public function gotMessage(gotMsg:API_Message):void {
if (gotMsg is API_GotMatchStarted) {
assertInProgress(false,gotMsg);
var matchStarted:API_GotMatchStarted = /*as*/gotMsg as API_GotMatchStarted;
allPlayerIds = matchStarted.allPlayerIds.concat();
currentPlayerIds = StaticFunctions.subtractArray(matchStarted.allPlayerIds, matchStarted.finishedPlayerIds);
} else if (gotMsg is API_GotMatchEnded) {
assertInProgress(true,gotMsg);
var matchEnded:API_GotMatchEnded = /*as*/gotMsg as API_GotMatchEnded;

// This is a AUTOMATICALLY GENERATED! Do not change!

finishedPlayerIds(matchEnded.finishedPlayerIds);
}
}


}
}
