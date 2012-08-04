package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.*;
	
	public class World 
	{
		[Embed(source = 'data/terrain.png')]
		private var terrainSprite:Class;
		
		var tilemap:FlxTilemap;
		
		public function World() 
		{
			var noiseBitmap:BitmapData = makeSomeNoise();
			tilemap = makeTilemapFrom(noiseBitmap);
		}
		
		public function getTilemap():FlxTilemap {
			return tilemap;
		}
		
		private function makeSomeNoise():BitmapData
		{
			var noiseBitmap:BitmapData = new BitmapData(200, 200, false, 0xffffffff);
			noiseBitmap.perlinNoise(16, 16, 5, Math.random() * 64000, false, false, 7, true);
			var threshold:uint = 0xff000044;
			noiseBitmap.threshold(noiseBitmap, noiseBitmap.rect, new Point(), "<", threshold, 0xff000000, 0xff0000ff);
			noiseBitmap.threshold(noiseBitmap, noiseBitmap.rect, new Point(), ">=", threshold, 0xffffffff, 0xff0000ff);
			return noiseBitmap;
		}
		
		private function makeTilemapFrom(tileData:BitmapData) {
			var mapData:String = FlxTilemap.bitmapToCSV(tileData);
			
			var result:FlxTilemap = new FlxTilemap();
			result.loadMap(mapData, terrainSprite);
			return result;
		}
	}

}