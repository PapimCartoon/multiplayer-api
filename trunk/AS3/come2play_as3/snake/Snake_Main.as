package come2play_as3.snake
{
import come2play_as3.api.*;

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
public final class Snake_Main {
}
}