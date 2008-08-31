package come2play_as3.domino
{
	import come2play_as3.api.auto_generated.*;

	
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	
	public class Domino_Main extends ClientGameAPI
{

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

		}
		override public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void 
		{
			
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			var serverEntry:ServerEntry = serverEntries[0]
				
		}
		override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void
		{
		}
	}
}