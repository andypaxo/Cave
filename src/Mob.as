package  
{
	import org.flixel.*;
	
	public class Mob extends FlxSprite 
	{
		[Embed(source = 'data/goblin.png')]
		private var sprite:Class;
		
		[Embed(source = 'data/mob-hurt.mp3')]
		private var hurtSound:Class;
		[Embed(source = 'data/mob-alert-1.mp3')]
		private var alertSound1:Class;
		[Embed(source = 'data/mob-alert-2.mp3')]
		private var alertSound2:Class;
		[Embed(source = 'data/mob-alert-3.mp3')]
		private var alertSound3:Class;
		private var sounds:Array;
		
		private const startSeekDistance:Number = 10 * Global.tileSize;
		private const endSeekDistance:Number = 20 * Global.tileSize;
		private const attackDistance:Number = 1.1 * Global.tileSize;
		private const walkingSpeed:Number = 70;
		private const attackStrength:Number = 1;
		
		private var controlLockout:Number = 0;
		
		private var isSeeking:Boolean;
		private var seekPlayer:Function;
		private var attackPlayer:Function;
		
		public function Mob(location:FlxPoint) 
		{
			super(location.x, location.y);
			loadGraphic(sprite, true, true);
			seekPlayer = Global.createCooldown(doSeekPlayer, this, 1).execute;
			attackPlayer = Global.createCooldown(doAttackPlayer, this, 2).execute;
			
			frame = Math.floor(Math.random() * frames);
			health = Math.floor(2 + frame);
			sounds = [alertSound1, alertSound2, alertSound3];
		}
		
		override public function update():void 
		{
			super.update();
			
			if (lockedOut())
			{
				controlLockout -= FlxG.elapsed;
				if (!lockedOut())
					stop();
			}
			else
			{
				moveAndAttack();
			}
		}
		
		private function moveAndAttack():void 
		{
			var location:FlxPoint = getMidpoint();
			var playerLocation:FlxPoint = Global.player.getMidpoint();
			var distanceToPlayer:Number = FlxU.getDistance(location, playerLocation);
			
			var wasSeeking:Boolean = isSeeking;
			isSeeking =
				distanceToPlayer > attackDistance &&
				(distanceToPlayer < startSeekDistance ||
				isSeeking && distanceToPlayer < endSeekDistance);
			
			if (!wasSeeking && isSeeking)
				FlxG.play(Class(Util.randomItemFrom(sounds)), 0.3);
				
			if (isSeeking)
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
				FlxG.play(hurtSound, 0.2);
			}
		}
		override public function kill():void 
		{
			super.kill();
			Global.spatter(this);
		}
		
		public function knockBack(from:FlxPoint):void
		{
			stop();
			velocity = Util.normalize(Util.subtract(getMidpoint(), from), 150);
			controlLockout = 0.2;
			flicker(0.2);
		}
		
		private function lockedOut():Boolean
		{
			return controlLockout > 0;
		}
	}

}