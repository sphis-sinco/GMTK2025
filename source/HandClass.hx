package;

import flixel.FlxSprite;

class HandClass extends FlxSprite
{
	override public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);

		loadGraphic('assets/images/icons.png', true, 32, 32);
		animation.add('rock', [0]);
		animation.add('selected-rock', [1]);
		animation.add('paper', [4]);
		animation.add('selected-paper', [5]);
		animation.add('scissors', [2]);
		animation.add('selected-scissors', [3]);

		animation.play('rock');

		#if MOBILE_BUILD
		scale.set(6, 6);
		#else
		scale.set(2, 2);
		#end
	}
}
