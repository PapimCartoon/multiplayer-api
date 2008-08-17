package come2play_as3.pseudoCode
{
	import come2play_as3.api.ClientGameAPI;
	
	import flash.display.*;
	public class SimplifiedClientGameAPI extends ClientGameAPI {
	  internal var myUserId:int;
	  internal var allPlayerIds:Array/*int*/;
	  public function SimplifiedClientGameAPI()
	  {
	  	super(new MovieClip());
	  }
	  public function require(condition:Boolean):void {
	    if (!condition) throw new Error();
	  }
	  override public function gotMyUserId(myUserId:int):void {
	    this.myUserId = myUserId;
	  }
	  override public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object/*Serializable*/, matchStartedTime:int, serverEntries:Array/*ServerEntry*/):void {
	    this.allPlayerIds = allPlayerIds;
	    gotMatchStarted2();
	  }
	
	
	  // subclasses of ClientGameAPI may override these callbacks.
	  public function gotMatchStarted2():void {}
	  
		public static function checkEverythingCompiles():void {
			new PseduBackgammon();
			new PseduTicTacToe();
			new PseduBattleships();
			new PseduTrivia();
			new PseduDominoes();
		} 
	} 
}





