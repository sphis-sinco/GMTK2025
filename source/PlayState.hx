package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

using StringTools;

class PlayState extends FlxState
{
	var playerHand:HandClass;
	var enemyHand:HandClass;

	public static var playerLastPick:Move = null;
	public static var enemyLastPick:Move = null;

	var playerPick:Move = Rock;
	var enemyPick:Move = Rock;

	var go:Bool = false;
	var endingEventHappened:Bool = false;

	public static var score:Float;

	var scoreText:FlxText;
	var highscoreText:FlxText;

	var burstText:FlxText;

	public static var requestedBT:String;

	var shootBtn:GameplayButton;
	var backBtn:GameplayButton;

	override public function create()
	{
		// trace(Html5BS.scoreIncrease);

		#if !static
		if (score == null)
			score = 0;
		#end

		if (requestedBT == null)
			requestedBT = (FlxG.save.data.isNew == true) ? 'Tap the right hand to change your selection' : 'BEGIN!';

		playerHand = new HandClass();
		add(playerHand);
		playerHand.screenCenter(Y);
		playerHand.x = FlxG.width - (playerHand.width * 4);

		enemyHand = new HandClass();
		add(enemyHand);
		enemyHand.flipX = true;
		enemyHand.screenCenter(Y);
		enemyHand.x = enemyHand.width * 4;

		scoreText = new FlxText(0, 0, 0, 'score: 0', #if MOBILE_BUILD 64 #else 16 #end);
		add(scoreText);
		scoreText.y = FlxG.height - (scoreText.height * 2);

		highscoreText = new FlxText(0, 0, 0, 'highscore: 0', scoreText.size);
		add(highscoreText);
		highscoreText.y = scoreText.y + scoreText.height;

		burstText = new FlxText(0, 0, 0, requestedBT, #if MOBILE_BUILD (FlxG.save.data.isNew == true) ? 32 : 64 #else 16 #end);
		burstText.y = burstText.height / 2;
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

		shootBtn = new GameplayButton('shootBtn');
		add(shootBtn);

		backBtn = new GameplayButton('backBtn');
		add(backBtn);

		shootBtn.y -= shootBtn.height * 2;
		backBtn.y += backBtn.height * 2;

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.watch.addQuick('FlxG.save.data', FlxG.save.data);

		FlxG.watch.addQuick('score', score);

		FlxG.watch.addQuick('enemyPick', enemyPick);
		FlxG.watch.addQuick('enemyLastPick', enemyLastPick);
		FlxG.watch.addQuick('playerPick', playerPick);
		FlxG.watch.addQuick('playerLastPick', playerLastPick);

		scoreText.text = 'score: ${Std.int(score)}';
		highscoreText.text = 'highscore: ${Std.int(FlxG.save.data.score)}';
		scoreText.screenCenter(X);
		highscoreText.screenCenter(X);

		if (shootBtn.animation.finished || shootBtn.animation.name == 'pressed' && !FlxG.mouse.overlaps(shootBtn))
			shootBtn.animation.play('idle');
		if (backBtn.animation.finished || backBtn.animation.name == 'pressed' && !FlxG.mouse.overlaps(backBtn))
			backBtn.animation.play('idle');

		switch (playerPick)
		{
			case Rock:
				playerHand.animation.play('rock');
			case Paper:
				playerHand.animation.play('paper');
			case Scissors:
				playerHand.animation.play('scissors');
		}

		if (!go)
		{
			final playerHandRegion = (shootBtn.x + shootBtn.width) + (64 * 6);
			final enemyHandRegion = (shootBtn.x - shootBtn.width) - (64 * 6);

			final shootBtnRegion = shootBtn.y - (shootBtn.height * 2) - (32 * 2);
			final backBtnRegion = backBtn.y + (backBtn.height * 2) + (32 * 2);

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

			if (FlxG.mouse.overlaps(backBtn)
				|| (((FlxG.mouse.y > backBtnRegion && FlxG.mouse.y < shootBtnRegion)
					&& FlxG.mouse.x < enemyHandRegion
					&& !(FlxG.mouse.x < playerHandRegion))
					&& !FlxG.mouse.overlaps(playerHand)))
			{
				FlxG.watch.addQuick('Region', 'Back Button');
				if (FlxG.mouse.justReleased)
				{
					FlxG.switchState(() -> new DifficultyState());
					backBtn.animation.play('tapped');
				}
				else
				{
					backBtn.animation.play('pressed');
				}
			}
			else if (FlxG.mouse.overlaps(shootBtn)
				|| (((FlxG.mouse.y < shootBtnRegion && FlxG.mouse.y < backBtnRegion)
					&& FlxG.mouse.x < enemyHandRegion
					&& !(FlxG.mouse.x < playerHandRegion))
					&& !FlxG.mouse.overlaps(playerHand)))
			{
				FlxG.watch.addQuick('Region', 'Shoot Button');
				if (FlxG.mouse.justReleased)
				{
					go = true;
					shootBtn.animation.play('tapped');
				}
				else
				{
					shootBtn.animation.play('pressed');
				}
			}
			else if (!FlxG.mouse.overlaps(shootBtn) && (FlxG.mouse.overlaps(playerHand) || (FlxG.mouse.x > playerHandRegion)))
			{
				FlxG.watch.addQuick('Region', 'Player');

				switch (playerPick)
				{
					case Rock:
						playerHand.animation.play('selected-rock');
					case Paper:
						playerHand.animation.play('selected-paper');
					case Scissors:
						playerHand.animation.play('selected-scissors');
				}

				if (!FlxG.mouse.justReleased)
					return;

				switch (playerPick)
				{
					case Rock:
						playerPick = Paper;
					case Paper:
						playerPick = Scissors;
					case Scissors:
						playerPick = Rock;
				}
			}
			else
			{
				FlxG.watch.addQuick('Region', 'None');
			}

			if (FlxG.keys.justReleased.ENTER)
				go = true;
			else if (FlxG.keys.justReleased.ESCAPE)
				FlxG.switchState(() -> new DifficultyState());
		}
		else
		{
			if (!endingEventHappened)
			{
				var fp_min = 0;
				var fp_max = 100;

				switch (DifficultyState.diff)
				{
					case 1:
						fp_max = 25;
					case 3:
						fp_min = 75;
				}

				final followPlayer = FlxG.random.bool(FlxG.random.int(fp_min, fp_max));

				if (followPlayer && playerLastPick != null)
				{
					switch (playerLastPick)
					{
						case Rock:
							enemyPick = Paper;
						case Paper:
							enemyPick = Scissors;
						case Scissors:
							enemyPick = Rock;
					}
					if (DifficultyState.diff == 3)
					{
						if (enemyLastPick == null)
							return;

						switch (playerLastPick)
						{
							case Rock:
								if (enemyLastPick == Paper)
									enemyPick = Rock;
							case Paper:
								if (enemyLastPick == Scissors)
									enemyPick = Paper;
							case Scissors:
								if (enemyLastPick == Rock)
									enemyPick = Scissors;
						}
					}
				}
				else
				{
					if (FlxG.random.bool(1 / 2.5))
						return;

					if (DifficultyState.diff == 3)
					{
						switch (playerPick)
						{
							case Rock:
								enemyPick = Paper;
							case Paper:
								enemyPick = Scissors;
							case Scissors:
								enemyPick = Rock;
						}
					}
				}

				if (enemyPick == Rock)
					enemyHand.animation.play('rock');
				if (enemyPick == Paper)
					enemyHand.animation.play('paper');
				if (enemyPick == Scissors)
					enemyHand.animation.play('scissors');

				enemyLastPick = enemyPick;
				playerLastPick = playerPick;

				switch [playerPick, enemyPick]
				{
					case [Rock, Paper] | [Paper, Scissors] | [Scissors, Rock]:
						requestedBT = 'ENEMY VICTORY!';
						score -= FlxG.random.int(300, 100);
						FlxG.sound.play('assets/sfx/Fail.wav');

					case [Rock, Scissors] | [Paper, Rock] | [Scissors, Paper]:
						score += FlxG.random.int(100, 300);
						requestedBT = 'PLAYER VICTORY!';
						FlxG.sound.play('assets/sfx/Victory.wav');

					case _:
						requestedBT = 'TIE!';
						FlxG.sound.play('assets/sfx/Tie.wav');
				}

				if (score < 0)
					score = 0;
				if (score > FlxG.save.data.score)
					FlxG.save.data.score = score;

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
