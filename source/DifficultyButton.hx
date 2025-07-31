package;

import flixel.FlxSprite;
import flixel.ui.FlxSpriteButton;

class DifficultyButton extends FlxSpriteButton
{
	override public function new(x:Float = 0.0, y:Float = 0.0, label:Int = 0)
	{
		var button:FlxSprite = new FlxSprite().loadGraphic('assets/images/difficulties.png', true, 64, 64);

		button.animation.add('easy', [0]);
		button.animation.add('normal', [1]);
		button.animation.add('hard', [2]);
		button.animation.add('arrow', [3]);

		switch (label)
		{
			default:
				button.animation.play('arrow');
			case 1:
				button.animation.play('easy');
			case 2:
				button.animation.play('normal');
			case 3:
				button.animation.play('hard');
		}

		super(x, y, button);
	}
}
