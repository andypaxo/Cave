package mobs
{
	import org.flixel.*

	public class Mage extends Mob
	{
		[Embed(source = '../data/mage.png')]
		private var sprite:Class;
		[Embed(source = '../data/ice-attack.png')]
		private var iceball:Class;

		public function Mage(location:FlxPoint) 
		{
			super(location, sprite);
			attackDistance = 6.1 * Global.tileSize;
		}

		protected override function shouldStop():Boolean
		{
			return pathSpeed == 0 || getDistanceFromPlayer() < attackDistance;
		}
		
		protected override function doAttackPlayer():void
		{
			if (Global.player.isDead())
				return;

			var fireball:FlxSprite = new Owie(0, 0, iceball, 1)
				.from(getMidpoint())
				.to(Global.player.getMidpoint(), 75);
			Global.playStage.addMobFire(fireball);
		}
	}
}