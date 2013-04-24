package
{
	import org.flixel.*;

	public class Hole extends FlxSprite
	{
		[Embed(source = 'data/hole.png')]
		private var sprite:Class;

		public function Hole(location:FlxPoint)
		{
			super(location.x, location.y);
			loadGraphic(sprite);
		}

		public function touchedPlayer(player:Player):void
		{
			Global.changeLevel();
		}
	}
}