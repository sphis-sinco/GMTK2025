package;

import flixel.FlxG;
import flixel.FlxGame;
import lime.app.Application;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		FlxG.assets.loadSound('assets/sfx/flixel.wav');

		FlxG.save.bind('Ropasci', 'Sinco');
		FlxG.save.mergeDataFrom('GMTK-2025', 'Sinco', true);

		if (FlxG.save.data.isNew == true)
			FlxG.save.data.isNew = false;
		if (FlxG.save.data.isNew == null)
			FlxG.save.data.isNew = true;

		if (FlxG.save.data.score == null)
			FlxG.save.data.score = 0.0;

		trace(FlxG.save.data);

		Application.current.onExit.add(function(exitCode)
		{
			FlxG.save.flush();
		}, false, 100);
		addChild(new FlxGame(0, 0, IntroState, 60, 60, true));
	}
}
