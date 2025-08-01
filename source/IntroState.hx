package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class IntroState extends FlxState
{
	var logo:FlxSprite = new FlxSprite(0, 0, 'assets/images/jam-logo.png');
	var text:FlxText = new FlxText(0, 0, 0, 'GMTK 2025', 32);

	private var _times:Array<Float>;
	private var _curPart:Int = 0;
	private var _functions:Array<Void->Void>;

	var started:Bool = false;

	override public function create():Void
	{
		FlxG.fixedTimestep = false;

		// These are when the flixel notes/sounds play, you probably shouldn't change these if you want the functions to sync up properly
		_times = [0.041, 0.184, 0.334, 0.495, 0.636];

		// An array of functions to call after each time thing has passed, feel free to rename to whatever
		_functions = [addText1, addText2, addText3, addText4, addText5];
		text.visible = false; #if (debug && !html5) text.text = #if MOBILE_BUILD 'Tap anywhere to start...\n\nHow are you here?' #else 'Press anything to start' #end;
		text.visible = true; #end text.screenCenter();
		add(text);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		// Thing to skip the splash screen
		// Comment this out if you want it unskippable
		if (FlxG.keys.justPressed.SPACE)
		{
			finishTween();
		}

		if (#if (debug && !html5) FlxG.mouse.justReleased || FlxG.keys.justReleased.ANY && #end!started)
		{
			if (started)
				return;

			started = true;

			for (time in _times)
			{
				new FlxTimer().start(time, timerCallback);
			}

			// put the included flixel.mp3 into your assests folder in your project
			FlxG.sound.play('assets/sfx/flixel.wav', 1, false, null, true);
		}

		super.update(elapsed);
	}

	private function timerCallback(Timer:FlxTimer):Void
	{
		try
		{
			_functions[_curPart]();
		}
		catch (e)
		{
			trace('${e.message}: $_curPart');
		}
		_curPart++;

		if (_curPart == 5)
		{
			// What happens when the final sound/timer time passes
			// change parameters to whatever you feel like
			FlxG.camera.fade(FlxColor.BLACK, 3.25, false, finishTween);
		}
	}

	private function addText1():Void
	{
		// stuff that happens
	}

	private function addText2():Void
	{
		// stuff that happens
		text.visible = true;
		text.text = 'Made';
		text.screenCenter();
	}

	private function addText3():Void
	{
		// stuff that happens
		text.text += ' For';
		text.screenCenter();
	}

	private function addText4():Void
	{
		// stuff that happens
		text.text += ' The';
		text.screenCenter();
	}

	private function addText5():Void
	{
		// stuff that happens
		text.visible = false;
		FlxG.camera.fade(FlxColor.WHITE, 1, true);

		logo.scale.set(#if MOBILE_BUILD 1 / 4, 1 / 4 #else 1 / 8, 1 / 8 #end);
		logo.screenCenter();
		add(logo);

		FlxTween.tween(logo, {y: FlxG.height * 2}, 3.25, {
			ease: FlxEase.expoIn,
			onComplete: _tween ->
			{
				FlxG.switchState(() -> new DifficultyState());
			}
		});
	}

	private function finishTween():Void
	{
		FlxG.switchState(() -> new DifficultyState());
	}
}
