/**
 * This is the Game API for the client side. 
 * Your class must extend Game and override the functions:
 *		getSavedData matchStarted matchEnded receivedBroadcast (and optionally receivedSetTurn)
 * The first line of action script code in you board.FLA must be: 
 * _root.registerClientAPI(TicTacToe, this);
 * In our example TicTacToe is the class that extends Game.
 *
 * The behaviour of the emulator:
 * We simulate a network delay of 100-500 milliseconds round trip time.
 * There are buttons for:
 *  1) Cancelling the match (causes the server to call matchEnded)
 *  2) Saving the match, but the match will continue going (causes the server to call getSavedData)
 *  3) Load the match (will start a new match with the saved data)
 *  4) Start a new match
 *
 * Do not change anything in this class.
 *
 * Written by: Dr. Yoav Zibin (yoav@come2play.com)
 */
class Game {
	public var API_VERSION = 4; // Updated on Sep 19, 2007

	// swfRoot is the root of the board swf
	// note that _root is not the same as swfRoot since we load the board swf into another movie clip, 
	// therefore you should not use _root ANYWHERE in your code.
	private var swfRoot:MovieClip; 	
	// An object that will transfer calls to the server. Only players can use server, viewers cannot send any requests to the server.
	private var server; 
	
	//myColor is null for users viewing the game, 0 for the white player, and 1 for the black.
	private var myColor:Number; 
	private var myName:String; // either: WhitePlayer, BlackPlayer, or Viewer

	private var matchStartedOn:Number; // you can use this number as a random seed - both players will have the same value in it
	
	// A small dynamic text (for the emulator only) to announce the winner and the current turn
	private var msgText:MovieClip;
	
