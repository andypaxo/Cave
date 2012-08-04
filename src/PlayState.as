package
{

	import org.flixel.*;

	public class PlayState extends FlxState
	{		
		private var tilemap:FlxTilemap;
		private var player:Player;
		
		override public function create():void
		{
			tilemap = new World().getTilemap();
			player = new Player();
			
			var worldBounds:FlxRect = tilemap.getBounds();
			player.x = worldBounds.width / 2;
			player.y = worldBounds.height / 2;
			
			tilemap.follow(FlxG.camera);
			
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN_TIGHT);
			
			add(tilemap);
			add(player);
		}
		
		override public function update():void
		{
			super.update();
			FlxG.collide(tilemap, player);
		}
	}
}

