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

	public static var playerLastPick:Move = Rock;

	var playerPick:Move = Rock;
	var enemyPick:Move = Rock;

	var go:Bool = false;
	var endingEventHappened:Bool = false;

	public static var score:Null<Float>;

	var scoreText:FlxText;

	var burstText:FlxText;

	public static var requestedBT:String;

	public static var scoreIncrease:Float;

	override public function create()
	{
		if (score == null)
		{
			score = 0;
			if (FlxG.save.data.score != null)
				score = FlxG.save.data.score;
		}
		if (requestedBT == null)
		{
			requestedBT = (FlxG.save.data.isNew == true) ? 'BEGIN!\n\nTap the right hand to change your selection' : 'BEGIN!';
		}

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
		FlxTween.tween(burstText, {alpha: 0}, (FlxG.save.data.isNew == true) ? 16.0 : 4.0, {
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

		FlxG.watch.addQuick('FlxG.save.data', FlxG.save.data);

		FlxG.watch.addQuick('score', score);
		FlxG.watch.addQuick('scoreIncrease', scoreIncrease);

		FlxG.watch.addQuick('enemyPick', enemyPick);
		FlxG.watch.addQuick('playerPick', playerPick);
		FlxG.watch.addQuick('playerLastPick', playerLastPick);

		scoreText.text = 'score: ${Std.int(score)}';
		scoreText.screenCenter(X);

		scoreIncrease = FlxMath.roundDecimal(scoreIncrease, 0);
		if (Std.int(scoreIncrease) != 0)
		{
			// TODO: fix lerping when not doing / 1

			final incAmount = FlxMath.roundDecimal(((score + scoreIncrease) - score) / 1, 0);
			FlxG.watch.addQuick('incAmount', incAmount);

			score += incAmount;
			scoreIncrease -= incAmount;
			FlxG.save.data.score = score;
		}

		if (!go)
		{
			final enemyPickInt = FlxG.random.int(1, 3);

			switch (enemyPickInt)
			{
				case 1:
					enemyPick = Rock;
					enemyHand.animation.play('rock');
				case 2:
					enemyPick = Paper;
					enemyHand.animation.play('paper');
				case 3:
					enemyPick = Scissors;
					enemyHand.animation.play('scissors');
			}

			if (FlxG.mouse.overlaps(playerHand))
			{
				if (FlxG.mouse.justReleased)
				{
					switch (playerHand.animation.name.toLowerCase())
					{
						case 'rock':
							playerPick = Paper;
							playerHand.animation.play('paper');
						case 'paper':
							playerPick = Scissors;
							playerHand.animation.play('scissors');
						default:
							playerPick = Rock;
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
				final followPlayer = FlxG.random.bool(FlxG.random.int(0, 100));

				if (followPlayer)
				{
					if (playerLastPick == Rock)
						enemyPick = Paper;
					if (playerLastPick == Paper)
						enemyPick = Scissors;
					if (playerLastPick == Scissors)
						enemyPick = Rock;
				}

				if (enemyPick == Rock)
				{
					enemyHand.animation.play('rock');
				}
				if (enemyPick == Paper)
				{
					enemyHand.animation.play('paper');
				}
				if (enemyPick == Scissors)
				{
					enemyHand.animation.play('scissors');
				}

				playerLastPick = playerPick;

				switch [playerPick, enemyPick]
				{
					case [Rock, Paper] | [Paper, Scissors] | [Scissors, Rock]:
						requestedBT = 'ENEMY VICTORY!';
						scoreIncrease -= FlxG.random.int(100, 300);
						if (score + scoreIncrease < 0)
							scoreIncrease += (score - scoreIncrease);
						FlxG.sound.play('assets/sfx/Fail.wav');

					case [Rock, Scissors] | [Paper, Rock] | [Scissors, Paper]:
						scoreIncrease += FlxG.random.int(100, 300);
						requestedBT = 'PLAYER VICTORY!';
						FlxG.sound.play('assets/sfx/Victory.wav');

					case _:
						requestedBT = 'TIE!';
						FlxG.sound.play('assets/sfx/Tie.wav');
				}

				trace('result: $requestedBT');
				endingEventHappened = true;
			}

			FlxTimer.wait(0.5, () ->
			{
				FlxG.switchState(() -> new PlayState());
			});
		}
	}
}

enum Move
{
	Rock;
	Paper;
	Scissors;
}
