package mobs
{
	import org.flixel.*

	public class Boss extends Mob
	{
		[Embed(source = '../data/boss.png')]
		private var sprite:Class;
		[Embed(source = '../data/ice-attack.png')]
		private var iceball:Class;

		public function Boss(location:FlxPoint,graphic:Class=null) 
		{
			super(location, sprite);
			attackSpeed = 1.2;
			setup();
			attackDistance = 6.1 * Global.tileSize;
			health = 20;
			level = 19;
		}

		protected override function shouldStop():Boolean
		{
			return pathSpeed == 0 || getDistanceFromPlayer() < attackDistance;
		}
		
		protected override function doAttackPlayer():void
		{
			if (Global.player.isDead())
				return;


			var playerLocation:FlxPoint = Global.player.getMidpoint();
			for (var i:int = 0; i < 3; i++)
				throwFireballAt(playerLocation);
		}

		private function throwFireballAt(point:FlxPoint):void
		{
			var variance:Number = 60;
			var offset:FlxPoint = new FlxPoint(
				Math.random() * variance * 2 - variance,
				Math.random() * variance * 2 - variance);
			var target:FlxPoint = Util.addPoints(point, offset);
			var fireball:FlxSprite = new Owie(0, 0, iceball, 1)
				.from(getMidpoint())
				.to(target, 45);
			Global.playStage.addMobFire(fireball);
		}
	}
}