package;

import flixel.FlxG;
import flixel.FlxState;

class DifficultyState extends FlxState
{
	var difficulty:DifficultyButton;
	var diff:Int = 2;

	override function create()
	{
		super.create();

		difficulty = new DifficultyButton(0, 0, diff);
		difficulty.screenCenter();
		add(difficulty);

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

	function changeDifficulty(change:Int = 0)
	{
		diff += change;

		diff = (diff < 1) ? 1 : diff;
		diff = (diff > 3) ? 3 : diff;

		difficulty.switchDiff(diff);
	}
}
