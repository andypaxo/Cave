package
{

	import org.flixel.*;

	public class PlayState extends FlxState implements PlayStage
	{		
		[Embed(source = 'data/ambient.mp3')]
		private var ambientSound:Class;
		
		[Embed(source = 'data/lamp.png')]
		private var lampSprite:Class;
		[Embed(source = 'data/fireball.png')]
		private var fireballSprite:Class;
		
		private var tilemap:FlxTilemap;
		private var floorDecals:FlxGroup;
		private var mobs:FlxGroup;
		private var greatBallsOfFire:FlxGroup;
		
		private var darkness:FlxSprite;
		private var fire:FlxSprite;
	
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
			floorDecals = new FlxGroup();
			add(floorDecals);
			
			add(player);
			player.createFX();
			
			mobs = world.makeMobs();
			add(mobs);
			
			darkness = new FlxSprite(0,0);
			darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
			add(darkness);
			fire = new FlxSprite(0, 0, fireballSprite);
			
			add(new HealthBar());
			
			greatBallsOfFire = new FlxGroup();
			add(greatBallsOfFire);
			
			FlxG.mouse.hide();
			FlxG.playMusic(ambientSound);
		}
		
		override public function draw():void {
			darkness.fill(0xff000011);
			
			var lamp:FlxSprite = new FlxSprite(0, 0, lampSprite);
			var lampOffset:FlxPoint = Util.addPoints(
				Global.player.getScreenXY(),
				new FlxPoint(Global.player.width / 2, Global.player.height / 2));
			darkness.stamp(lamp, lampOffset.x - lamp.width / 2, lampOffset.y - lamp.height / 2);
			
			for each (var fireball:FlxSprite in greatBallsOfFire.members)
			{
				var fireOffset:FlxPoint = Util.addPoints(
					fireball.getScreenXY(),
					new FlxPoint(fireball.width / 2, fireball.height / 2));
				darkness.stamp(fire, fireOffset.x - fire.width / 2, fireOffset.y - fire.height / 2);
			}
			
			for each (var x:uint in tilemap.getTileInstances(2))
			{
				fireOffset = Util.addPoints(
					Util.scalePoint(new FlxPoint(x % tilemap.widthInTiles, Math.floor(x / tilemap.widthInTiles)), Global.world.tileSize),
					Util.scalePoint(FlxG.camera.scroll, -1));
				fireOffset = Util.addPoints(fireOffset, new FlxPoint(5, 5));
				var fireSize:Number = fire.width;
				
				if (fireOffset.x > -fireSize && fireOffset.x < FlxG.width + fireSize &&
					fireOffset.y > -fireSize && fireOffset.y < FlxG.height + fireSize)
				{
					darkness.stamp(fire, fireOffset.x - fire.width / 2, fireOffset.y - fire.height / 2);
					trace('Torch at ' + fireOffset.x + ', ' + fireOffset.y);
				}
			}
			
			super.draw();
		}
		
		override public function update():void
		{
			super.update();
			Global.update();
			
			FlxG.collide(tilemap, Global.player);
			FlxG.collide(tilemap, mobs);
			FlxG.collide(mobs);
			FlxG.overlap(mobs, greatBallsOfFire, fireHitMob);
			
			for each (var fireball:FlxBasic in greatBallsOfFire.members)
				if (!fireball.alive)
					greatBallsOfFire.remove(fireball, true);
		}
		
		private function fireHitMob(mob:Mob, fire:FlxSprite):void
		{
			mob.hurt(1);
			mob.knockBack(Global.player.getMidpoint());
			fire.kill();
			
			if (mob.health <= 0)
				mobs.remove(mob, true);
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
		
		public function addFloorDecal(decal:FlxSprite):void
		{
			floorDecals.add(decal);
		}
	}
}

