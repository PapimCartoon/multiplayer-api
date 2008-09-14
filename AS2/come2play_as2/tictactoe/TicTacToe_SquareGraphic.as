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
    

	// the winning animation changes the visibility of the square
	// when winCounter=0 it disappears, otherwise it appears, and it counts till WIN_ANIMATION_COUNT   
    public static var WIN_ANIMATION_INTERVAL_MILLI:Number = 100;
    public static var WIN_ANIMATION_COUNT:Number = 10;//you appear 5 times more than disappear
    private var winAnimationIntervalId:Number = -1;
    private var winCounter:Number = 0;
    public function startWinAnimation():Void {
    	clearWinAnimation();
    	winCounter = 0;
    	winAnimationStep();
    	winAnimationIntervalId =
    		setInterval(AS3_vs_AS2.delegate(this, this.winAnimationStep), WIN_ANIMATION_INTERVAL_MILLI);    	    	
    }
    private function winAnimationStep():Void {
    	setVisible(winCounter!=0);
    	winCounter = (winCounter+1) % WIN_ANIMATION_COUNT;
    }
    public function clearWinAnimation():Void {
    	if (winAnimationIntervalId==-1) return;
    	clearInterval(winAnimationIntervalId);
    	winAnimationIntervalId = -1;
		setVisible(true);    	
    }
        
    // the move animation changes the alpha from 0% to 100%, in steps of MOVE_ANIMATION_ALPHA_DELTA    
    public static var MOVE_ANIMATION_INTERVAL_MILLI:Number = 50;
    public static var MOVE_ANIMATION_ALPHA_DELTA:Number = 20;
    private var alphaPercentage:Number;
    private var moveAnimationIntervalId:Number = -1;
    public function startMoveAnimation():Void {
    	if (moveAnimationIntervalId!=-1) return; // already in animation mode
    	
		graphic.animationStarted();
		soundMovieClip.gotoAndPlay("MakeSound");
		
		alphaPercentage = 0;
		moveAnimationStep();
    	moveAnimationIntervalId =
    		setInterval(AS3_vs_AS2.delegate(this, this.moveAnimationStep), MOVE_ANIMATION_INTERVAL_MILLI);		
    }
    private function moveAnimationStep():Void {
    	if (alphaPercentage>=100) {
			alphaPercentage = 100;
			clearInterval(moveAnimationIntervalId);
			moveAnimationIntervalId = -1;
			graphic.animationEnded();    				
		}   		
		setAlpha(alphaPercentage);
		alphaPercentage += MOVE_ANIMATION_ALPHA_DELTA;
    }
    private function setAlpha(alpha:Number):Void {
		AS3_vs_AS2.setAlpha(letter, alpha);    	
    }
    private function setVisible(isVisible:Boolean):Void {
		AS3_vs_AS2.setVisible(letter, isVisible);    	
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
