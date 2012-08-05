package  
{
	import org.flixel.*;
	
	public class Mob extends FlxSprite 
	{
		[Embed(source = 'data/goblin.png')]
		private var sprite:Class;
		
		private const seekDistance:Number = 10 * Global.tileSize;
		private const attackDistance:Number = 1.5 * Global.tileSize;
		private const walkingSpeed:Number = 100;
		
		private var seekPlayer:Function;
		
		public function Mob(location:FlxPoint) 
		{
			super(location.x, location.y);
			loadGraphic(sprite, false, true);
			seekPlayer = Global.createCooldown(doSeekPlayer, this, 1).execute;
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
			
			if (pathSpeed == 0)
				stop();
			else
				facing = velocity.x > 0 ? RIGHT : LEFT;
				
		}
		
		private function doSeekPlayer():void 
		{
			var location:FlxPoint = getMidpoint();
			var playerLocation:FlxPoint = Global.player.getMidpoint();
			var path:FlxPath = Global.world.getTilemap().findPath(location, playerLocation);
			if (path != null)
				followPath(path, walkingSpeed);
		}
		
		private function stop():void 
		{
			stopFollowingPath(true);
			velocity = new FlxPoint();
		}
	}

}