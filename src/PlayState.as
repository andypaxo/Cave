package
{

	import org.flixel.*;

	public class PlayState extends FlxState implements PlayStage
	{		
		private var tilemap:FlxTilemap;
		private var mobs:FlxGroup;
		private var greatBallsOfFire:FlxGroup;
		
		override public function create():void
		{
			var world:World = new World();
			tilemap = world.getTilemap();
			var player:Player = new Player(this);
			
			Global.world = world;
			Global.player = player;
			
			var worldBounds:FlxRect = tilemap.getBounds();
			player.x = worldBounds.width / 2;
			player.y = worldBounds.height / 2;
			while (tilemap.overlaps(player))
				player.y += 8;
			
			tilemap.follow(FlxG.camera);
			
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN_TIGHT);
			
			add(tilemap);
			add(player);
			player.createFX();
			
			mobs = world.makeMobs();
			add(mobs);
			
			add(new HealthBar());
			
			greatBallsOfFire = new FlxGroup();
			add(greatBallsOfFire);
			
			FlxG.mouse.hide();
		}
		
		override public function update():void
		{
			super.update();
			Global.update();
			
			FlxG.collide(tilemap, Global.player);
			FlxG.collide(tilemap, mobs);
			FlxG.collide(mobs);
			FlxG.overlap(mobs, greatBallsOfFire, fireHitMob);
		}
		
		private function fireHitMob(mob:Mob, fire:FlxSprite):void
		{
			mob.hurt(1);
			mob.knockBack(Global.player.getMidpoint());
			fire.kill();
		}
		
		public function digAt(point:FlxPoint):void
		{
			tilemap.setTile(point.x / Global.tileSize, point.y / Global.tileSize, 0);
		}
		
		public function rockAt(point:FlxPoint):uint
		{
			return tilemap.getTile(point.x / Global.tileSize, point.y / Global.tileSize);
		}
		
		public function addPlayerFire(fireball:FlxSprite):void
		{
			greatBallsOfFire.add(fireball);
		}
	}
}

