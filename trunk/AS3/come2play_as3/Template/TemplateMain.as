package come2play_as3.Template
{
	import AS3.come2play_as3.Template.TemplateCalculatorLogic;
	import AS3.come2play_as3.Template.TemplateLogic;
	
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.MovieClip;
	/**
	 * your main class should extend ClientGameAPI,in case you want your main class to extend another class,
	 * as in the case of a document class extending MovieClip.
	 * ClientGameAPI does not extend any class and you can extend it with any class you want. 
	 * this extension will be passed down by inheritance to your main class
	 */
	public class TemplateMain extends ClientGameAPI
	{
		private var templateLogic:TemplateLogic;
		private var graphics:MovieClip;
		public function TemplateMain(graphics:MovieClip)
		{
			/*
			Your main game constructor should be empty besides the foloowing lines of code
			*/
			this.graphics = graphics;
			super(graphics); //sends the stage to the ClientGameAPI
			
			AS3_vs_AS2.waitForStage(graphics,constructGame);
			/*
			The function above should call your constructor,to avoid a case where the stage is not loaded	
			*/
			
		}
		private function constructGame():void
		{
			templateLogic = new TemplateLogic(this);
			doRegisterOnServer();// registers user on server should be the first command called
		}
		
		override public function gotCustomInfo(infoEntries:Array):void
		{
			/*
			This function gets info which is used to customize your game.
			such as:
			logo
			seconds per turn
			size of board
			etc...
			*/
		}
		override public function gotMyUserId(myUserId:int):void
		{
			/*
			Called after connecting to the server
			and passes the user id
			*/
		}
		override public function gotUserInfo(userId:int, infoEntries:Array):void
		{
			/*
			Used to pass specific info about each user playing the game.
			called for each of the playing users
			*/
		}
		override public function gotRequestStateCalculation(serverEntries:Array):void
		{
			/*
			Called after a doAllRequestStateCalculation(keys)
			serverEntries - an Array of ServerEntry containing,server entries the users choose to show the calculator.
			*/
			
			

			var templateCalculatorLogic:TemplateCalculatorLogic = new TemplateCalculatorLogic(serverEntries)
			/*
			You should create a separate class for the calculator calculations
			to avoid confusing varibles,and to make sure you send only what is needed
			you should always remember that the calculators did not get the custom info your users got.
			*/
			
			
			var userEntries:Array/*UserEntry*/templateCalculatorLogic.getUserEntries()
			/*
			After making the game calculations, get the relevant information from your 
			"TemplateCalculatorLogic" class via a special function.
			*/
			
			doAllStoreStateCalculation(userEntries);
			
			/*
			After getting the userEntries store them in the serverstate
			*/
			
			
		}
		override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void
		{
			/*
			Your game is extended among other things,by a chat, to make sure that the keyboard user input you are
			getting is intended for your game,you should only use this function to get keyboard events 
			*/
		}
		override public function gotMatchEnded(finishedPlayerIds:Array):void
		{
			/*
			Called when one or all users have finished the game
			contains the ids of the finishing players
			*/
		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, extraMatchInfo:Object, matchStartedTime:int, serverEntries:Array):void
		{
			/*
			Called when all players made a doRegisterOnServer() call contains:
			allPlayerIds - array of all player ids
			extraMatchInfo - object containing extra match info
			matchStartedTime - the time at which the game has started
			serverEntries - in case of a saved game or a viewer connecting,this will contain the entire game state
			finishedPlayerIds - in case of a saved game or a viewer connecting,the ids of the players that finished the game
			*/
			
			
			//After the match starts,you might want to use one of the following calls
			
			
			doAllEndMatch(finishedPlayers:Array/*PlayerMatchOver*/);
			/*
			Has to be called by all the game players with the exact same parameters 
			when a player finished the game, contains the finishing players pot percentage and score.
			triggers a gotMatchEnded call on all the other game clients
			*/
			
			
			doAllFoundHacker(userId:int,errorDescription:String);
			/*
			Called when a user suspects another user is a hacker,and is trying to cheat
			should be called when an unexpected ServerEntry arrives,or whenever one of
			the other game clients doesn’t follow the rules.
			called with:
			userId - the suspected hacker id
			errorDescription - the error he caused
			*/
			
			
			doAllRequestRandomState(key:Object,isSecret:Boolean);
			/*
			Has to be called by all the game players  with the exact same parameters 
			when the players  want to get a random value.
			key - the key the ServerEntry will have
			isSecret - will the serverEntry be a secret one
			the random value will be returned via gotStateChanged
			*/
			
			
			doAllRevealState(revealEntries:Array/*RevealEntry*/);
			/*
			Has to be called by all the game players with the exact same parameters
			when the players want to reveal a secret state entry to one or all players
			revealEntries- an Array of RevealEntry to reveal via got gotStateChanged
			*/
			
			
			doAllSetTurn(userId:int,miliSecondsInTurn:int);
			/*
			Has to be called by all the game players with the exact same parameters
			used to force one or all player to play
			used to prevent stagnation, where one of the users cheats by not playing
			userId - the user id of the player which needs to play, -1 for all players
			miliSecondsInTurn - the time the paler/s has/have to play
			*/
			
			
			doAllShuffleState(keys:Array/*Object*/);
			/*
			Has to be called by all the game players with the exact same parameters
			shuffles all the server entries corresponding to the keys in the array
			and makes them secret
			keys - an Array of keys to be shuffled  on the server
			*/
			
			
			doAllStoreState(userEntries:Array/*UserEntry*/);
			/*
			Stores/changes/deletes any data needed on the server state
			userEntries - an array of userEntry which will change/make/delete 
			server entries in the game state
			*/
			
			doAllStoreStateCalculation(userEntries:Array/*UserEntry*/)
			/*
			Has to be called by all the game players with the exact same parameters
			stores/changes/deletes any data needed on the server state
			userEntries - an array of userEntry which will change/make/delete 
			server entries in the game state
			*/
			
			doAllRequestStateCalculation(keys:Array/*Object*/);
			/*
			Has to be called by all the game players with the exact same parameters
			sends all the server entries corresponding to the keys in the array,to a calculator					
			*/			
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			/*
			Called whenever something changes the game state,with the newly created/changed/deleted ServerEntry
			serverEntries - an array of ServerEntry Objects changed.
			*/
		}

	}
}