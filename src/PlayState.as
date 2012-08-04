package
{

	import org.flixel.*;

	public class PlayState extends FlxState
	{		
		override public function create():void
		{
			var tilemap:FlxTilemap = new World().getTilemap();
			var worldBounds:FlxRect = tilemap.getBounds();
			var player:Player = new Player();
			player.x = worldBounds.width / 2;
			player.y = worldBounds.height / 2;
			
			add(tilemap);
			add(player);
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN_TIGHT);
			FlxG.camera.bounds = worldBounds;
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}

