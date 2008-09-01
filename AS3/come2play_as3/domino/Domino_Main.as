package come2play_as3.domino
{
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	
	public class Domino_Main extends ClientGameAPI
	{
		private static var cubeMaxValue:int = 6;
		
		private var domino_Logic:Domino_Logic;
		private var myUserId:int; //my user id
		private var users:Array; // information about all users
		private var players:Array; //playing user ids
	/** 
	 * Written by: Ofir Vainshtein (ofirvins@yahoo.com)
 	**/
		public function Domino_Main(graphics:MovieClip)
		{ 
			super(graphics); 
			users = new Array(); 
			domino_Logic  = new Domino_Logic(this,graphics);
			setTimeout(doRegisterOnServer,100);
		}

		//override functions
		
		override public function gotCustomInfo(infoEntries:Array):void
		{
				
		}
		override public function gotMyUserId(myUserId:int):void
		{
			this.myUserId = myUserId;
		}
		override public function gotUserInfo(userId:int, entries:Array/*InfoEntry*/):void 
		{
			users.push({userId:userId,entries:entries});
		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, extraMatchInfo:Object, matchStartedTime:int, serverEntries:Array):void
		{
			players=allPlayerIds;
			doAllStoreState(domino_Logic.getCubesArray(cubeMaxValue));
			doAllShuffleState(domino_Logic.getDominoKeysArray());
			doAllRevealState(domino_Logic.getFirstDevision(players,myUserId));
		}
		override public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void 
		{
			
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			var serverEntry:ServerEntry = serverEntries[0]
			if(serverEntries.length == (players.length * 7 +1))
			{
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+"tried to fake a board");
				for each(serverEntry in serverEntries)
				{
					if (serverEntry.value is DominoCube)
					{
						if(serverEntry.authorizedUserIds != null)
							domino_Logic.addDominoCube(serverEntry.value as DominoCube,serverEntry.key);
						else
							domino_Logic.addDominoMiddle(serverEntry.value as DominoCube,serverEntry.key);
					}
				}
				domino_Logic.makeBoard();
				doAllSetTurn(players[0],-1);
				if(myUserId == players[0])
				{
					domino_Logic.allowTurn();
				}
			}
				
		}
		override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void
		{
			
		}
	}
}