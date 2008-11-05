package come2play_as3.tictactoe
{
import come2play_as3.api.*;
import come2play_as3.api.auto_copied.*;

import flash.display.*;
import flash.events.*;
import flash.utils.clearInterval;
import flash.utils.setInterval;

public final class TictactoeSquareGraphic
{
	public static const BTN_NONE:int = -2; 
	public static const MAX_SYMBOLS:int = 4; 	
	
	private var graphic:TictactoeMain;
	private var soundMovieClip:MovieClip;
	private var buttonContainer:MovieClip;
	
	// symbolsContainer will contain a child for each symbol (0 .. MAX_SYMBOLS-1)
	private var symbolsContainer:MovieClip;	
	private var allSymbols:Array/*DisplayObject*/;
	private var currentTurnForMouseOver:int = BTN_NONE - 1; // so we will make the first assignment (to show the logo) 

	private var move:TictactoeSquare;
	private var logoContainer:MovieClip;
		
	public function TictactoeSquareGraphic(graphic:TictactoeMain, square:MovieClip, move:TictactoeSquare) {
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
		for (var i:int=0; i<MAX_SYMBOLS; i++) {
			var newSymbol:MovieClip = AS3_vs_AS2.createMovieInstance(symbolsContainer,"Symbol_"+i,"symbol"+i);
			addSymbol(i, newSymbol);
		}
					
		showOrHideLogo(false);
	}
	private function setButtonListeners(isActive:Boolean):void {	
		buttonContainer.gotoAndStop(isActive ? "WithBtn" : "NoBtn");
		// In AS2 we put onPress on the inner button, and in AS3 on the buttonContainer (because we need to remove those mouse-event-listeners
		if (AS3_vs_AS2.isAS3 || isActive) {	
			var btn:DisplayObject = AS3_vs_AS2.isAS3 ? buttonContainer : AS3_vs_AS2.getChild(buttonContainer,"btn");	
			AS3_vs_AS2.addOnPress(btn,	AS3_vs_AS2.delegate(this, this.pressedOn), isActive);
			AS3_vs_AS2.addOnMouseOver(btn,	AS3_vs_AS2.delegate(this, this.mouseOver),	AS3_vs_AS2.delegate(this, this.mouseOut), isActive);
		}
	}
	private function addSymbol(color:int, newSymbol:DisplayObject):void {
		AS3_vs_AS2.setVisible(newSymbol,false);
		allSymbols[color] = newSymbol;
	} 
	public function gotSymbol(color:int, symbolUrl:String):void {
		if (color<0 || color>=MAX_SYMBOLS) throw new Error("Illegal color="+color);
		AS3_vs_AS2.removeMovie(allSymbols[color]);
		var thisObj:TictactoeSquareGraphic = this; // for AS2
		var newSymbol:DisplayObject =
			AS3_vs_AS2.loadMovieIntoNewChild(symbolsContainer, symbolUrl,
				function(isSuccess:Boolean):void { 
					if (isSuccess) thisObj.addSymbol(color, newSymbol); 
				} );		
	}
	public function gotLogo(logo:String):void {
		AS3_vs_AS2.loadMovieIntoNewChild(logoContainer, logo, null);		
	}	
    private function showOrHideLogo(shouldAdd:Boolean):void {
    	AS3_vs_AS2.setVisible(logoContainer,shouldAdd);
    }
    

	// the winning animation changes the visibility of the square
	// when winCounter=0 it disappears, otherwise it appears, and it counts till WIN_ANIMATION_COUNT   
    public static var WIN_ANIMATION_INTERVAL_MILLI:int = 100;
    public static var WIN_ANIMATION_COUNT:int = 10;//you appear 5 times more than disappear
    private var winAnimationIntervalId:int = -1;
    private var winCounter:int = 0;
    public function startWinAnimation():void {
    	clearWinAnimation();
    	winCounter = 0;
    	winAnimationStep();
    	winAnimationIntervalId =
    		setInterval(AS3_vs_AS2.delegate(this, this.winAnimationStep), WIN_ANIMATION_INTERVAL_MILLI);    	    	
    }
    private function winAnimationStep():void {
    	setVisible(winCounter!=0);
    	winCounter = (winCounter+1) % WIN_ANIMATION_COUNT;
    }
    public function clearWinAnimation():void {
    	if (winAnimationIntervalId==-1) return;
    	clearInterval(winAnimationIntervalId);
    	winAnimationIntervalId = -1;
		setVisible(true);    	
    }
        
    // the move animation changes the alpha from 0% to 100%, in steps of MOVE_ANIMATION_ALPHA_DELTA    
    public static var MOVE_ANIMATION_INTERVAL_MILLI:int = 50;
    public static var MOVE_ANIMATION_ALPHA_DELTA:int = 20;
    private var alphaPercentage:int;
    private var moveAnimationIntervalId:int = -1;
    public function startMoveAnimation():void {
    	StaticFunctions.assert(moveAnimationIntervalId==-1, ["TictactoeSquareGraphic is already in animation mode! sqaure=", move]);
    	
		graphic.animationStarted();
		soundMovieClip.gotoAndPlay("MakeSound");
		
		alphaPercentage = 0;
		moveAnimationStep();
    	moveAnimationIntervalId =
    		setInterval(AS3_vs_AS2.delegate(this, this.moveAnimationStep), MOVE_ANIMATION_INTERVAL_MILLI);		
    }
    private function moveAnimationStep():void {
    	if (alphaPercentage>=100) {
			alphaPercentage = 100;
			clearInterval(moveAnimationIntervalId);
			moveAnimationIntervalId = -1;
			graphic.moveAnimationEnded(move,false);    				
		}   		
		setAlpha(alphaPercentage);
		alphaPercentage += MOVE_ANIMATION_ALPHA_DELTA;
    }
    private function setAlpha(alpha:int):void {
		AS3_vs_AS2.setAlpha(symbolsContainer, alpha);    	
    }
    private function setVisible(isVisible:Boolean):void {
		AS3_vs_AS2.setVisible(symbolsContainer, isVisible);    	
    }
    
	public function setColor(color:int):void {	
		trace("Changing square "+move+" to setColor="+color);
		currentTurnForMouseOver = BTN_NONE;
		AS3_vs_AS2.setAlpha(symbolsContainer, 100);
		setSymbol(color);
		setButtonListeners(false);	
		showOrHideLogo(false);
	}
	public static var BUTTON_SYMBOL_ALPHA:int = 40;
	public function startMove(currentTurn:int):void {
		trace("Changing square "+move+" to startMove="+currentTurn);
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
	private function setSymbol(color:int):void {
		for (var i:int=0; i<MAX_SYMBOLS; i++)
			AS3_vs_AS2.setVisible(allSymbols[i], i==color);
	}
	private function pressedOn(event:MouseEvent):void  {
		graphic.userMadeHisMove(move);		
	}
	private function mouseOver(event:MouseEvent):void  {	
		if (currentTurnForMouseOver!=BTN_NONE)
			setSymbol(currentTurnForMouseOver);
	}
	private function mouseOut(event:MouseEvent):void  {
		if (currentTurnForMouseOver!=BTN_NONE)
			setSymbol(BTN_NONE);
	}
	
}
}