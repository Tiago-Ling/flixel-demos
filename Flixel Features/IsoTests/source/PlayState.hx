package;

import coffeegames.mapgen.MapAlign;
import coffeegames.mapgen.MapGenerator;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import tile.FlxIsoTilemap;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var mapGen:MapGenerator;
	var mapHeight:Int;
	var mapWidth:Int;
	var map:FlxIsoTilemap;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.log.redirectTraces = false;
		FlxG.debugger.visible = true;
		
		//Map generator
		mapWidth = 42;
		mapHeight = 42;
		mapGen = new MapGenerator(mapWidth, mapHeight, 3, 5, 11, false);
		mapGen.setIndices(9, 8, 10, 11, 14, 16, 17, 15, 7, 5, 1, 1, 0);
		mapGen.generate();
		
		//Shows the minimap
		var minimap = mapGen.showMinimap(FlxG.stage, 6, MapAlign.TopLeft);
		FlxG.addChildBelowMouse(minimap);
		mapGen.showColorCodes();
		
		//Getting data from map generator and conforming it to flixel format
		var mapData:Array<Array<Int>> = mapGen.extractData();
		var flixelMapData:Array<Int> = new Array<Int>();
		for (i in 0...mapData.length) {
			for (j in 0...mapData[i].length) {
				flixelMapData.push(mapData[i][j]);
			}
		}
		
		//Isometric tilemap
		map = new FlxIsoTilemap();
		map.widthInTiles = mapWidth;
		map.heightInTiles = mapHeight;
		map._tileDepth = 24;
		map.loadMap(flixelMapData, "images/tileset.png", 48, 48, FlxTilemapAutoTiling.OFF, 0, 0, 1);
		map.adjustTiles();
		map.setTileProperties(2, FlxObject.ANY, null, null, 16);
		map.camera.antialiasing = true;
		add(map);
		
		//Adding FlxIsoSprite to the map (WARNING: Currently working on Flash only!)
		var charA = new FlxIsoSprite(0, 0, false);
		map.add(charA);
		var initialTile:IsoRect = map.getIsoRectAt(3 * mapWidth + 3);
		charA.setPosition(initialTile.isoPos.x, initialTile.isoPos.y);
		
		//Adds 10 autonomous moving chars:
/*		for (i in 0...10)
		{
			var char = new FlxIsoSprite(0, 0, true);
			var startRow:Int = FlxRandom.intRanged(3, mapHeight);
			var startCol:Int = FlxRandom.intRanged(3, mapWidth);
			var initialTile:IsoRect = map.getIsoRectAt(startRow * startCol);
			char.setPosition(initialTile.isoPos.x, initialTile.isoPos.y);
			map.add(char);
		}*/
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
			
		if (FlxG.keys.pressed.A)
			FlxG.camera.scroll.x -= 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.D)
			FlxG.camera.scroll.x += 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.W)
			FlxG.camera.scroll.y += 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.S)
			FlxG.camera.scroll.y -= 300 * FlxG.elapsed;
			
		if (FlxG.keys.justPressed.SPACE) {
			FlxG.resetState();
		}
	}	
}