package;

import flixel.FlxG;
import flixel.FlxState;

class DifficultyState extends FlxState
{
	override function create()
	{
		super.create();

		changeDifficulty();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.RIGHT)
		{
			changeDifficulty(1);
		}

		if (FlxG.keys.justReleased.LEFT)
		{
			changeDifficulty(-1);
		}
	}

	function changeDifficulty(change:Int = 0) {}
}
