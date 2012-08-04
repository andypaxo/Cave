package
{

	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source = 'data/terrain.png')]
		private var terrainSprite:Class;
		
		override public function create():void
		{
			var noiseBitmap:BitmapData = makeSomeNoise();
			
			//var noiseSprite:FlxSprite = new FlxSprite(30, 30);
			//noiseSprite.pixels = noiseBitmap;
			//add(noiseSprite);
			
			var mapData:String = FlxTilemap.bitmapToCSV(noiseBitmap);
			
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.loadMap(mapData, terrainSprite);
			add(tilemap);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		private function makeSomeNoise():BitmapData
		{
			var noiseBitmap:BitmapData = new BitmapData(200, 200, false, 0xffffffff);
			noiseBitmap.perlinNoise(32, 32, 4, Math.random() * 64000, false, false, 7, true);
			var threshold:uint = 0xff000044;
			noiseBitmap.threshold(noiseBitmap, noiseBitmap.rect, new Point(), "<", threshold, 0xff000000, 0xff0000ff);
			noiseBitmap.threshold(noiseBitmap, noiseBitmap.rect, new Point(), ">=", threshold, 0xffffffff, 0xff0000ff);
			return noiseBitmap;
		}
	}
}

