package  
{
	import org.flixel.*;
	import org.flixel.system.input.Keyboard;
	import items.*;
	
	public class Player extends FlxSprite 
	{
		[Embed(source = 'data/player.png')]
		private var sprite:Class;
		[Embed(source = 'data/rock.png')]
		private var rockSprite:Class;
		[Embed(source = 'data/mess.png')]
		private var messSprite:Class;
		
		[Embed(source = 'data/death.mp3')]
		private var deathSound:Class;		
		[Embed(source = 'data/player-hurt.mp3')]
		private var hurtSound:Class;
		[Embed(source = 'data/dig.mp3')]
		private var digSound:Class;

		[Embed(source = 'data/get-heart.mp3')]
		private var heartSound:Class;

		private const walkingSpeed:Number = 60;
		public static const maxHealth:Number = 8;
		
		private var diggingSpot:FlxPoint = new FlxPoint( -1, -1);
		private var diggingTimeRemaining:Number = 0;
		private const timeToDig:Number = 0.4;
		private var rockEmitter:FlxEmitter = new FlxEmitter(0, 0, 5);
		private var controlLockout:Number = 0;
		
		public var fire:Function;
		public var fireCooldown:Cooldown;

		private var wielded:Weapon;
		
		public function Player() 
		{
			loadGraphic(sprite, true);
			
			rockEmitter.makeParticles(rockSprite, rockEmitter.maxSize, 0, false, 0);
			rockEmitter.setXSpeed( -30, 30);
			rockEmitter.setYSpeed( -30, 15);
			rockEmitter.gravity = 80;
			
			health = maxHealth;
			
			fireCooldown = Global.createCooldown(doFire, this, 0.5);
			fire = fireCooldown.execute;
		}
		
		public function createFX():void
		{
			FlxG.state.add(rockEmitter);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (FlxG.mouse.pressed())
				fire();

			if (lockedOut())
			{
				controlLockout -= FlxG.elapsed;
				if (!lockedOut())
					velocity = new FlxPoint();
			}
			else
			{
				walk();
				checkAction();
				updateGraphic();
			}
		}
		
		private function walk():void
		{
			if (FlxG.keys.UP || FlxG.keys.W)
			{
				velocity.y = -walkingSpeed;
				facing = UP;
			}
			else if (FlxG.keys.DOWN || FlxG.keys.S)
			{
				velocity.y = walkingSpeed;
				facing = DOWN;
			}
			else
			{
				velocity.y = 0;
			}
			
			if (FlxG.keys.LEFT || FlxG.keys.A)
			{
				velocity.x = -walkingSpeed;
				facing = LEFT;
			}
			else if (FlxG.keys.RIGHT || FlxG.keys.D)
			{
				velocity.x = walkingSpeed;
				facing = RIGHT;
			}
			else
			{
				velocity.x = 0;
			}
		}
		
		private function checkAction():void
		{
			if (FlxG.keys.SPACE || FlxG.keys.CONTROL)
				digOrFire();
			else
				stopDig();
		}
		
		private function digOrFire():void
		{
			var pointToTryDigging:FlxPoint = getPointInFront();
			var tileType:uint = Global.playStage.rockAt(pointToTryDigging);
			switch (tileType) {
				case Global.rockTile:
				case Global.rockTile2:
				case Global.gemTile:
				case Global.wallTile:
				case Global.wallTile2:
					dig();
					break;
			}
		}
		
		private function dig():void
		{
			if (diggingTimeRemaining > 0)
				continueDig();
			else
				startDig();
		}
		
		private function stopDig():void
		{
			if (diggingTimeRemaining == 0)
				return;
				
			diggingSpot = new FlxPoint( -1, -1);
			diggingTimeRemaining = 0;
			
			rockEmitter.on = false;
		}
		
		private function startDig():void {			
			diggingSpot = getPointInFront();
			diggingTimeRemaining = timeToDig;
			
			rockEmitter.x = diggingSpot.x;
			rockEmitter.y = diggingSpot.y;
			rockEmitter.start(false, 0.3, 0.1);
			FlxG.play(digSound, 0.2);
		}
		
		private function continueDig():void {
			diggingTimeRemaining -= FlxG.elapsed;
			if (diggingTimeRemaining <= 0)
			{
				Global.playStage.digAt(diggingSpot);
				stopDig();
				fireCooldown.reset();
			}
		}
		
		private function doFire():void
		{
			wielded.fireFrom(this);
		}
		
		private function updateGraphic():void
		{
			switch (facing) 
			{
				case UP:
					frame = 3;
					break;
				case DOWN:
					frame = 1;
					break;
				case LEFT:
					frame = 2;
					break;
				case RIGHT:
					frame = 0;
					break;
			}
		}
		
		private function getPointInFront():FlxPoint
		{
			var facingPoint:FlxPoint = Util.scalePoint(facingToPoint(), width);
			return Util.addPoints(this.getMidpoint(), facingPoint);
		}
		
		private function facingToPoint():FlxPoint
		{
			return new FlxPoint(
				facing == LEFT ? -1 : facing == RIGHT ? 1 : 0,
				facing == UP ? -1 : facing == DOWN ? 1 : 0);
		}
		
		override public function hurt(Damage:Number):void 
		{
			if (Damage > 0)
				hurtme(Damage);
			else if (Damage < 0)
				healme(Damage);
		}

		private function hurtme(Damage:Number):void
		{
			if (!lockedOut())
			{
				super.hurt(Damage);
				FlxG.state.add(new Owie(x, y));
				FlxG.play(hurtSound, 0.2);
			}
		}

		private function healme(Damage:Number):void
		{
			super.hurt(Damage);
			FlxG.play(heartSound, 0.2);
		}
		
		override public function kill():void 
		{
			super.kill();
			FlxG.fade(0, 3, function():void { FlxG.switchState(new MenuState()); } );
			Global.spatter(this);
			FlxG.play(deathSound, 0.4);
		}
		
		public function isDead():Boolean
		{
			return health <= 0;
		}
		
		public function knockBack(from:FlxPoint):void
		{
			velocity = Util.normalize(Util.subtract(getMidpoint(), from), 150);
			controlLockout = 0.2;
			flicker(0.2);
		}
		
		private function lockedOut():Boolean
		{
			return controlLockout > 0;
		}

		public function give(weapon:Weapon):void
		{
			this.wielded = weapon;
		}
	}

}