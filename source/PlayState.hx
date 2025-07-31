package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var playerHand:HandClass;

	override public function create()
	{
		playerHand = new HandClass();
		add(playerHand);
		playerHand.screenCenter(Y);
		playerHand.x = FlxG.width - (playerHand.width * 4);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
