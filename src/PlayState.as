package
{

	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		
		override public function create():void
		{
			var noiseBitmap:BitmapData = new BitmapData(200, 200, false, 0xffffffff);
			noiseBitmap.perlinNoise(32, 32, 4, Math.random() * 64000, false, false, 7, true);
			noiseBitmap.threshold(noiseBitmap, noiseBitmap.rect, new Point(), "<", 0xff000055, 0, 0xff0000ff);
			
			var noiseSprite:FlxSprite = new FlxSprite(30, 30);
			noiseSprite.pixels = noiseBitmap;
			//noiseSprite.pixels.copyPixels(noiseBitmap, noiseBitmap.rect, new Point(0, 0));
			add(noiseSprite);
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}

