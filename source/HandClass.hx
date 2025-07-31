package;

import flixel.FlxSprite;

class HandClass extends FlxSprite
{
	override public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);

		loadGraphic('assets/images/icons.png', true, 32, 32);
		animation.add('rock', [1]);
		animation.add('paper', [3]);
		animation.add('scissors', [2]);
	}
}
