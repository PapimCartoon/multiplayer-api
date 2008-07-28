import come2play_as2.api.*;


import come2play_as2.tictactoe.*;
class come2play_as2.tictactoe.TicTacToe_SquareGraphic
{
	public static var BTN_NONE:Number = -2; 	
	
	private var graphic:TicTacToe_graphic;
	private var square:MovieClip;
	private var btn:MovieClip;
	private var row:Number;
	private var col:Number;
	private var logoContainer:MovieClip;
		
	public function TicTacToe_SquareGraphic(graphic:TicTacToe_graphic, square:MovieClip, row:Number, col:Number) {
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
	public function got_logo(logo:String):Void {
		AS3_vs_AS2.loadMovie(AS3_vs_AS2.getMovieChild(logoContainer,"InsideContainer"), logo);		
	}	
    private function showOrHideLogo(shouldAdd:Boolean):Void {
    	AS3_vs_AS2.setVisible(logoContainer,shouldAdd);
    }
        
	public function setColor(color:Number):Void {
		square.gotoAndStop("Color_"+color);
		btn.gotoAndStop("Btn_None");		
		showOrHideLogo(false);
	}
	public function setOnPress(currentTurn:Number):Void {
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
	private function pressedOn():Void  {
		graphic.dispatchMoveIfLegal(row, col);		
	}
}
