import come2play_as2.api.*;
import come2play_as2.api.auto_copied.*;


import come2play_as2.tictactoe.*;
class come2play_as2.tictactoe.TicTacToe_SquareGraphic
{
	public static var BTN_NONE:Number = -2; 	
	
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
	public function gotLogo(logo:String):Void {
		AS3_vs_AS2.loadMovie(AS3_vs_AS2.getMovieChild(logoContainer,"InsideContainer"), logo);		
	}	
    private function showOrHideLogo(shouldAdd:Boolean):Void {
    	AS3_vs_AS2.setVisible(logoContainer,shouldAdd);
    }
        
    public static var ANIMATION_INTERVAL_MILLI:Number = 50;
    public static var ANIMATION_ALPHA_DELTA:Number = 5;
    private var alphaPercentage:Number;
    private var animationIntervalId:Number = -1;
    public function startMoveAnimation():Void {
    	if (animationIntervalId!=-1) return; // already in animation mode
    	
		graphic.animationStarted();
		soundMovieClip.gotoAndPlay("MakeSound");
		
		alphaPercentage = 0;
		animationStep();
    	animationIntervalId =
    		setInterval(AS3_vs_AS2.delegate(this, this.animationStep), ANIMATION_INTERVAL_MILLI);		
    }
    private function animationStep():Void {
    	if (alphaPercentage>=100) {
			alphaPercentage = 100;
			clearInterval(animationIntervalId);
			animationIntervalId = -1;
			graphic.animationEnded();    				
		}   		
		AS3_vs_AS2.setAlpha(letter, alphaPercentage);
		alphaPercentage += ANIMATION_ALPHA_DELTA;
    }
    
	public function setColor(color:Number):Void {
		letter.gotoAndStop("Color_"+color);
		btn.gotoAndStop("Btn_None");		
		showOrHideLogo(false);
	}
	public function startMove(currentTurn:Number):Void {
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
	private function pressedOn():Void  {
		graphic.userMadeHisMove(move);		
	}
}
