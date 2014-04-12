package;

import coffeegames.mapgen.MapAlign;
import coffeegames.mapgen.MapGenerator;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import tile.FlxIsoTilemap;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var mapGen:MapGenerator;
	var mapHeight:Int;
	var mapWidth:Int;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.log.redirectTraces = false;
		FlxG.debugger.visible = true;
		
/*		mapWidth = 28;
		mapHeight = 28;*/
		mapWidth = 42;
		mapHeight = 42;
/*		mapWidth = 56;
		mapHeight = 56;*/
/*		mapWidth = 100;
		mapHeight = 100;*/
		
		mapGen = new MapGenerator(mapWidth, mapHeight, 3, 5, 11, false);
		mapGen.setIndices(9, 8, 10, 11, 14, 16, 17, 15, 7, 5, 1, 1, 0);
		mapGen.generate();
		//mapGen.showMinimap(Lib.current, 6, MapAlign.BottomLeft);
		//mapGen.showColorCodes();
		
		var mapData:Array<Array<Int>> = mapGen.extractData();
		var flixelMapData:Array<Int> = new Array<Int>();
		for (i in 0...mapData.length) {
			for (j in 0...mapData[i].length) {
				flixelMapData.push(mapData[i][j]);
			}
		}
		
		var charA = new FlxIsoSprite(0, 0);
		
		var map:FlxIsoTilemap = new FlxIsoTilemap();
		map.widthInTiles = mapWidth;
		map.heightInTiles = mapHeight;
		map.loadMap(flixelMapData, "images/tileset.png", 48, 24, 48, 0, 0, 0, 1);
		map.setTileProperties(2, FlxObject.ANY, null, null, 16);
		
		map.add(charA);
		add(map);
		
		trace("map position : " + map.x + "," + map.y);
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
		
/*		if (FlxG.keys.pressed.A)
			FlxG.camera.scroll.x -= 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.D)
			FlxG.camera.scroll.x += 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.W)
			FlxG.camera.scroll.y -= 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.S)
			FlxG.camera.scroll.y += 300 * FlxG.elapsed;*/
			
		if (FlxG.keys.pressed.A)
			FlxG.camera.scroll.x += 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.D)
			FlxG.camera.scroll.x -= 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.W)
			FlxG.camera.scroll.y += 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.S)
			FlxG.camera.scroll.y -= 300 * FlxG.elapsed;
			
		if (FlxG.keys.justPressed.SPACE) {
			FlxG.resetState();
		}
	}	
}