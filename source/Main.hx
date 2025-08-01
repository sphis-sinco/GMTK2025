package;

import flixel.FlxG;
import flixel.FlxGame;
import lime.app.Application;
import openfl.display.Sprite;
import save.SaveManager;

class Main extends Sprite
{
	public function new()
	{
		super();

		FlxG.assets.loadSound('assets/sfx/flixel.wav');

		SaveManager.bind();

		addChild(new FlxGame(0, 0, IntroState, 60, 60, true));
	}
}
