package
{
	import org.flixel.*;

	public class Chest extends FlxSprite
	{
		[Embed(source = 'data/chest.png')]
		private var chestSprite:Class;

		[Embed(source = 'data/chest.mp3')]
		private var chestSound:Class;

		private var open:Boolean = false;

		public function Chest (location:FlxPoint)
		{
			super(location.x, location.y);
			loadGraphic(chestSprite, true);
			frame = 0;
		}

		public function touchedPlayer(player:Player):void
		{
			if (!open)
			{
				open = true;
				frame = 1;
				Global.addScore(new FlxPoint(x, y), 200 + Math.floor(Math.random() * 6) * 50);
				FlxG.play(chestSound, 0.3);
			}
		}
	}
}