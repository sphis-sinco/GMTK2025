package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var playerHand:HandClass;
	var enemyHand:HandClass;

	public static var playerLastPick:Int = 0;

	var playerPick:Int = 0;
	var enemyPick:Int = 0;

	var go:Bool = false;

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

		if (!go)
		{
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
							playerPick = 2;
							playerHand.animation.play('paper');
						case 'paper':
							playerPick = 3;
							playerHand.animation.play('scissors');
						default:
							playerPick = 1;
							playerHand.animation.play('rock');
					}
				}
			}

			if (FlxG.keys.justReleased.ENTER)
				go = true;
		}
		else
		{
			switch (playerLastPick)
			{
				case 1: // rock
					enemyHand.animation.play('paper');
				case 2: // paper
					enemyHand.animation.play('scissors');
				case 3: // scissors
					enemyHand.animation.play('rock');
			}

			playerLastPick = playerPick;
		}
	}
}
