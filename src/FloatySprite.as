package {
	import org.flixel.*;

	public class FloatySprite extends FlxSprite
	{
		private var timeToLive:Number = 0.5;

		public function FloatySprite(location:FlxPoint, graphic:Class)
		{
			super(location.x, location.y);
			loadGraphic(graphic);
			x -= width / 2;
			y -= height / 2;
		}
		
		override public function update():void 
		{
			super.update();
			var elapsed:Number = FlxG.elapsed;
			timeToLive -= elapsed;
			y -= elapsed * 30;
			alpha = timeToLive * 2;
			
			if (timeToLive < 0)
				kill();
		}
	}
}