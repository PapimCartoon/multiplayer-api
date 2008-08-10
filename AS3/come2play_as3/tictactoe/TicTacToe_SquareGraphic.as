package come2play_as3.tictactoe
{
import come2play_as3.api.*;

import flash.display.*;

public final class TicTacToe_SquareGraphic
{
	public static const BTN_NONE:int = -2; 	
	
	private var graphic:TicTacToe_Main;
	private var square:MovieClip;
	private var btn:MovieClip;
	private var row:int;
	private var col:int;
	private var logoContainer:MovieClip;
		
	public function TicTacToe_SquareGraphic(graphic:TicTacToe_Main, square:MovieClip, row:int, col:int) {
		this.graphic = graphic;
		this.square = square;
		this.btn = AS3_vs_AS2.getMovieChild(square,"Btn_X_O");
		this.logoContainer = AS3_vs_AS2.getMovieChild(square,"LogoContainer");
		this.row = row;
		this.col = col; 
		if (AS3_vs_AS2.isAS3)
			AS3_vs_AS2.addOnPress(btn,	AS3_vs_AS2.delegate(this, this.pressedOn));		
		showOrHideLogo(false);
	}
	public function got_logo(logo:String):void {
		AS3_vs_AS2.loadMovie(AS3_vs_AS2.getMovieChild(logoContainer,"InsideContainer"), logo);		
	}	
    private function showOrHideLogo(shouldAdd:Boolean):void {
    	AS3_vs_AS2.setVisible(logoContainer,shouldAdd);
    }
        
	public function setColor(color:int):void {
		square.gotoAndStop("Color_"+color);
		btn.gotoAndStop("Btn_None");		
		showOrHideLogo(false);
	}
	public function setOnPress(currentTurn:int):void {
		//trace("Changing square "+row+"x"+col+" to "+currentTurn);
		square.gotoAndStop("None");
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
		graphic.dispatchMoveIfLegal(row, col);		
	}
}
}