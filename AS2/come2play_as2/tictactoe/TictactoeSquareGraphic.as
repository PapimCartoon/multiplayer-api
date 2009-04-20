import come2play_as2.api.*;
import come2play_as2.api.auto_copied.*;


import come2play_as2.tictactoe.*;
class come2play_as2.tictactoe.TictactoeSquareGraphic
{
	private static var LOG:Logger = new Logger("TictactoeSquareGraphic",10);
	
	public static var BTN_NONE:Number = -2; 
	public static var MAX_SYMBOLS:Number = 4; 	
	
	private var graphic:TictactoeMain;
	private var soundMovieClip:MovieClip;
	private var buttonContainer:MovieClip;
	
	// symbolsContainer will contain a child for each symbol (0 .. MAX_SYMBOLS-1)
	private var symbolsContainer:MovieClip;	
	private var allSymbols:Array/*DisplayObject*/; // symbolsContainer contains an array of symbols
	private var allSymbolGraphics:Array/*DisplayObject*/; // each symbol contains a single child that is the graphics of the symbol
	private var currentTurnForMouseOver:Number = BTN_NONE - 1; // so we will make the first assignment (to show the logo) 

	private var move:TictactoeSquare;
	private var logoContainer:MovieClip;
		
	public function TictactoeSquareGraphic(graphic:TictactoeMain, square:MovieClip, move:TictactoeSquare) {
    	this.animationStartedOn = new TimeMeasure();
		this.graphic = graphic;
		this.buttonContainer = AS3_vs_AS2.getMovieChild(square,"buttonContainer");
		this.logoContainer = AS3_vs_AS2.getMovieChild(square,"logoContainer");
		this.symbolsContainer = AS3_vs_AS2.getMovieChild(square,"symbolsContainer");
		this.soundMovieClip = AS3_vs_AS2.getMovieChild(square,"soundMovieClip");
		// for some reason (CRAZY flash!) all the inner movieclips start playing immediately (important for the sound, and the button-container shows the mouse cursor as a hand)
		buttonContainer.stop();
		soundMovieClip.stop(); 
				
		this.move = move;
			
		allSymbols = [];
		allSymbolGraphics = [];
		for (var i:Number=0; i<MAX_SYMBOLS; i++) {
			
			var newSymbol:MovieClip = AS3_vs_AS2.createEmptyMovieClip(symbolsContainer,"symbol"+i);
			AS3_vs_AS2.setVisible(newSymbol,false);
			allSymbols[i] = newSymbol;
			var symbolGraphics:MovieClip = AS3_vs_AS2.createMovieInstance(newSymbol,"Symbol_"+i,"symbolGraphics");
			addSymbol(i, symbolGraphics);
		}
					
		showOrHideLogo(false);
	}
	private function setButtonListeners(isActive:Boolean):Void {	
		buttonContainer.gotoAndStop(isActive ? "WithBtn" : "NoBtn");
		// In AS2 we put onPress on the inner button, and in AS3 on the buttonContainer (because we need to remove those mouse-event-listeners
		if (AS3_vs_AS2.isAS3 || isActive) {	
			var btn:MovieClip = AS3_vs_AS2.isAS3 ? buttonContainer : AS3_vs_AS2.getChild(buttonContainer,"btn");	
			AS3_vs_AS2.addOnPress(btn,	AS3_vs_AS2.delegate(this, this.pressedOn), isActive);
			AS3_vs_AS2.addOnMouseOver(btn,	AS3_vs_AS2.delegate(this, this.mouseOver),	AS3_vs_AS2.delegate(this, this.mouseOut), isActive);
		}
	}
	private function addSymbol(color:Number, newSymbol:MovieClip):Void {
		allSymbolGraphics[color] = newSymbol;
	} 
	public function gotSymbol(color:Number, symbolUrl:String):Void {
		
		if (color<0 || color>=MAX_SYMBOLS) throw new Error("Illegal color="+color+" MAX_SYMBOLS="+MAX_SYMBOLS);
		var thisObj:TictactoeSquareGraphic = this; // for AS2
		var newSymbol:MovieClip =
			AS3_vs_AS2.loadMovieIntoNewChild(allSymbols[color], symbolUrl,
				function(isSuccess:Boolean, newChild:MovieClip):Void { 
					if (isSuccess) {
						AS3_vs_AS2.removeMovie(thisObj.allSymbolGraphics[color]);
						AS3_vs_AS2.createMovieInstance(newSymbol,"SmallSymbol_"+color,"symbolGraphics");
						thisObj.addSymbol(color, newSymbol);
					} 
				} );		
	}
	public function gotLogo(logo:String):Void {
		AS3_vs_AS2.loadMovieIntoNewChild(logoContainer, logo, null);		
	}	
    private function showOrHideLogo(shouldAdd:Boolean):Void {
    	AS3_vs_AS2.setVisible(logoContainer,shouldAdd);
    }
    

