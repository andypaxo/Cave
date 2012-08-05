package  
{
	import org.flixel.*;
	
	public class Mob extends FlxSprite 
	{
		[Embed(source = 'data/goblin.png')]
		private var sprite:Class;
		
		private const seekDistance:Number = 10 * Global.tileSize;
		private const attackDistance:Number = 2 * Global.tileSize;
		private var doneSeek:Boolean = false;
		
		public function Mob(location:FlxPoint) 
		{
			super(location.x, location.y, sprite);
		}
		
		override public function update():void 
		{
			super.update();
			
			var location:FlxPoint = getMidpoint();
			var playerLocation:FlxPoint = Global.player.getMidpoint();
			var distanceToPlayer:Number = FlxU.getDistance(location, playerLocation);
			
			if (distanceToPlayer < seekDistance && distanceToPlayer > attackDistance)
			{
				if (!doneSeek) {
					var path:FlxPath = Global.world.getTilemap().findPath(location, playerLocation);
					if (path != null)
					{
						doneSeek = true;
						followPath(path);
					}
				}
			}
			else
			{
				stopFollowingPath(true);
				velocity = new FlxPoint();
			}
		}
	}

}