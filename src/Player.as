package  
{
	import org.flixel.*;
	import org.flixel.system.input.Keyboard;
	
	public class Player extends FlxSprite 
	{
		[Embed(source = 'data/player.png')]
		private var sprite:Class;
		
		public function Player() 
		{
			loadGraphic(sprite, true);
		}
		
		override public function update():void 
		{
			super.update();
			
			var kb:Keyboard = FlxG.keys;
			var walkingSpeed:Number = 40;
			
			if (kb.UP)
			{
				velocity.y = -walkingSpeed;
				facing = UP;
			}
			else if (kb.DOWN)
			{
				velocity.y = walkingSpeed;
				facing = DOWN;
			}
			else
			{
				velocity.y = 0;
			}
			
			if (kb.LEFT)
			{
				velocity.x = -walkingSpeed;
				facing = LEFT;
			}
			else if (kb.RIGHT)
			{
				velocity.x = walkingSpeed;
				facing = RIGHT;
			}
			else
			{
				velocity.x = 0;
			}
		}
	}

}