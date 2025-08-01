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

		SaveManager.bind();

		addChild(new FlxGame(0, 0, #if sys Caching #else IntroState #end, 60, 60, true));
	}
}
