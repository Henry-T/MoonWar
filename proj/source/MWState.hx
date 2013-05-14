package;

import org.flixel.FlxState;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.system.input.FlxAnalog;
import org.flixel.system.input.FlxGamePad;
import org.flixel.FlxGroup;
import org.flixel.FlxText;
import org.flixel.FlxSprite;
import nme.display.BitmapData;

class MWState extends FlxState
{
	var btnMute : FlxButton;
	var btnMuteSnd : FlxButton;
	public var confirm : Confirm;

	public var input:Input;

	public function new (){
		super();
	}

	public override function create(){
		super.create();

		// something force game to mute at the beginning, so I have to force it back
		if(GameStatic.justStart){
			FlxG.mute = false;
			GameStatic.justStart = false;
		}

		ResUtil.BuildBitmaps();

		btnMute = new FlxButton(FlxG.width - 20, 4, "", function() { FlxG.mute = !FlxG.mute; } );
		btnMute.scrollFactor.make(0,0);
		btnMute.onOver = function(){btnMute.loadGraphic("assets/img/mute_act.png");};
		btnMute.onOut = function(){
			if(FlxG.mute)
				btnMute.loadGraphic("assets/img/mute_dis.png");
			else
				btnMute.loadGraphic("assets/img/mute.png");
		};

		if(FlxG.mute)
			btnMute.loadGraphic("assets/img/mute_dis.png");
		else
			btnMute.loadGraphic("assets/img/mute.png");


		input = new Input();
		confirm = new Confirm();

		// initial
	}

	public override function update(){
		super.update();

		#if !FLX_NO_KEYBOARD
		if(FlxG.keys.justPressed("M")){
			FlxG.mute = !FlxG.mute;
			updateMuteButton();
		}
		#end
	}

	private function updateMuteButton(){
		if(FlxG.mute)
			btnMute.loadGraphic("assets/img/mute_dis.png");
		else 
			btnMute.loadGraphic("assets/img/mute.png");
	}
}