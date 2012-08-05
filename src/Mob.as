package  
{
	import org.flixel.*;
	
	public class Mob extends FlxSprite 
	{
		[Embed(source = 'data/goblin.png')]
		private var sprite:Class;
		
		private const seekDistance:Number = 10 * Global.tileSize;
		private const attackDistance:Number = 1.1 * Global.tileSize;
		private const walkingSpeed:Number = 100;
		private const attackStrength:Number = 1;
		
		private var seekPlayer:Function;
		private var attackPlayer:Function;
		
		public function Mob(location:FlxPoint) 
		{
			super(location.x, location.y);
			loadGraphic(sprite, false, true);
			seekPlayer = Global.createCooldown(doSeekPlayer, this, 1).execute;
			attackPlayer = Global.createCooldown(doAttackPlayer, this, 2).execute;
			health = 4;
		}
		
		override public function update():void 
		{
			super.update();
			
			var location:FlxPoint = getMidpoint();
			var playerLocation:FlxPoint = Global.player.getMidpoint();
			var distanceToPlayer:Number = FlxU.getDistance(location, playerLocation);
			
			if (distanceToPlayer < seekDistance && distanceToPlayer > attackDistance)
				seekPlayer();
			else
				stop();
				
			if (distanceToPlayer < attackDistance)
				attackPlayer();
			
			if (pathSpeed == 0)
				stop();
			else
				facing = velocity.x > 0 ? RIGHT : LEFT;
				
		}
		
		private function doSeekPlayer():void 
		{
			if (Global.player.isDead())
				return;
			
			var location:FlxPoint = getMidpoint();
			var playerLocation:FlxPoint = Global.player.getMidpoint();
			var path:FlxPath = Global.world.getTilemap().findPath(location, playerLocation);
			if (path != null)
				followPath(path, walkingSpeed);
		}
		
		private function doAttackPlayer():void
		{
			if (Global.player.isDead())
				return;
			Global.player.hurt(attackStrength);
			Global.player.knockBack(getMidpoint());
		}
		
		private function stop():void 
		{
			stopFollowingPath(true);
			velocity = new FlxPoint();
		}
		
		override public function hurt(Damage:Number):void 
		{
			if (!lockedOut())
			{
				super.hurt(Damage);
				FlxG.state.add(new Owie(x, y));
			}
		}
		override public function kill():void 
		{
			super.kill();
			FlxG.state.add(new Mess(x, y));
		}
		
		private function lockedOut():Boolean
		{
			//return controlLockout > 0;
			return false;
		}
	}

}