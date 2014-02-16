package ;

import flixel.FlxSprite;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Masadow
 */
class Character extends FlxSprite
{
	
	private var _currentDirection : Int;

	public function new(X : Int, Y : Int) 
	{
		super(X, Y);
		loadGraphic("images/character.png", true, false, 32, 32);
		
		_currentDirection = -1;
		
		//Setting the hitboxes
		height = 8;
		offset.y = 24;

		for (i in 0...4)
		{
			animation.add("stop" + i, [1 + (i * 3)]);
			animation.add("move" + i, [0 + (i * 3), 1 + (i * 3), 2 + (i * 3)], 10);
		}
	}
	
	override  function update():Void 
	{
		super.update();
		
		if (velocity.x > 0 && velocity.y > 0) {
			if (_currentDirection != 0)
				animation.play("move0");
			_currentDirection = 0;
		}
		else if (velocity.x < 0 && velocity.y > 0) {
			if (_currentDirection != 1)
				animation.play("move1");
			_currentDirection = 1;
		}
		else if (velocity.x < 0 && velocity.y < 0) {
			if (_currentDirection != 2)
				animation.play("move2");
			_currentDirection = 2;
		}
		else if (velocity.x > 0 && velocity.y < 0) {
			if (_currentDirection != 3)
				animation.play("move3");
			_currentDirection = 3;
		}
		else if (velocity.x == 0 && velocity.y == 0) {
			if (_currentDirection != -1)
				animation.play("stop" + _currentDirection);
			_currentDirection = -1;
		}
	}
}