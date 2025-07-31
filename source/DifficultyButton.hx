package;

import flixel.FlxSprite;

class DifficultyButton extends FlxSprite
{
	override public function new(x:Float = 0.0, y:Float = 0.0, diff:Int = 0)
	{
		super(x, y);

		loadGraphic('assets/images/difficulties.png', true, 64, 64);

		animation.add('easy', [0]);
		animation.add('normal', [1]);
		animation.add('hard', [2]);
		animation.add('arrow', [3]);

		switchDiff(diff);

		#if MOBILE_BUILD
		scale.set(6, 6);
		#else
		scale.set(2, 2);
		#end
	}

	public function switchDiff(diff:Int = 0)
	{
		switch (diff)
		{
			default:
				animation.play('arrow');
			case 1:
				animation.play('easy');
			case 2:
				animation.play('normal');
			case 3:
				animation.play('hard');
		}
	}
}
