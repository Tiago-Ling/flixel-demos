package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;

/**
 * ...
 * @author Masadow
 */
class Hud extends FlxSpriteGroup
{

	public var simplePath : Bool;

	public function new() 
	{
		super( 0, 0);

		scrollFactor.set(0, 0);
		
		makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		
		simplePath = false;

		//Create buttons
		var button = new FlxButton(0, FlxG.height - 20, "Simple path");
		button.onUp.callback = switchSimplePath;
		add(button);
		
		//Create texts
		var text = new FlxText(FlxG.width - 120, 0, 120, "Zoom In/Out: I/O");
		text.scrollFactor.set(0, 0);
		add(text);
		text = new FlxText(FlxG.width - 120, 20, 120, "Move camera: Arrows");
		text.scrollFactor.set(0, 0);
		add(text);
	}

	public function switchSimplePath() {
		simplePath = simplePath == false;
	}
}