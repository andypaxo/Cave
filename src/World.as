package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.*;
	
	public class World 
	{
		[Embed(source = 'data/terrain.png')]
		private var terrainSprite:Class;
		
		private const maxPlacedItems:int = 200;
		private const placeableBorder:int = 2;
		private const mapWidth:int = 200;
		private const mapHeight:int = 200;
		
		private var tilemap:FlxTilemap;
		
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
			var noiseBitmap:BitmapData = new BitmapData(mapWidth, mapHeight, false, 0xffffffff);
			var mapBitmap:BitmapData = new BitmapData(mapWidth, mapHeight, false, 0xff000000);
			noiseBitmap.perlinNoise(16, 16, 5, Math.random() * 64000, false, false, 7, true);
			var rockThreshold:uint = 0xff000044;
			var gemsThreshold:uint = 0xff000066;
			mapBitmap.threshold(noiseBitmap, noiseBitmap.rect, new Point(), ">", rockThreshold, 0xff888888, 0xff0000ff);
			mapBitmap.threshold(noiseBitmap, noiseBitmap.rect, new Point(), ">", gemsThreshold, 0xffffffff, 0xff0000ff);
			return mapBitmap;
		}
		
		private function makeTilemapFrom(tileData:BitmapData):FlxTilemap {
			var mapData:String = FlxTilemap.bitmapToCSV(tileData);
			
			var result:FlxTilemap = new FlxTilemap();
			result.loadMap(mapData, terrainSprite);
			return result;
		}
		
		public function makeMobs():FlxGroup
		{
			var result:FlxGroup = new FlxGroup(maxPlacedItems);
			
			var placeableArea:FlxRect = new FlxRect(
				placeableBorder, placeableBorder, 
				mapWidth - placeableBorder * 2, mapHeight - placeableBorder * 2);
				
			for (var i:int = 0; i < maxPlacedItems; i++) 
			{
				var tileLocation:FlxPoint = new FlxPoint(
					Math.floor(Math.random() * placeableArea.width + placeableArea.left),
					Math.floor(Math.random() * placeableArea.height + placeableArea.top));
					
				if (tilemap.getTile(tileLocation.x, tileLocation.y) == 0)
					result.add(new Mob(Util.scalePoint(tileLocation, Global.tileSize)));
				else
					tilemap.setTile(tileLocation.x, tileLocation.y, 2);
			}
			
			return result;
		}
		
		private function indexToLocation(index:int):FlxPoint
		{
			return new FlxPoint((index % mapWidth), Math.floor(index / mapWidth));
		}
	}

}