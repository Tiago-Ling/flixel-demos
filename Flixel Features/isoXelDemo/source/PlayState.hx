package;

import flixel.addons.tile.isoXel.FlxTilemapIso;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.FlxObject;
import flixel.util.FlxPath;
import openfl.Assets;
import flixel.util.FlxPoint;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	/**
	 * Some static constants for the size of the tilemap tiles
	 */
	inline static private var TILESET = "images/alt_tileset.png";
	inline static private var MAP = "data/map2.csv";
	inline static private var TILE_WIDTH:Int = 64;
	inline static private var TILE_HEIGHT:Int = 32;
	inline static private var TILE_DEPTH:Int = 32;
	inline static private var WATER:Int = 84;
	
	//inline static private var TILESET = "images/iso_tileset2.png";
	//inline static private var MAP = "data/map.cvs";
	//inline static private var TILE_WIDTH:Int = 50;
	//inline static private var TILE_HEIGHT:Int = 0;
	//inline static private var TILE_DEPTH:Int = 25;
	//inline static private var WATER:Int = 4;
	
	private var _hero: Character;
	private var _isoTilemap: FlxTilemapIso;
	private var _path: FlxPath;
	private var _hud : Hud;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		super.create();
		
		_hud = new Hud();
		add(_hud);
		
		//Load our tilemap and add it
		_isoTilemap = new FlxTilemapIso();
		_isoTilemap.loadMap(Assets.getText(MAP),
				TILESET,
				TILE_WIDTH, TILE_DEPTH, TILE_HEIGHT, FlxTilemapIso.OFF,
				0, 0);
		add(_isoTilemap);
		
//		FlxG.camera.follow(_isoTilemap);

		//Tile 4 is a tile of water
		_isoTilemap.setTileProperties(0, FlxObject.NONE, 3);
		_isoTilemap.setTileProperties(114, FlxObject.NONE);
		_isoTilemap.setTileProperties(WATER, FlxObject.ANY);
		
		//Create a character
		_hero = new Character(300, 80);
		add(_hero);
		_hero.animation.play("stop0");
		
		//Create the path
		_path = FlxPath.recycle();
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

		if (FlxG.keys.pressed.LEFT)
			FlxG.camera.scroll.x -= 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.RIGHT)
			FlxG.camera.scroll.x += 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.UP)
			FlxG.camera.scroll.y -= 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.DOWN)
			FlxG.camera.scroll.y += 300 * FlxG.elapsed;

		if (FlxG.keys.pressed.I)
			FlxG.camera.zoom *= 1.1;
		if (FlxG.keys.pressed.O)
			FlxG.camera.zoom /= 1.1;

		if (FlxG.mouse.justPressed)
		{
			var mouse = FlxG.mouse.getWorldPosition();
			var path : Array<FlxPoint> = _isoTilemap.findPath(_hero.getMidpoint(), mouse, _hud.simplePath, false);
			
			if (path != null)
				_path.run(_hero, path);
		}
	}
	
}
