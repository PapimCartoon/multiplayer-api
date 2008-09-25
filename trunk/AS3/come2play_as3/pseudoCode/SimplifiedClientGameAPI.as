package come2play_as3.pseudoCode
{
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.*;
	public class SimplifiedClientGameAPI extends ClientGameAPI {
	  internal var myUserId:int;
	  internal var allPlayerIds:Array/*int*/;
	  public var state:Array/*ServerEntry*/
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
	  override public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, serverEntries:Array/*ServerEntry*/):void {
	    this.allPlayerIds = allPlayerIds;
	    gotMatchStarted2();
	  }
	  override public function gotStateChanged(serverEntries:Array/*ServerEntry*/):void {
	  	// update state
	  	for each(var serverEntry:ServerEntry in serverEntries)
	  	{ 
	  		for(var i:int=0;i<state.length;i++)
	  		{
	  			if(serverEntry.key == serverEntries[i])
	  			{
	  				state.splice(i,1);
	  				break;
	  			}
	  		}
	  		if(serverEntry.value!=null)
	  			serverEntries.push(serverEntry);
	  	}
	  		
	  	gotStateChanged2(serverEntries);
	  }
	
	  // subclasses of ClientGameAPI may override these callbacks.
	  public function gotMatchStarted2():void {}
	  public function gotStateChanged2(serverEntries:Array/*ServerEntry*/):void {}
	  
		public static function checkEverythingCompiles():void {
			new PseudoBackgammon();
			new PseudoTicTacToe();
			new PseudoBattleships();
			new PseudoBattleships2();
			new PseudoTrivia();
			new PseudoDominoes();
			new PseudoBlackJack();
			new PseudoMineSweeper();
			// Ofir: you forgot to commit it!@!!! new PseudoSnake();
		} 
	} 
}





