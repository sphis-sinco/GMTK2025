package save;

import lime.app.Application;

class SaveManager
{
	public static function bind()
	{
		FlxG.save.bind('Ropasci', 'Sinco');
		FlxG.save.mergeDataFrom('GMTK-2025', 'Sinco', true);

		if (FlxG.save.data.isNew == true)
			FlxG.save.data.isNew = false;
		if (FlxG.save.data.isNew == null)
			FlxG.save.data.isNew = true;

		if (FlxG.save.data.score == null)
			FlxG.save.data.score = 0.0;

		Application.current.onExit.add(function(exitCode)
		{
			FlxG.save.flush();
		}, false, 100);
	}
}
