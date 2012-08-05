package
{

	import org.flixel.*;

	public class PlayState extends FlxState
	{		
		private var tilemap:FlxTilemap;
		private var player:Player;
		private const tileWidth:int = 8;
		
		override public function create():void
		{
			var world:World = new World();
			tilemap = world.getTilemap();
			player = new Player();
			
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
			FlxG.collide(tilemap, player);
		}
		
		private function digAt(point:FlxPoint):void
		{
			tilemap.setTile(point.x / tileWidth, point.y / tileWidth, 0);
		}
		
		private function rockAt(point:FlxPoint):Boolean
		{
			return tilemap.getTile(point.x / tileWidth, point.y / tileWidth) > 0;
		}
	}
}

