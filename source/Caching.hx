package;

import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

#if sys
import sys.FileSystem;
#end

class Caching extends FlxState
{
	var toBeDone = 0;
	var done = 0;

	var loaded = false;

	var text:FlxText;
	var logo:FlxSprite;

	public static var bitmapData:Map<String, FlxGraphic>;

	var images = [];
	var audio = [];
	var charts = [];

	override function create()
	{
		bitmapData = new Map<String, FlxGraphic>();

		text = new FlxText(FlxG.width / 2, FlxG.height / 2 + 300, 0, 'Loading...');
		text.size = 34;
		text.alignment = FlxTextAlign.CENTER;
		text.alpha = 0;

		logo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic('assets/images/appIcon.png');
		logo.x -= logo.width / 2;
		logo.y -= logo.height / 2 + 100;
		text.y -= logo.height / 2 - 125;
		text.x -= 170;
		logo.setGraphicSize(Std.int(logo.width * 0.6));
		logo.antialiasing = false;

		logo.alpha = 0;

		FlxGraphic.defaultPersist = FlxG.save.data.cacheImages;

		trace('caching images...');

		// TODO: Refactor this to use OpenFlAssets.
		for (i in FileSystem.readDirectory(FileSystem.absolutePath('assets/images')))
		{
			if (!i.endsWith('.png'))
				continue;
			images.push(i);
		}

		trace('caching audio...');

		audio = FileSystem.readDirectory('assets/audio/');
		for (wav in audio)
		{
			if (!wav.endsWith('.wav'))
				audio.remove(wav);
		}

		toBeDone = Lambda.count(images) + Lambda.count(audio);

		var bar = new FlxBar(10, FlxG.height - 50, FlxBarFillDirection.LEFT_TO_RIGHT, FlxG.width, 40, null, 'done', 0, toBeDone);
		bar.color = FlxColor.PURPLE;

		add(bar);

		add(logo);
		add(text);

		trace('starting caching..');

		// cache thread
		sys.thread.Thread.create(() ->
		{
			cache();
		});

		super.create();
	}

	var calledDone = false;

	override function update(elapsed)
	{
		super.update(elapsed);

		logo.alpha = 1;
		text.alpha = 1;
		text.text = 'Loading... ($done/$toBeDone)';

		if (loaded)
			FlxG.switchState(() -> new IntroState());
	}

	function cache()
	{
		trace('LOADING: ' + toBeDone + ' OBJECTS.');

		for (i in images)
		{
			var replaced = i.replace('.png', '');

			var imagePath = 'assets/images/$replaced.png';
			trace('Caching graphic $replaced ($imagePath)...');
			var data = OpenFlAssets.getBitmapData(imagePath);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced, graph);
			done++;
		}

		for (i in audio)
		{
			var wav = 'assets/audio/$i';
			if (FileSystem.exists(wav))
			{
				trace('Caching sound $wav');
				FlxG.sound.cache(wav);
			}

			done++;
		}

		trace('Finished caching...');

		loaded = true;
	}

	public static function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}
}
