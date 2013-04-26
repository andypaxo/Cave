package mobs
{
	import org.flixel.*;
	
	public class Mob extends FlxSprite 
	{	
		[Embed(source = '../data/mob-hurt.mp3')]
		private var hurtSound:Class;
		[Embed(source = '../data/mob-alert-1.mp3')]
		private var alertSound1:Class;
		[Embed(source = '../data/mob-alert-2.mp3')]
		private var alertSound2:Class;
		[Embed(source = '../data/mob-alert-3.mp3')]
		private var alertSound3:Class;
		private var sounds:Array;
		
		private const startSeekDistance:Number = 10 * Global.tileSize;
		private const endSeekDistance:Number = 20 * Global.tileSize;
		protected var attackDistance:Number = 1.1 * Global.tileSize;
		private const walkingSpeed:Number = 70;
		private const attackStrength:Number = 1;
		
		protected var level:int;
		
		private var controlLockout:Number = 0;
		
		private var isSeeking:Boolean;
		private var seekPlayer:Function;
		private var attackPlayer:Function;
		protected var attackSpeed:Number = 2;
		
		public function Mob(location:FlxPoint,graphic:Class=null) 
		{
			super(location.x, location.y);
			loadGraphic(graphic, true, true);
		}

		protected function setup():void
		{
			seekPlayer = Global.createCooldown(doSeekPlayer, this, 1).execute;
			attackPlayer = Global.createCooldown(doAttackPlayer, this, attackSpeed).execute;
			
			frame = Math.floor(Math.random() * (frames + 1));
			level = frame;
			health = 1 + level;
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
			var distanceToPlayer:Number = getDistanceFromPlayer();
			
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
			
			if (shouldStop())
				stop();
			else
				facing = velocity.x > 0 ? RIGHT : LEFT;
		}

		protected function getDistanceFromPlayer():Number
		{
			var location:FlxPoint = getMidpoint();
			var playerLocation:FlxPoint = Global.player.getMidpoint();
			return FlxU.getDistance(location, playerLocation)
		}

		protected function shouldStop():Boolean
		{
			return pathSpeed == 0;
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
		
		protected function doAttackPlayer():void
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
			Global.addScore(getMidpoint(), 50 + level * 10);
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