package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	var playerHand:HandClass;
	var enemyHand:HandClass;

	public static var playerLastPick:Int = 0;

	var playerPick:Int = 0;
	var enemyPick:Int = 0;

	var go:Bool = false;
	var endingEventHappened:Bool = false;

	public static var score:Null<Int>;

	var scoreText:FlxText;

	var burstText:FlxText;

	public static var requestedBT:String = 'BEGIN!';

	override public function create()
	{
		if (score == null)
			score = 0;

		playerHand = new HandClass();
		add(playerHand);
		playerHand.screenCenter(Y);
		playerHand.x = FlxG.width - (playerHand.width * 4);

		enemyHand = new HandClass();
		add(enemyHand);
		enemyHand.flipX = true;
		enemyHand.screenCenter(Y);
		enemyHand.x = enemyHand.width * 4;

		scoreText = new FlxText(0, 0, 0, 'score: 0', 16);
		add(scoreText);
		scoreText.y = FlxG.height - (scoreText.height * 2);

		burstText = new FlxText(0, 0, 0, requestedBT, 16);
		burstText.y = burstText.height;
		burstText.alpha = 0;
		burstText.alpha = 1;
		FlxTween.tween(burstText, {alpha: 0}, 1.0, {
			ease: FlxEase.expoOut,
			onComplete: tween ->
			{
				burstText.destroy();
			}
		});

		burstText.screenCenter(X);
		add(burstText);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		scoreText.text = 'score: $score';
		scoreText.screenCenter(X);

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
			if (!endingEventHappened)
			{
				switch (playerLastPick)
				{
					case 1: // rock
						enemyPick = 2;
						enemyHand.animation.play('paper');
					case 2: // paper
						enemyPick = 3;
						enemyHand.animation.play('scissors');
					case 3: // scissors
						enemyHand.animation.play('rock');
						enemyPick = 1;
				}

				playerLastPick = playerPick;

				switch [playerPick, enemyPick]
				{
					case [1, 2], [2, 3], [3, 1]:
						score += FlxG.random.int(100, 300);

						requestedBT = 'PLAYER VICTORY!';
					case [2, 1], [3, 2], [1, 3]:
						// enemy wins
						requestedBT = 'ENEMY VICTORY!';
					case _:
						// tie.
						requestedBT = 'TIE!';
				}

				FlxTimer.wait(0.5, () ->
				{
					FlxG.switchState(() -> new PlayState());
				});

				endingEventHappened = true;
			}
		}
	}
}
