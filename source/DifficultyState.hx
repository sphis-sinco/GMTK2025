package;

import flixel.FlxG;
import flixel.FlxState;

class DifficultyState extends FlxState
{
	var difficulty:DifficultyButton;

	public static var diff:Int = 2;

	var leftBtn:DifficultyButton = new DifficultyButton(0, 0, 4);
	var rightBtn:DifficultyButton = new DifficultyButton(0, 0, 4);

	override function create()
	{
		super.create();

		difficulty = new DifficultyButton(0, 0, diff);
		difficulty.screenCenter();

		leftBtn.x = difficulty.x - (difficulty.width * (#if MOBILE_BUILD 3 + #end 3.5));
		rightBtn.x = difficulty.x + (difficulty.width * (#if MOBILE_BUILD 3 + #end 3.5));

		leftBtn.y = difficulty.y;
		rightBtn.y = leftBtn.y;

		rightBtn.flipX = true;

		add(leftBtn);
		add(rightBtn);
		add(difficulty);

		changeDifficulty();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.RIGHT || (FlxG.mouse.overlaps(rightBtn) && FlxG.mouse.justReleased))
		{
			changeDifficulty(1);
		}

		if (FlxG.keys.justReleased.LEFT || (FlxG.mouse.overlaps(leftBtn) && FlxG.mouse.justReleased))
		{
			changeDifficulty(-1);
		}

		if (FlxG.keys.justReleased.ENTER || (FlxG.mouse.overlaps(difficulty) && FlxG.mouse.justReleased))
		{
			PlayState.score = 0;
			PlayState.requestedBT = null;
			FlxG.switchState(() -> new PlayState());
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
