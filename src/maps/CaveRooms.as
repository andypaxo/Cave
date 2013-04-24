package maps
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.*;
	
	public class CaveRooms extends MapMaker 
	{
		private const roomFrequency:Number = 0.6;
		private const roomSize:Number = 9;
		private const roomSpacing:Number = 4;
		private const widthInRooms:Number = 7;
		
		
		public function CaveRooms(itemGroup:FlxGroup) 
		{
			super(itemGroup);
			mapWidth = (roomSize + roomSpacing) * widthInRooms + roomSpacing;
			mapHeight = mapWidth;

			var noiseBitmap:BitmapData = makeSomeNoise();
			tilemap = makeTilemapFrom(noiseBitmap);
			tileSize = tilemap.width / tilemap.widthInTiles;
		}
		
		private function makeSomeNoise():BitmapData
		{
			var noiseBitmap:BitmapData = new BitmapData(mapWidth, mapHeight, false, 0xffffffff);
			var mapBitmap:BitmapData = new BitmapData(mapWidth, mapHeight, false, 0xff000000);
			noiseBitmap.perlinNoise(16, 16, 5, Math.random() * 64000, false, false, 7, true);
			var rockThreshold:uint = 0xff000044;
			var gemsThreshold:uint = 0xff000066;
			mapBitmap.threshold(noiseBitmap, noiseBitmap.rect, new Point(), ">", rockThreshold, 0xff888888, 0xff0000ff);
			// Would be nice if we could actually use this
			mapBitmap.threshold(noiseBitmap, noiseBitmap.rect, new Point(), ">", gemsThreshold, 0xffffffff, 0xff0000ff);
			return mapBitmap;
		}
		
		private function makeTilemapFrom(tileData:BitmapData):FlxTilemap {
			var mapData:String = FlxTilemap.bitmapToCSV(tileData);
			
			var result:FlxTilemap = new FlxTilemap();
			result.loadMap(mapData, terrainSprite, 0, 0, FlxTilemap.OFF, 0, 0);
			addRoomsTo(result);
			makeRocksPretty(result);
			addImpassableBorderTo(result);
			return result;
		}
		
		private function addRoomsTo(map:FlxTilemap):void {
			var rooms:Array = [];
			for (var x:int = 0; x < widthInRooms; x++)
			{
				rooms.push([]);
				for (var y:int = 0; y < widthInRooms; y++)
					rooms[x][y] = Math.random() < roomFrequency;
			}
					
			var centreRoom:int = Math.floor(widthInRooms / 2);
			rooms[centreRoom][centreRoom] = true;
				
			for (x = 0; x < widthInRooms; x++)
				for (y = 0; y < widthInRooms; y++)
					if (rooms[x][y])
						placeRoom(
							map,
							x * (roomSize + roomSpacing) + roomSpacing,
							y * (roomSize + roomSpacing) + roomSpacing,
							x > 0 && rooms[x - 1][y],
							y > 0 && rooms[x][y - 1]);
		}
		
		private function placeRoom(map:FlxTilemap, x:int, y:int, passageWest:Boolean, passageNorth:Boolean):void {
			for (var cx:int = 0; cx < roomSize; cx ++)
				for (var cy:int = 0; cy < roomSize; cy ++)
					map.setTile(
							cx + x,
							cy + y,
							((cx == 0 || cx == 8 || cy == 0 || cy == 8) && // All the outer walls
							!((cx >= 3 && cx <= 5) || (cy >= 3 && cy <= 5))) // Leave room for a passageway
								? Global.wallTile
								: Global.floorTile);
			
			if (passageWest)
				for (cx = 0; cx >= -roomSpacing; cx--)
					for (cy = 2; cy < 7; cy++)
							map.setTile(
							cx + x,
							cy + y,
							cy == 2 || cy == 6
								? Global.wallTile
								: Global.floorTile);
			if (passageNorth)
				for (cx = 2; cx < 7; cx++)
					for (cy = 0; cy >= -roomSpacing; cy--)
							map.setTile(
							cx + x,
							cy + y,
							cx == 2 || cx == 6
								? Global.wallTile
								: Global.floorTile);
			
			var rnd:Number = Math.random();
			if (rnd < 0.2)
				placeHoleAt(new FlxPoint(x + 4, y + 4));
			else if (rnd < 0.6)
				placeChestAt(new FlxPoint(x + 4, y + 4));
		}
		
		private function indexToLocation(index:int):FlxPoint
		{
			return new FlxPoint((index % mapWidth), Math.floor(index / mapWidth));
		}
	}

}