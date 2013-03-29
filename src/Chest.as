package
{
	import org.flixel.*;

	public class Chest extends FlxSprite
	{
		[Embed(source = 'data/terrain.png')]
		private var terrainSprite:Class;

		private var open:Boolean = false;

		public function Chest (location:FlxPoint)
		{
			super(location.x, location.y);
			loadGraphic(terrainSprite, true);
			frame = 4;
		}

		public function touchedPlayer(player:Player):void
		{
			if (!open)
			{
				open = true;
				frame = 5;
				Global.addScore(new FlxPoint(x, y), 200 + Math.floor(Math.random() * 6) * 50)
			}
		}
	}
}