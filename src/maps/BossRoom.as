package maps
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.*;
	import mobs.*;
	
	public class BossRoom extends MapMaker 
	{
		private var map:Array = [];

		public function BossRoom(itemGroup:FlxGroup)
		{
			super(itemGroup);
			mapWidth = 40;
			mapHeight = mapWidth;
			tilemap = makeTilemap();
			tileSize = tilemap.width / tilemap.widthInTiles;
		}

		private function makeTilemap():FlxTilemap
		{
			// Fill map solid
			for (var n:int = 0; n < mapWidth * mapHeight; n++)
				map.push(Math.random() > .95 ? Global.rockTile : Global.floorTile);

			var mapData:String = FlxTilemap.arrayToCSV(map, mapWidth);
			var result:FlxTilemap = new FlxTilemap();
			result.loadMap(mapData, terrainSprite, 0, 0, FlxTilemap.OFF, 0, 0);
			makeRocksPretty(result);
			addImpassableBorderTo(result);
			return result;
		}

		public override function makeMobs():FlxGroup
		{
			// Place one boss
			var result:FlxGroup = new FlxGroup();
			result.add(new Boss(Util.scalePoint(new FlxPoint(mapWidth * .75, mapHeight * .5), tileSize)));
			return result;
		}
	}
}