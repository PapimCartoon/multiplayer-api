package come2play_as3.pseudoCode
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.*;
	import come2play_as3.pseudoCode.backgammon.PseudoBackgammon;
	import come2play_as3.pseudoCode.battleShips.PseudoBattleships;
	import come2play_as3.pseudoCode.domino.PseudoDominoes;
	import come2play_as3.pseudoCode.mineSweeper.PseudoMineSweeper;
	import come2play_as3.pseudoCode.tictactoe.PseudoTicTacToe;
	import come2play_as3.pseudoCode.trivia.PseudoTrivia;
	
	import flash.display.*;
	public class SimplifiedClientGameAPI extends ClientGameAPI {
	  protected var myUserId:int;
	  protected var allPlayerIds:Array/*int*/;
	  public var state:Array/*ServerEntry*/
	  public function SimplifiedClientGameAPI()
	  {
	  	super(new MovieClip());
	  }
	  public function require(condition:Boolean):void {
	    if (!condition) throw new Error("SimplifiedClientGameAPI.require failed");
	  }

	  override public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, serverEntries:Array/*ServerEntry*/):void {
	    this.allPlayerIds = allPlayerIds;
	    gotMatchStarted2();
	  }
	  override public function gotCustomInfo(infoEntries:Array):void
	  {
	  	myUserId = T.custom(CUSTOM_INFO_KEY_myUserId, null) as int;
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
			new PseudoTrivia();
			new PseudoDominoes();
			new PseudoMineSweeper();
			// Ofir: you forgot to commit it!@!!! new PseudoSnake();
		} 
	} 
}





