package  
{
	import org.flixel.*;
	
	public class Owie extends FlxSprite
	{
		[Embed(source = 'data/owie.png')]
		private var sprite:Class;
		
		private var end:Cooldown;
		
		public function Owie(x:Number = 0, y:Number = 0) 
		{
			super(x, y);
			loadGraphic(sprite, true);
			addAnimation('default', [0, 1, 2, 3], 30);
			play('default');
			end = Global.createCooldown(kill, this, 0.5);
			end.reset();
		}

        public function from(start:FlxPoint):Owie {
        	x = start.x - width/2;
        	y = start.y - height/2;
        	return this;
        }

        public function to(dest:FlxPoint):Owie {
            velocity = Util.normalize(Util.subtract(dest, getMidpoint()), 150);
        	return this;
        }
		
		override public function update():void 
		{
			super.update();
			end.execute();
		}
		
		override public function kill():void 
		{
			super.kill();
			Global.removeCooldown(end);
		}
	}

}