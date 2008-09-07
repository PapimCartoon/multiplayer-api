package come2play_as3.tictactoe
{
import come2play_as3.api.*;
import come2play_as3.api.auto_copied.*;

import flash.display.*;
import flash.utils.clearInterval;
import flash.utils.setInterval;

public final class TicTacToe_SquareGraphic
{
	public static const BTN_NONE:int = -2; 	
	
	private var graphic:TicTacToe_Main;
	private var letter:MovieClip;	
	private var soundMovieClip:MovieClip;
	private var btn:MovieClip;

	private var move:TicTacToeMove;
	private var logoContainer:MovieClip;
		
	public function TicTacToe_SquareGraphic(graphic:TicTacToe_Main, square:MovieClip, move:TicTacToeMove) {
		this.graphic = graphic;
		this.btn = AS3_vs_AS2.getMovieChild(square,"Btn_X_O");
		this.logoContainer = AS3_vs_AS2.getMovieChild(square,"LogoContainer");
		this.letter = AS3_vs_AS2.getMovieChild(square,"letter");
		this.soundMovieClip = AS3_vs_AS2.getMovieChild(square,"SoundMovieClip");		
		this.move = move;
		if (AS3_vs_AS2.isAS3)
			AS3_vs_AS2.addOnPress(btn,	AS3_vs_AS2.delegate(this, this.pressedOn));		
		showOrHideLogo(false);
	}
	public function gotLogo(logo:String):void {
		AS3_vs_AS2.loadMovie(AS3_vs_AS2.getMovieChild(logoContainer,"InsideContainer"), logo);		
	}	
    private function showOrHideLogo(shouldAdd:Boolean):void {
    	AS3_vs_AS2.setVisible(logoContainer,shouldAdd);
    }
        
    public static var ANIMATION_INTERVAL_MILLI:int = 50;
    public static var ANIMATION_ALPHA_DELTA:int = 5;
    public function startAnimation():void {
		soundMovieClip.gotoAndPlay("MakeSound");
		
    	var alphaPercentage:int = 0;
		var thisObj:TicTacToe_SquareGraphic = this; // for AS2
    	var func:Function = 
    		function ():void {
    			if (alphaPercentage>=100) {
    				alphaPercentage = 100;
    				clearInterval(intervalId);
    				thisObj.graphic.animationEnded();    				
    			}   		
	    		AS3_vs_AS2.setAlpha(thisObj.letter, alphaPercentage);
	    		alphaPercentage += ANIMATION_ALPHA_DELTA;	 
	    	};
		func();
    	var intervalId:int =
    		setInterval(func , ANIMATION_INTERVAL_MILLI);		
    }
	public function setColor(color:int):void {
		letter.gotoAndStop("Color_"+color);
		btn.gotoAndStop("Btn_None");		
		showOrHideLogo(false);
	}
	public function startMove(currentTurn:int):void {
		//trace("Changing square "+move+" to "+currentTurn);
		letter.gotoAndStop("None");
		btn.gotoAndStop(currentTurn==BTN_NONE ? "Btn_None" : 
						"Btn_"+currentTurn);
		if (currentTurn!=BTN_NONE) {
			if (currentTurn<0) throw Error("Internal error!");
			if (!AS3_vs_AS2.isAS3)
				AS3_vs_AS2.addOnPress(AS3_vs_AS2.getChild(btn,"btn"), AS3_vs_AS2.delegate(this, this.pressedOn));				
			showOrHideLogo(false);
		} else {		
			showOrHideLogo(true);	
		}
	}
	private function pressedOn():void  {
		graphic.userMadeHisMove(move);		
	}
}
}