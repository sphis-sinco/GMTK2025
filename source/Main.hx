package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		FlxG.assets.loadSound('assets/sfx/flixel.wav');

		FlxG.save.bind('GMTK-2025', 'Sinco');

		if (FlxG.save.data.isNew == true)
			FlxG.save.data.isNew = false;
		if (FlxG.save.data.isNew == null)
			FlxG.save.data.isNew = true;

		if (FlxG.save.data.score == null)
			FlxG.save.data.score = 0.0;

		trace(FlxG.save.data);
		addChild(new FlxGame(0, 0, IntroState, 60, 60, true));
	}
}
