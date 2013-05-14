package;

import org.flixel.FlxState;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.system.input.FlxAnalog;
import org.flixel.system.input.FlxGamePad;
import org.flixel.FlxGroup;
import org.flixel.FlxText;
import org.flixel.FlxSprite;

class MWState extends FlxState
{
	var btnMute : FlxButton;
	var btnMuteSnd : FlxButton;

	// gui - confirm panel
	public var confirmGroup:FlxGroup;
	public var confirmBg:SliceShape;
	public var note_confirm:FlxText;
	public var btnConfirm_confirm:MyButton;
	public var btnCancel_confirm:MyButton;
	public var imgConfirm_confirm:FlxSprite;
	public var imgCancel_confirm:FlxSprite;

	public var confirmReady:Bool;
	public var confirmCall:Void->Void;

	public function new (){
		super();
	}

	public override function create(){
		// something force game to mute at the beginning, so I have to force it back
		if(GameStatic.justStart){
			FlxG.mute = false;
			GameStatic.justStart = false;
		}

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


		// gui - confirm panel
		confirmGroup = new FlxGroup();

		confirmBg = new SliceShape(0,0,FlxG.width, Std.int(FlxG.height * 0.1), "assets/img/ui_barv_y.png", SliceShape.MODE_VERTICLE, 1);
		confirmBg.scrollFactor.make(0,0);

		note_confirm = new FlxText(10, 0, Std.int(FlxG.width * 0.6), "choose yes or no ?");
		note_confirm.scrollFactor.make(0,0);

		btnConfirm_confirm = new MyButton();
		btnConfirm_confirm.scrollFactor.make(0,0);

		btnCancel_confirm = new MyButton();
		btnCancel_confirm.scrollFactor.make(0,0);

		imgConfirm_confirm = new FlxSprite();	imgConfirm_confirm.scrollFactor.make(0,0);
		imgCancel_confirm = new FlxSprite();	imgCancel_confirm.scrollFactor.make(0,0);



		confirmGroup.add(confirmBg);
		confirmGroup.add(note_confirm);
		confirmGroup.add(btnConfirm_confirm);
		confirmGroup.add(btnCancel_confirm);
		confirmGroup.add(imgConfirm_confirm);
		confirmGroup.add(imgCancel_confirm);

		// initial
		confirmReady = false;
		setConfirmVisable(false);
	}

	public override function update(){
		super.update();
		#if !FLX_NO_KEYBOARD
		if(FlxG.keys.justPressed("M")){
			FlxG.mute = !FlxG.mute;
			updateMuteButton();
		}
		#end
		if(confirmReady){
			confirmGroup.update();
		}
	}

	public override function draw(){
		super.draw();
		confirmGroup.draw();
	}

	private function updateMuteButton(){
		if(FlxG.mute)
			btnMute.loadGraphic("assets/img/mute_dis.png");
		else 
			btnMute.loadGraphic("assets/img/mute.png");
	}

	public function ShowConfirm(info:String="YES or NO?", call:Void->Void=null, anim:Bool=false){
		confirmReady = true;
		setConfirmVisable(true);
		note_confirm.text = info;
		confirmCall = call;
		btnConfirm_confirm.onUp = call;
		btnCancel_confirm.onUp = CloseConfirm;
	}

	public function CloseConfirm(){
		setConfirmVisable(false);
		confirmReady = false;
	}

	private function setConfirmVisable(visable:Bool){
		confirmBg.visible = visable;
		note_confirm.visible = visable;
		btnConfirm_confirm.visible = visable;
		btnCancel_confirm.visible = visable;
		imgConfirm_confirm.visible = visable;
		imgCancel_confirm.visible = visable;
	}
}