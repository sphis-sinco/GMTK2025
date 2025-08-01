package;

import flixel.FlxSprite;

class GameplayButton extends FlxSprite
{
	override public function new(image:String)
	{
		super(0, 0);

		loadGraphic('assets/images/$image.png', true, 64, 64);
		animation.add('idle', [0]);
		animation.add('pressed', [1]);
		animation.add('tapped', [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1], 15, false);
		animation.play('idle');
		#if MOBILE_BUILD
		scale.set(4, 4);
		#else
		scale.set(2, 2);
		#end
		screenCenter();
	}
}
