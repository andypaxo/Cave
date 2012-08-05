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
			while (tilemap.overlaps(player))
				player.y += 8;
			player.digAt = digAt;
			
			tilemap.follow(FlxG.camera);
			
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN_TIGHT);
			
			add(tilemap);
			add(player);
			player.createFX();
		}
		
		override public function update():void
		{
			super.update();
			FlxG.collide(tilemap, player);
		}
		
		private function digAt(point:FlxPoint):void {
			var tileWidth:int = 8;
			tilemap.setTile(point.x / tileWidth, point.y / tileWidth, 0);
		}
	}
}

