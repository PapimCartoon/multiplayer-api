package come2play_as3.snake
{
import come2play_as3.api.*;
import come2play_as3.util.*;

import flash.display.*;
import flash.events.*;
import flash.utils.*;
/**
 * The snake game is a classic game where each player
 * controls a moving snake on board, 
 * while trying to avoid hitting the walls or other snakes.
 * 
 * The snake movement is progressed/controlled by ticks,
 * and the game ticks every 100 milliseconds.
 * To compensate for network delay, we delay controlling the snake,
 * i.e., when you press to go "left" then the snake will go "left" only after 10 ticks.
 * To make this delay intuitive to the player, we create for each player a phantom snake
 * that shows how the snake will behave in the next 10 ticks.
 * The behaviour of the phantom is different than the behaviour of a normal snake:
 * the phantom can hit other snakes 
 * (because those snakes might not be there after 10 ticks)
 * 
 * Match state:
 * - the number of ticks since the beginning of the game
 *   every 100 ticks all the snakes grow by one cell.
 * Each player has the following state:
 * - the position of his snake and his phantom
 *  (the direction of the snake is determined by the phantom)
 * 
 * The match state uses these keys:
 * "ticksNumber"
 * The match state for a player is an array containing all the snakes positions,
 * e.g., [ [7,4] , [7,5], [7,6], [8,6], ... ]
 * [7,4] is the tail of the snake.
 */
public final class Snake_Main extends CombinedClientAndSecureGameAPI {
{
	// you can change these values by setting in the flashvars:
	// SET_VAR_* , e.g., SET_VAR_MILLISECONDS_BETWEEN_KEY_PRESSES
	public static var MILLISECONDS_BETWEEN_KEY_PRESSES:int = 500;	

	// match state
	private var ticksNumber:int = 0;
	private var snakes:Array/*SnakeInfo*/ = null;
	// not state
	private var lastKeyStroke:int;
	private var lastKeyStrokeTime:int;
	
	public function Snake_Main(graphics:MovieClip) {		
		new CreateGrid(graphics,25,25,100);	
		graphics.stop();
	}
	
	public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void {
		if (snakes==null) return;
		if (!isKeyDown) return;
		
		var now:int = getTimer();
		if (lastKeyStroke==keyCode && (now < lastKeyStrokeTime+500)) return;// ...and it's different from the last key pressed
		lastKeyStrokeTime = now;
		lastKeyStroke = keyCode;
		
		if (!isInPause && myColor!=null && keyCode > 36 && keyCode < 41) { // arrow keys pressed (37 = left, 38 = up, 39 = right, 40 = down)
			mySubmitEvent(keyCode-37); // save the key (or rather direction) in the turnQueue
		
		} else if (withPause && (keyCode == 80 || keyCode == 112)) { // pause/unpause (80 = 'P'   112 = 'p')
			// The pause option should be enabled only when both sides agree, e.g., in a special room, because it can annoy the opponent if you pause for too long, he won't be ready when the game starts again, etc
			doPause(!isInPause);
	}

}
}