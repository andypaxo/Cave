package
{

	import org.flixel.*;

	public class PlayState extends FlxState
	{		
		override public function create():void
		{
			var tilemap:FlxTilemap = new World().getTilemap();
			add(tilemap);
			add(new Player());
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}

