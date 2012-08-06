package  
{
	import flash.text.TextFormatAlign;
	import org.flixel.*;
	
	public class ScoreWidget extends FlxText 
	{
		private var timeToLive:Number = 0.5;
		
		public function ScoreWidget(location:FlxPoint, score:int) 
		{
			super(location.x - 50, location.y - 16, 100, score.toString());
			alignment = TextFormatAlign.CENTER;
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