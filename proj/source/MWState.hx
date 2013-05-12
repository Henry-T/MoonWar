package;

import org.flixel.FlxState;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.system.input.FlxAnalog;
import org.flixel.system.input.FlxGamePad;

class MWState extends FlxState
{
	var btnMute : FlxButton;
	var btnMuteSnd : FlxButton;

	public function new (){
		super();
	}

	public override function create(){
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