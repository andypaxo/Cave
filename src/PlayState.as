package
{
	import org.flixel.*;
	import items.*;

	public class PlayState extends FlxState implements PlayStage
	{		
		[Embed(source = 'data/ambient.mp3')]
		private var ambientSound:Class;
		
		[Embed(source = 'data/lamp.png')]
		private var lampSprite:Class;
		[Embed(source = 'data/fireball.png')]
		private var fireballSprite:Class;
		[Embed(source = 'data/iceball.png')]
		private var iceballSprite:Class;
		
		private var tilemap:FlxTilemap;
		private var floorDecals:FlxGroup;
		private var terrainItems:FlxGroup;
		private var mobs:FlxGroup;
		private var greatBallsOfFire:FlxGroup;
		private var unfriendlyFire:FlxGroup;
		public var sfx:FlxGroup;
		
		private var darkness:FlxSprite;
		private var fire:FlxSprite;
		private var ice:FlxSprite;
	
		override public function create():void
		{
			terrainItems = new FlxGroup();
			var world:World = new World(terrainItems);
			tilemap = world.getTilemap();

			Global.player = new Player();
			Global.world = world;
			
			var worldBounds:FlxRect = tilemap.getBounds();
			Global.player.x = worldBounds.width / 2;
			Global.player.y = worldBounds.height / 2;
			while (tilemap.overlaps(Global.player))
				Global.player.y += 8;
			Global.player.give(new RodOfFire());
			
			tilemap.follow(FlxG.camera);
			
			FlxG.camera.follow(Global.player, FlxCamera.STYLE_TOPDOWN_TIGHT);
			
			add(tilemap);
			add(terrainItems);
			floorDecals = new FlxGroup();
			add(floorDecals);
			
			add(Global.player);
			Global.player.createFX();
			
			mobs = world.makeMobs();
			add(mobs);
			
			darkness = new FlxSprite(0,0);
			darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
			add(darkness);
			fire = new FlxSprite(0, 0, fireballSprite);
			ice = new FlxSprite(0, 0, iceballSprite);
			
			add(new HealthBar());
			add(new ScoreBar());
			
			greatBallsOfFire = new FlxGroup();
			add(greatBallsOfFire);
			unfriendlyFire = new FlxGroup();
			add(unfriendlyFire);
			sfx = new FlxGroup();
			add(sfx);
			
			FlxG.playMusic(ambientSound);
		}
		
		override public function draw():void {
			darkness.fill(0xff000011);
			
			var lamp:FlxSprite = new FlxSprite(0, 0, lampSprite);
			var lampOffset:FlxPoint = Util.addPoints(
				Global.player.getScreenXY(),
				new FlxPoint(Global.player.width / 2, Global.player.height / 2));
			darkness.stamp(lamp, lampOffset.x - lamp.width / 2, lampOffset.y - lamp.height / 2);
			
			drawLights(greatBallsOfFire, fire);
			drawLights(unfriendlyFire, ice);
			
			var tilemapBounds:FlxRect = new FlxRect(
				FlxG.camera.scroll.x / Global.world.tileSize - 2,
				FlxG.camera.scroll.y / Global.world.tileSize - 2,
				FlxG.camera.width / Global.world.tileSize + 4,
				FlxG.camera.height / Global.world.tileSize + 4);

			var lightOffset:FlxPoint;
			for each (var x:uint in tilemap.getTileInstances(Global.gemTile))
			{
				var tilePosition:FlxPoint = new FlxPoint(x % tilemap.widthInTiles, Math.floor(x / tilemap.widthInTiles));
				if (Util.contains(tilemapBounds, tilePosition))
				{
					lightOffset = Util.addPoints(
						Util.scalePoint(tilePosition, Global.world.tileSize),
						Util.scalePoint(FlxG.camera.scroll, -1));
					lightOffset = Util.addPoints(lightOffset, new FlxPoint(5, 5));
					var fireSize:Number = fire.width;
					
					darkness.stamp(fire, lightOffset.x - fire.width / 2, lightOffset.y - fire.height / 2);
				}
			}
			
			super.draw();
		}

		private function drawLights(group:FlxGroup, sprite:FlxSprite):void
		{
			for each (var lightSource:FlxSprite in group.members)
			{
				var lightOffset:FlxPoint = Util.addPoints(
					lightSource.getScreenXY(),
					new FlxPoint(lightSource.width / 2, lightSource.height / 2));
				darkness.stamp(sprite, lightOffset.x - sprite.width / 2, lightOffset.y - sprite.height / 2);
			}
		}
		
		override public function update():void
		{
			super.update();
			Global.update();
			
			FlxG.collide(tilemap, Global.player);

			FlxG.collide(tilemap, mobs);
			FlxG.collide(mobs, mobs);
			
			if (greatBallsOfFire.length)
				FlxG.overlap(mobs, greatBallsOfFire, fireHitMob);
			if (unfriendlyFire.length)
				FlxG.overlap(Global.player, unfriendlyFire, fireHitPlayer);

			FlxG.overlap(terrainItems, Global.player, playerTouchedItem);
			
			cullGroup(greatBallsOfFire);
			cullGroup(unfriendlyFire);
		}
		
		private function fireHitMob(mob:Mob, fire:FlxSprite):void
		{
			mob.hurt(1);
			mob.knockBack(Global.player.getMidpoint());
			fire.kill();
			
			if (mob.health <= 0)
				mobs.remove(mob, true);
		}
		
		private function fireHitPlayer(player:Player, fire:FlxSprite):void
		{
			player.hurt(1);
			player.knockBack(fire.getMidpoint());
			fire.kill();
		}

		private function cullGroup(group:FlxGroup):void
		{
			for each (var fireball:FlxBasic in group.members)
				if (!fireball.alive)
					group.remove(fireball, true);
		}

		private function playerTouchedItem(item:FlxSprite, player:Player):void
		{
			if ('touchedPlayer' in item)
				item['touchedPlayer'](player);
		}
		
		public function digAt(point:FlxPoint):void
		{
			var pos:FlxPoint = Util.scalePoint(point, 1 / Global.tileSize);
			var tileType:uint = tilemap.getTile(pos.x, pos.y);
			
			if (tileType == Global.gemTile)
				Global.addScore(point, 100);
			
			tilemap.setTile(pos.x, pos.y, Global.floorTile);
		}
		
		public function rockAt(point:FlxPoint):uint
		{
			return tilemap.getTile(point.x / Global.tileSize, point.y / Global.tileSize);
		}
		
		public function addPlayerFire(fireball:FlxSprite):void
		{
			greatBallsOfFire.add(fireball);
		}
		
		public function addMobFire(fireball:FlxSprite):void
		{
			unfriendlyFire.add(fireball);
		}
		
		public function addFloorDecal(decal:FlxSprite):void
		{
			floorDecals.add(decal);
		}
	}
}