	public function Game(server, myColor:Number, swfRoot:MovieClip) {
		if (server == null) return;
		assert("Game.new", swfRoot!=null, myColor);
		this.server = myColor==null ? null : server; // the viewer never calls anything on the server
		this.myColor = myColor;
		myName = myColor==0 ? "WhitePlayer" : myColor==1 ?  "BlackPlayer" : "Viewer";
		this.swfRoot = swfRoot;
		msgText = swfRoot._parent.WhoseTurnIsIt.msg; // only valid in the emulator
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////
	// Part 1: Functions that will send a message to the server
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	// Definition: serializable object
	// An object will be called serializable if it is either: Boolean, Number (only integers!), String, Object or Array, where
	//	each slot in the Object or Array must also be a serializable object.
	// In other words, the following are NOT serializable:
	//		a function, a movieclip, a button, a text field, or an object from a user defined class.
	// You can only broadcast serializable objects, and getSavedData can return only a serializable object.

	// We do not support **real** numbers because the conversion of a real number to string and back to a number is not accurate in flash, e.g.,
	// var num = 1.6189543082926e-319;
	// var str_num = ""+num;
	// var num_again = Number(str_num);
	// trace(num);
	// trace(str_num);
	// trace(num_again);
	// trace(num==num_again);
	// And the output is:
	// 1.6189543082926e-319
	// 1.6189543082926e-319
	// 1.61890490172801e-319
	// false

	// A player can send any number of arguments to sendBroadcast.
	// After the player calls sendBroadcast, the server will call receivedBroadcast for ALL participants
	public function sendBroadcast():Void {		
		server.sendBroadcast.apply(server, arguments);
	}

	// When the match ends, one of the players should call sendMatchEnded,
	// and the server will call matchEnded for ALL participants.
	// To detect hackers, when recieving matchEnded, one should check that the game indeed ended and winningColor is the winner.
	// @winningColor is either -1 for a tie, 0 if white won, and 1 if black won.
	// @whiteScore and @blackScore are the score of the white and black. 
	// @whiteTokenPercentage is a number between 0 and 100 that determines what percentage of the tokens (that both players bet on) 
	//  the white player will get. 
	//  If @whiteTokenPercentage=100 then the white will get the whole pot, and if @whiteTokenPercentage=0 the black will get the whole pot.
	//  We always round up the number of tokens in favor of the winner, and in case of a tie we round up in favor of the player who got fewer tokens.	
	public function sendMatchEnded(winningColor:Number, whiteScore:Number, blackScore:Number, whiteTokenPercentage:Number):Void {
		server.sendMatchEnded(winningColor, whiteScore, blackScore, whiteTokenPercentage);
	}

	// setTurn is used to limit the time per move or per match.
	// In the management console (CMS) you can set for your game two timers: time-per-move and time-per-match.
	// @turnNumber should be increased after each call (or pass -1), 
	// @currColor is either 0 if it is the white's turn, 1 for black, and -1 if it is no-one's turn.
	// @milliSeconds is the number of milliseconds @currColor will have to make its move 
	//   (if @milliSeconds==-1 then the value of time-per-move is used.)
	//
	// After the player calls setTurn(turnNumber,currColor,milliSeconds), the server checks if turnNumber
	//  is -1 or the biggest it has ever seen for this match, and if so it: 
	//	a) starts measuring the time for that currColor,
	//	b) calls setTurn for all participants.
	// If there is a time-per-move, and the time for that move has elapsed, then currColor lost the match.
	// If there is a time-per-match, and the total time for that color has elapsed, then currColor lost the match.
	public function setTurn(turnNumber:Number, currTurn:Number, milliSeconds:Number):Void {
		server.setTurn(turnNumber, currTurn, milliSeconds);
	}
	


	//////////////////////////////////////////////////////////////////////////////////////////////////////
	// Part 2: Functions to override (the server will call them)
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	// You should override the functions below (except setTurn which is optional).
	// The server can call the functions below at any point in time.
	// The server will always call the functions below for ALL participants of the game, 
	//	i.e., both the two players and any viewers.
	// Except for getSavedData, which may be called only for one of the two players.
	/**
	 * getSavedData should return an object describing the current state of the game. 
	 * Only serializable objects can be returned (see sendBroadcast).
	 * It can be called multiple times by the server, either for passing the current state of the game to a new viewer, 
	 *	or for saving the match in the database.
	 */
	public function getSavedData():Object {
		assert("You must override Game.getSavedData", false);
		return null;
	}
	/** 
	 * @savedGame is either null or an object describing a saved game returned by some call to getSavedData.
	 * A viewer joining the game in the middle will receive the current state of the game in the savedGame object.
	 */
	public function matchStarted(savedGame:Object):Void {
		assert("You must override Game.matchStarted", false);
	} 
	/**
	 * See: sendMatchEnded(winningColor:Number, whiteScore:Number, blackScore:Number, whiteTokenPercentage:Number):Void
	 * matchEnded is called by the server after some player called server.sendMatchEnded.
	 * It can also be called in the middle of the game if the players have decided to cancel, tie or save the match.
	 * @winningColor will be null if the match was cancelled, 0 if the white won, and 1 if the black won, and -1 for a tie
	 * @whiteScore and @blackScore are the score of the white and black, or null if the match was cancelled.
	 * @whiteTokenPercentage is the percentage of tokens the white player got from the betting pool.
	 * These are saved in the database in the table TBL_Matches columns white_match_price, black_match_price, and white_token_percentage,
	 *  and in TBL_PlayerMatches columns match_price and token_percentage.
	 * After calling matchEnded we also call:
	 *		setCurrentTurn(-1)
	 */
	public function matchEnded(winningColor:Number, whiteScore:Number, blackScore:Number, whiteTokenPercentage:Number):Void {
		assert("You must override Game.matchEnded", false);
	}
	/**
	 * See: sendBroadcast():Void
	 */
	public function receivedBroadcast(fromColor:Number):Void {
		assert("You must override Game.receivedBroadcast", false);
	}
	/**
	 * See: setTurn(turnNumber:Number, currColor:Number, milliSeconds:Number):Void
	 */
	public function receivedSetTurn(turnNumber:Number, currColor:Number, milliSeconds:Number):Void {
	}




	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	// Part 3: Helper functions (debugging and traces, assertions, etc)
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * Error handling using the functions assert and storeTrace:
	 * We developed a mecanism for detecting errors and sending them to our server.
	 * These errors in turn are sent to the recipients of the daily email (with the graphs and statistics).
	 * When an assertion fails we display a detailed error message with all arguments passed to assert 
	 *	and all the traces previously stored.
	 * For exmaple, to assert that a certain arg is equal to 42:
	 *	assert("Message to display", arg==42, arg);
	 * You can also view all the stored traces locally by pressing: CONTROL+ALT+LEFT+RIGHT
	 */
	public function assert(msg:String, val:Boolean):Void {
		if (!val) {
			var newMsg:String = "Assert failed in "+myName+":" + msg;
			var extraArgs = arguments.slice(2);
			storeTrace.apply(this, [newMsg, ','].concat(extraArgs));
			_root.assert.apply(null, [newMsg, false].concat(extraArgs) ); 
		}
	}
	/**
	 * Local debugging using printError and storeTrace:
	 * These functions should be used only in the beta version to detect errors locally (without sending them to the server).
	 * storeTrace uses both the native trace function and stores the traces in case you wish to view them later (by pressing CONTROL+ALT+LEFT+RIGHT),
	 * while printError displays a visible error window.
	 */
	public function storeTrace() {
		trace(myName+': '+arguments.join(''));
		_root.storeTrace(myName+': '+arguments.join(','));
	}
	public function printError() {
		trace(arguments.join(''));
		_root.printErrorMessage(myName+': '+arguments.join(''));
	}

	/**
	 * delegate is used to return a function object from a member function.
	 * You can also pass extra parameters to the function, for example, 
	 * upBtn.onPress = delegate(this.onPressBtn, 'up');
	 */
	public function delegate(handler:Function):Function {
		return _root.delegate.apply(null, [this].concat(arguments));
	}

	public function getAttr(movie, attrName:String) {
		var res = movie[attrName];
		assert("Game.getAttr", res!=null, movie, attrName);
		return res;
	}

	public function invokeOnceLater(func:Function, delayInMilliseconds:Number):Void {
		_root.invokeOnceLater(this, func, delayInMilliseconds);
	}



	// For announcing the result of the match
	public function setMsgText(msg:String):Void {
		msgText.text = msg;
	}
	
    public function nextInt(n:Number):Number {
		var res:Number = Math.floor( Math.random() * n );
		return res;
    }
    public function randomFromTo(from:Number, to:Number):Number {
		return from + nextInt(to-from);
	}	
}