	// the winning animation changes the visibility of the square
	// when winCounter=0 it disappears, otherwise it appears, and it counts till WIN_ANIMATION_COUNT   
    public static var WIN_ANIMATION_INTERVAL_MILLI:Number = 100;
    public static var WIN_ANIMATION_COUNT:Number = 10;//you appear 5 times more than disappear
    private var winAnimationInterval:MyInterval = null;
    private var winCounter:Number = 0;
    public function startWinAnimation():Void {
    	clearWinAnimation();
    	winCounter = 0;
    	winAnimationStep();
    	winAnimationInterval = new MyInterval("TictactoeSquareGraphic.winAnimationStep");
    	winAnimationInterval.start(AS3_vs_AS2.delegate(this, this.winAnimationStep), WIN_ANIMATION_INTERVAL_MILLI);    	    	
    }
    private function winAnimationStep():Void {
    	setVisible(winCounter!=0);
    	winCounter = (winCounter+1) % WIN_ANIMATION_COUNT;
    }
    public function clearWinAnimation():Void {
    	if (winAnimationInterval==null) return;
    	winAnimationInterval.clear();
    	winAnimationInterval = null;
		setVisible(true);    	
    }
        
    // the move animation changes the alpha from 0% to 100%, in steps of MOVE_ANIMATION_ALPHA_DELTA    
    public static var MOVE_ANIMATION_INTERVAL_MILLI:Number = 50;
    public static var MOVE_ANIMATION_ALPHA_DELTA:Number = 20;
    public static var TRACE_ANIMATION_STEPS:Boolean = false;
    private var alphaPercentage:Number;
    private var moveAnimationInterval:MyInterval = null;
    private var animationStartedOn:TimeMeasure = null;
    public function startMoveAnimation():Void {
    	StaticFunctions.assert(moveAnimationInterval==null, "TictactoeSquareGraphic is already in animation mode!",[" sqaure=", move]);
		graphic.animationStarted("startMoveAnimation");
		soundMovieClip.gotoAndPlay("MakeSound");
		
		alphaPercentage = 0;
		animationStartedOn.setTime();
    	moveAnimationInterval = new MyInterval("TictactoeSquareGraphic.moveAnimationStep");
    	moveAnimationInterval.start(AS3_vs_AS2.delegate(this, this.moveAnimationStep), MOVE_ANIMATION_INTERVAL_MILLI);    	
		moveAnimationStep();		
    }
    private function moveAnimationStep():Void {
    	LOG.log(["moveAnimationStep: alphaPercentage=",alphaPercentage]);
    	var didTimePassed:Boolean = false;
    	if (alphaPercentage>=100 ||
    		// after 1 second I end the animation (if the flash is overloaded) 
    		(didTimePassed = animationStartedOn.havePassed(1000))) {
    		if (didTimePassed) LOG.log(["animationStartedOn=",animationStartedOn]);
    		animationStartedOn.clearTime();
			alphaPercentage = 100;
    		StaticFunctions.assert(moveAnimationInterval!=null, "TictactoeSquareGraphic is not in a move animation!",["sqaure=", move]);
    		moveAnimationInterval.clear();
			moveAnimationInterval = null;			
			graphic.moveAnimationEnded(move,false);    
			graphic.animationEnded("startMoveAnimation");	// must be after we call all the doAll functions (and in startMove we have doAllSetTurn)			
		}   		
		setAlpha(alphaPercentage);
		alphaPercentage += MOVE_ANIMATION_ALPHA_DELTA;
    }
    private function setAlpha(alpha:Number):Void {
		AS3_vs_AS2.setAlpha(symbolsContainer, alpha);    	
    }
    private function setVisible(isVisible:Boolean):Void {
		AS3_vs_AS2.setVisible(symbolsContainer, isVisible);    	
    }
    
	public function setColor(color:Number):Void {	
		LOG.log(["Changing square ",move," to setColor=",color]);
		currentTurnForMouseOver = BTN_NONE;
		AS3_vs_AS2.setAlpha(symbolsContainer, 100);
		setSymbol(color);
		setButtonListeners(false);	
		showOrHideLogo(false);
	}
	public static var BUTTON_SYMBOL_ALPHA:Number = 40;
	public function startMove(currentTurn:Number):Void {
		LOG.log(["Changing square ",move," to startMove=",currentTurn]);
		AS3_vs_AS2.setAlpha(symbolsContainer, BUTTON_SYMBOL_ALPHA);
		currentTurnForMouseOver = currentTurn;
		setSymbol(BTN_NONE);
		
		setButtonListeners(currentTurn!=BTN_NONE);
		if (currentTurn!=BTN_NONE) {
			if (currentTurn<0) throw Error("Internal error!");
			showOrHideLogo(false);
		} else {		
			showOrHideLogo(true);	
		}
	}
	private function setSymbol(color:Number):Void {
		for (var i:Number=0; i<MAX_SYMBOLS; i++)
			AS3_vs_AS2.setVisible(allSymbols[i], i==color);
	}
	private function pressedOn(/*event:MouseEvent*/):Void  {
		graphic.userMadeHisMove(move);		
	}
	private function mouseOver(/*event:MouseEvent*/):Void  {	
		if (currentTurnForMouseOver!=BTN_NONE)
			setSymbol(currentTurnForMouseOver);
	}
	private function mouseOut(/*event:MouseEvent*/):Void  {
		if (currentTurnForMouseOver!=BTN_NONE)
			setSymbol(BTN_NONE);
	}
	
}
