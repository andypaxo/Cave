package  
{
	import org.flixel.*;
	import org.flixel.system.input.Keyboard;
	
	public class Player extends FlxSprite 
	{
		[Embed(source = 'data/player.png')]
		private var sprite:Class;
		
		private var diggingSpot:FlxPoint = new FlxPoint( -1, -1);
		private var diggingTimeRemaining:Number = 0;
		private const timeToDig:Number = 0.6;
		
		public var digAt:Function = new Function();
		
		public function Player() 
		{
			loadGraphic(sprite, true);
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
			var walkingSpeed:Number = 60;
			
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
			diggingSpot = new FlxPoint( -1, -1);
			diggingTimeRemaining = 0;
		}
		
		private function startDig():void {
			diggingSpot = getPointInFront();
			diggingTimeRemaining = timeToDig;
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