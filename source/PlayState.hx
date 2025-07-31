package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var playerHand:HandClass;
	var enemyHand:HandClass;

	override public function create()
	{
		playerHand = new HandClass();
		add(playerHand);
		playerHand.screenCenter(Y);
		playerHand.x = FlxG.width - (playerHand.width * 4);

		enemyHand = new HandClass();
		add(enemyHand);
		enemyHand.flipX = true;
		enemyHand.screenCenter(Y);
		enemyHand.x = enemyHand.width * 4;

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
