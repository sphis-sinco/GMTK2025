package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var playerHand:HandClass;
	var enemyHand:HandClass;

	var enemyPick:Int = 0;

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

		enemyPick = FlxG.random.int(1, 3);

		switch (enemyPick)
		{
			case 1:
				enemyHand.animation.play('rock');
			case 2:
				enemyHand.animation.play('paper');
			case 3:
				enemyHand.animation.play('scissors');
		}

		if (FlxG.mouse.overlaps(playerHand))
		{
			if (FlxG.mouse.justReleased)
			{
				switch (playerHand.animation.name.toLowerCase())
				{
					case 'rock':
						playerHand.animation.play('paper');
					case 'paper':
						playerHand.animation.play('scissors');
					default:
						playerHand.animation.play('rock');
				}
			}
		}
	}
}
