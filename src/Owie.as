package  
{
	import org.flixel.*;
	
	public class Owie extends FlxSprite
	{
		[Embed(source = 'data/owie.png')]
		private var sprite:Class;

		private var end:Cooldown;
		private var following:FlxSprite;
		private var followOffset:FlxPoint;
		public var damage:Number = 1;
		public var killOnContact:Boolean = true;
		
		public function Owie(x:Number = 0, y:Number = 0, graphic:Class = null, lifetime:Number = 0.5) 
		{
			super(x, y);
			loadGraphic(graphic || sprite, true);
			if (!graphic)
			{
				addAnimation('default', [0, 1, 2, 3], 30);
				play('default');
			}
			end = Global.createCooldown(kill, this, lifetime);
			end.reset();
		}

        public function from(start:FlxPoint):Owie {
        	x = start.x - width/2;
        	y = start.y - height/2;
        	return this;
        }

        public function to(dest:FlxPoint, speed:Number = 150):Owie {
            velocity = Util.normalize(Util.subtract(dest, getMidpoint()), speed);
        	return this;
        }

        public function follow(subject:FlxSprite):Owie {
        	following = subject;
        	followOffset = new FlxPoint(x - subject.x, y - subject.y);
        	return this;
        }
		
		override public function update():void 
		{
			super.update();
			if (following)
			{
				x = following.x + followOffset.x;
				y = following.y + followOffset.y;
			}
			end.execute();
		}
		
		override public function kill():void 
		{
			super.kill();
			Global.removeCooldown(end);
		}
	}

}