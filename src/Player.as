package  
{
	import org.flixel.*;
	import org.flixel.system.input.Keyboard;
	
	public class Player extends FlxSprite 
	{
		[Embed(source = 'data/player.png')]
		private var sprite:Class;
		[Embed(source = 'data/rock.png')]
		private var rockSprite:Class;
		
		private const walkingSpeed:Number = 60;
		
		private var diggingSpot:FlxPoint = new FlxPoint( -1, -1);
		private var diggingTimeRemaining:Number = 0;
		private const timeToDig:Number = 0.4;
		private var rockEmitter:FlxEmitter = new FlxEmitter(0,0,5);
		
		public var digAt:Function = new Function();
		public var rockAt:Function = new Function();
		
		public function Player() 
		{
			loadGraphic(sprite, true);
			
			rockEmitter.makeParticles(rockSprite, rockEmitter.maxSize, 0, false, 0);
			rockEmitter.setXSpeed( -30, 30);
			rockEmitter.setYSpeed( -30, 15);
			rockEmitter.gravity = 80;
		}
		
		public function createFX():void
		{
			FlxG.state.add(rockEmitter);
		}
		
		override public function update():void 
		{
			super.update();
			walk();
			checkDig();
			updateGraphic();
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
		
		private function checkDig():void
		{
			if (FlxG.keys.SPACE)
				dig();
			else
				stopDig();
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
			var pointToTryDigging:FlxPoint = getPointInFront();
			if (!rockAt(pointToTryDigging))
				return;
			
			diggingSpot = pointToTryDigging;
			diggingTimeRemaining = timeToDig;
			
			rockEmitter.x = diggingSpot.x;
			rockEmitter.y = diggingSpot.y;
			rockEmitter.start(false, 0.3, 0.1);
		}
		
		private function continueDig():void {
			diggingTimeRemaining -= FlxG.elapsed;
			if (diggingTimeRemaining <= 0)
			{
				digAt(diggingSpot);
				stopDig();
			}
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
			var facingPoint:FlxPoint = new FlxPoint(
				facing == LEFT ? -width : facing == RIGHT ? width : 0,
				facing == UP ? -height : facing == DOWN ? height : 0);
			return Util.addPoints(this.getMidpoint(), facingPoint);
		}
	}

}