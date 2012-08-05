package
{

	import org.flixel.*;

	public class PlayState extends FlxState
	{		
		private var tilemap:FlxTilemap;
		
		override public function create():void
		{
			var world:World = new World();
			tilemap = world.getTilemap();
			var player:Player = new Player();
			
			Global.world = world;
			Global.player = player;
			
			var worldBounds:FlxRect = tilemap.getBounds();
			player.x = worldBounds.width / 2;
			player.y = worldBounds.height / 2;
			while (tilemap.overlaps(player))
				player.y += 8;
			player.digAt = digAt;
			player.rockAt = rockAt;
			
			tilemap.follow(FlxG.camera);
			
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN_TIGHT);
			
			add(tilemap);
			add(player);
			player.createFX();
			
			for each (var mob:Mob in world.makeMobs())
				add(mob)
		}
		
		override public function update():void
		{
			super.update();
			FlxG.collide(tilemap, Global.player);
		}
		
		private function digAt(point:FlxPoint):void
		{
			tilemap.setTile(point.x / Global.tileSize, point.y / Global.tileSize, 0);
		}
		
		private function rockAt(point:FlxPoint):Boolean
		{
			return tilemap.getTile(point.x / Global.tileSize, point.y / Global.tileSize) > 0;
		}
	}
}

