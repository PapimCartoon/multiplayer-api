package come2play_as3.tictactoe
{
import come2play_as3.api.*;
import come2play_as3.api.auto_copied.*;

import flash.display.*;
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
	private var currentTurnForMouseOver:int = BTN_NONE;

	private var move:TictactoeCell;
	private var logoContainer:MovieClip;
		
	public function TictactoeSquareGraphic(graphic:TictactoeMain, square:MovieClip, move:TictactoeCell) {
		this.graphic = graphic;
		this.buttonContainer = AS3_vs_AS2.getMovieChild(square,"buttonContainer");
		this.logoContainer = AS3_vs_AS2.getMovieChild(square,"logoContainer");
		this.symbolsContainer = AS3_vs_AS2.getMovieChild(square,"symbolsContainer");
		this.soundMovieClip = AS3_vs_AS2.getMovieChild(square,"soundMovieClip");		
		this.move = move;
		if (AS3_vs_AS2.isAS3) {
			addButtonListeners(buttonContainer);
		}
			
		allSymbols = [];
		for (var i:int=0; i<MAX_SYMBOLS; i++) {
			var newSymbol:MovieClip = AS3_vs_AS2.createMovieInstance(symbolsContainer,"Symbol_"+i,"symbol"+i);
			addSymbol(i, newSymbol);
		}
					
		showOrHideLogo(false);
	}
	private function addButtonListeners(btn:DisplayObject):void {
		AS3_vs_AS2.addOnPress(btn,	AS3_vs_AS2.delegate(this, this.pressedOn));
		AS3_vs_AS2.addOnMouseOver(btn,	AS3_vs_AS2.delegate(this, this.mouseOver),	AS3_vs_AS2.delegate(this, this.mouseOut));
	}
	private function addSymbol(color:int, newSymbol:DisplayObject):void {
		AS3_vs_AS2.setVisible(newSymbol,false);
		allSymbols[color] = newSymbol;
	} 
	public function gotSymbol(color:int, symbolUrl:String):void {
		if (color<0 || color>=MAX_SYMBOLS) throw new Error("Illegal color="+color);
		AS3_vs_AS2.removeMovie(allSymbols[color]);
		var newSymbol:DisplayObject =
			AS3_vs_AS2.loadMovieIntoNewChild(symbolsContainer, symbolUrl);
		addSymbol(color, newSymbol);
	}
	public function gotLogo(logo:String):void {
		AS3_vs_AS2.loadMovieIntoNewChild(logoContainer, logo);		
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
    	if (moveAnimationIntervalId!=-1) return; // already in animation mode
    	
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
			graphic.animationEnded();    				
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
		currentTurnForMouseOver = BTN_NONE;
		AS3_vs_AS2.setAlpha(symbolsContainer, 100);
		setSymbol(color);
		buttonContainer.gotoAndStop("NoBtn");		
		showOrHideLogo(false);
	}
	public static var BUTTON_SYMBOL_ALPHA:int = 40;
	public function startMove(currentTurn:int):void {
		//trace("Changing square "+move+" to "+currentTurn);
		AS3_vs_AS2.setAlpha(symbolsContainer, BUTTON_SYMBOL_ALPHA);
		currentTurnForMouseOver = currentTurn;
		setSymbol(BTN_NONE);
		buttonContainer.gotoAndStop(currentTurn==BTN_NONE ? "NoBtn" : "WithBtn");
		if (currentTurn!=BTN_NONE) {
			if (currentTurn<0) throw Error("Internal error!");
			if (!AS3_vs_AS2.isAS3)
				addButtonListeners(AS3_vs_AS2.getChild(buttonContainer,"btn"));				
			showOrHideLogo(false);
		} else {		
			showOrHideLogo(true);	
		}
	}
	private function setSymbol(color:int):void {
		var withSymbol:Boolean = color!=BTN_NONE;
		for (var i:int=0; i<MAX_SYMBOLS; i++)
			AS3_vs_AS2.setVisible(allSymbols[i], i==color);
	}
	private function pressedOn():void  {
		graphic.userMadeHisMove(move);		
	}
	private function mouseOver():void  {	
		if (currentTurnForMouseOver!=BTN_NONE)
			setSymbol(currentTurnForMouseOver);
	}
	private function mouseOut():void  {
		if (currentTurnForMouseOver!=BTN_NONE)
			setSymbol(BTN_NONE);
	}
	
}
}