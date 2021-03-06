package;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMisc;
import flixel.util.FlxSave;
import openfl.Assets;

class MenuState extends FlxState
{
	private var _gibs:FlxEmitter;
	private var _playButton:FlxButton;
	private var _title1:FlxText;
	private var _title2:FlxText;
	private var _fading:Bool;
	private var _timer:Float;
	private var _attractMode:Bool;
	
	override public function create():Void
	{
		FlxG.cameras.bgColor = 0xff131c1b;
		
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
		}
		
		// Simple use of flixel save game object.
		// Tracks number of times the game has been played.
		var save:FlxSave = new FlxSave();
		
		if (save.bind("Mode"))
		{
			if (save.data.plays == null)
			{
				save.data.plays = 0.0;
			}
			else
			{
				save.data.plays++;
			}
			
			FlxG.log.add("Number of plays: " + save.data.plays);
			save.close();
		}
		
		// All the bits that blow up when the text smooshes together
		_gibs = new FlxEmitter(FlxG.width / 2 - 50, FlxG.height / 2 - 10);
		_gibs.setSize(100, 30);
		_gibs.setYSpeed( -200, -20);
		_gibs.setRotation( -720, 720);
		_gibs.gravity = 100;
		_gibs.makeParticles(IMG.SPAWNER_GIBS, 650, 32, true, 0);
		add(_gibs);
		
		// The letters "mo"
		_title1 = new FlxText(FlxG.width + 16, FlxG.height / 3, 64, "mo");
		_title1.size = 32;
		_title1.color = 0x3a5c39;
		_title1.antialiasing = true;
		_title1.moves = true;
		_title1.velocity.x = -FlxG.width;
		add(_title1);
		
		// The letters "de"
		_title2 = new FlxText( -60, _title1.y, Math.floor(_title1.width), "de");
		_title2.size = _title1.size;
		_title2.moves = true;
		_title2.color = _title1.color;
		_title2.antialiasing = _title1.antialiasing;
		_title2.velocity.x = FlxG.width;
		add(_title2);
		
		_fading = false;
		_timer = 0;
		_attractMode = false;
		
		FlxG.mouse.show(IMG.CURSOR, 2);
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		_gibs = null;
		_playButton = null;
		_title1 = null;
		_title2 = null;
	}

	override public function update():Void
	{
		super.update();
		
		if (_title2.x > _title1.x + _title1.width - 4)
		{
			// Once "mo" and "de" cross each other, fix their positions
			_title2.x = _title1.x + _title1.width - 4;
			_title1.velocity.x = 0;
			_title2.velocity.x = 0;
			
			// Then, play a cool sound, change their color, and blow up pieces everywhere
			FlxG.sound.play("MenuHit");
			
			FlxG.cameraFX.flash(0xffd8eba2, 0.5);
			FlxG.cameraFX.shake(0.035, 0.5);
			_title1.color = _title2.color = 0xd8eba2;
			_gibs.start(true, 5);
			_title1.angle = Math.random() * 30 - 15;
			_title2.angle = Math.random() * 30 - 15;
			
			// Then we're going to add the text and buttons and things that appear
			// If we were hip we'd use our own button animations, but we'll just recolor
			// the stock ones for now instead.
			var text:FlxText;
			text = new FlxText(FlxG.width / 2 - 50, FlxG.height / 3 + 39, 100, "by Adam Atomic");
			text.alignment = "center";
			text.color = 0x3a5c39;
			add(text);
			
			text = new FlxText(FlxG.width / 2 - 40, FlxG.height / 3 + 119, 80, "X + C TO PLAY");
			text.color = 0x729954;
			text.alignment = "center";
			add(text);
			
			var flixelButton:FlxButton = new FlxButton(FlxG.width / 2 - 40, FlxG.height / 3 + 54, "flixel.org", onFlixel);
			flixelButton.color = 0xff729954;
			flixelButton.label.color = 0xffd8eba2;
			add(flixelButton);
			
			var dannyButton:FlxButton = new FlxButton(flixelButton.x, flixelButton.y + 22, "music: dannyB", onDanny);
			dannyButton.color = flixelButton.color;
			dannyButton.label.color = flixelButton.label.color;
			add(dannyButton);
			
			_playButton = new FlxButton(flixelButton.x, flixelButton.y + 62, "CLICK HERE", onPlay);
			_playButton.color = flixelButton.color;
			_playButton.label.color = flixelButton.label.color;
			add(_playButton);
		}

		// X + C were pressed, fade out and change to play state.
		// OR, if we sat on the menu too long, launch the attract mode instead!
		_timer += FlxG.elapsed;
		
		if (_timer >= 10) //go into demo mode if no buttons are pressed for 10 seconds
		{
			_attractMode = true;
		}
		
		if (!_fading && ((FlxG.keys.X && FlxG.keys.C) || _attractMode)) 
		{
			_fading = true;
			FlxG.sound.play("MenuHit2");
			
			FlxG.cameraFX.flash(0xffd8eba2, 0.5);
			FlxG.cameraFX.fade(0xff131c1b, 1, false, onFade);
		}
	}
	
	// These are all "event handlers", or "callbacks".
	// These first three are just called when the
	// corresponding buttons are pressed with the mouse.
	
	private function onFlixel():Void
	{
		FlxMisc.openURL("http://flixel.org");
	}
	
	private function onDanny():Void
	{
		FlxMisc.openURL("http://dbsoundworks.com");
	}
	
	private function onPlay():Void
	{
		onFade();
		FlxG.sound.play("MenuHit2");
	}
	
	/**
	 * This function is passed to FlxG.fade() when we are ready to go to the next game state.
	 * When FlxG.fade() finishes, it will call this, which in turn will either load
	 * up a game demo/replay, or let the player start playing, depending on user input.
	 */
	private function onFade():Void
	{
		if (_attractMode)
		{
			FlxG.vcr.loadReplay((Math.random() < 0.5)?(Assets.getText("assets/attract1.fgr")):(Assets.getText("assets/attract2.fgr")), new PlayState(), ["ANY"], 22, onDemoComplete);
		}
		else
		{
			FlxG.switchState(new PlayState());
		}
	}
	
	/**
	 * This function is called by FlxG.loadReplay() when the replay finishes.
	 * Here, we initiate another fade effect.
	 */
	private function onDemoComplete():Void
	{
		FlxG.cameraFX.fade(0xff131c1b, 1, false, onDemoFaded);
	}
	
	/**
	 * Finally, we have another function called by FlxG.fade(), this time
	 * in relation to the callback above.  It stops the replay, and resets the game
	 * once the gameplay demo has faded out.
	 */
	private function onDemoFaded():Void
	{
		FlxG.vcr.stopReplay();
		FlxG.resetGame();
	}
}