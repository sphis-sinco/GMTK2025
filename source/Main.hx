package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		FlxG.save.bind('GMTK-2025', 'Sinco');

		if (FlxG.save.data.isNew == true)
			FlxG.save.data.isNew = false;
		if (FlxG.save.data.isNew == null)
			FlxG.save.data.isNew = true;

		trace(FlxG.save.data);
		addChild(new FlxGame(0, 0, IntroState));
	}
}
