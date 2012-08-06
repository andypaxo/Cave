package  
{
	import org.flixel.*;
	
	public class ScoreBar extends FlxText
	{
		
		public function ScoreBar() 
		{
			super(2, FlxG.height - 16, 150, 'Nil');
			scrollFactor = new FlxPoint();
		}
		
		override public function update():void 
		{
			super.update();
			text = FlxG.score.toString();
		}
	}

}