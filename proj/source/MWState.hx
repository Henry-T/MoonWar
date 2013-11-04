package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxAngle;
import flixel.util.FlxStringUtil;
import flixel.plugin.TweenManager;
import flixel.tweens.FlxTween;
import flash.display.BitmapData;

class MWState extends FlxState
{
	var btnMute : FlxButton;
	var btnMuteSnd : FlxButton;
	var btnPause : FlxButton;
	public var confirm : Confirm;
	var tweenMgr:TweenManager;

	public var input:Input;

	private var _img_mute_normal:String;
	private var _img_mute_over:String;
	private var _img_mute_dis:String;
	private var _img_pause_normal:String;
	private var _img_pause_over:String;
	private var _img_pause_dis:String;

	public function new (){
		super();
	}

	public override function create(){
		super.create();

		GameStatic.CurStateName = FlxStringUtil.getClassName(this, true);

		// something force game to mute at the beginning, so I have to force it back
		if(GameStatic.justStart){
			FlxG.sound.muted = false;
			GameStatic.justStart = false;
		}

		ResUtil.BuildBitmaps();

		#if web
		_img_mute_normal = "assets/img/ui_f_mute.png";
		_img_mute_over = "assets/img/ui_f_mute_act.png";
		_img_mute_dis = "assets/img/ui_f_mute_dis.png";
		_img_pause_normal = "assets/img/ui_f_pause.png";
		_img_pause_over = "assets/img/ui_f_pause_act.png";
		_img_pause_dis = "assets/img/ui_f_pause_dis.png";
		#end

		#if mobile
		if(GameStatic.screenDensity == GameStatic.Density_S){
			_img_mute_normal = "assets/img/ui_t_mute_S.png";
			_img_mute_over = "assets/img/ui_t_mute_act_S.png";
			_img_mute_dis = "assets/img/ui_t_mute_dis_S.png";
			_img_pause_normal = "assets/img/ui_t_pause_S.png";
			_img_pause_over = "assets/img/ui_t_pause_act_S.png";
			_img_pause_dis = "assets/img/ui_t_pause_dis_S.png";
		}
		else{
			_img_mute_normal = "assets/img/ui_t_mute_M.png";
			_img_mute_over = "assets/img/ui_t_mute_act_M.png";
			_img_mute_dis = "assets/img/ui_t_mute_dis_M.png";
			_img_pause_normal = "assets/img/ui_t_pause_M.png";
			_img_pause_over = "assets/img/ui_t_pause_act_M.png";
			_img_pause_dis = "assets/img/ui_t_pause_dis_M.png";
		}
		#end

		btnMute = new FlxButton(0, 0, "", function() { FlxG.sound.muted = !FlxG.sound.muted; } );
		btnMute.scrollFactor.set(0,0);
		btnMute.setOnOverCallback(function(){btnMute.loadGraphic(_img_mute_over);});
		btnMute.setOnOutCallback(function(){
			if(FlxG.sound.muted)
				btnMute.loadGraphic(_img_mute_dis);
			else
				btnMute.loadGraphic(_img_mute_normal);
		});

		if(FlxG.sound.muted)
			btnMute.loadGraphic(_img_mute_dis);
		else
			btnMute.loadGraphic(_img_mute_normal);

		btnMute.x = FlxG.width - btnMute.width - 5;
		btnMute.y = 5;

		btnPause = new FlxButton(0,0,"", function(){Pause(true);});
		btnPause.scrollFactor.set(0,0);
		btnPause.loadGraphic(_img_pause_normal);
		btnPause.setOnOverCallback(function(){btnPause.loadGraphic(_img_pause_over);});
		btnPause.setOnOutCallback(function(){
			if(FlxG.paused)
				btnPause.loadGraphic(_img_pause_dis);
			else
				btnPause.loadGraphic(_img_pause_normal);
		});

		btnPause.x = btnMute.x - btnPause.width - 5;
		btnPause.y = 5;

		input = new Input();
		confirm = new Confirm();

		// initial
		tweenMgr = new TweenManager();
	}

	public override function update(){
		super.update();

		#if !FLX_NO_KEYBOARD
		if(FlxG.keyboard.justPressed("M")){
			FlxG.sound.muted = !FlxG.sound.muted;
			updateMuteButton();
		}
		if(FlxG.keyboard.justPressed("P")){
			Pause(true);
			updatePauseButton();
		}
		#end
		tweenMgr.update();
	}

	private function updateMuteButton(){
		if(FlxG.sound.muted)
			btnMute.loadGraphic(_img_mute_dis);
		else 
			btnMute.loadGraphic(_img_mute_normal);
	}

	private function updatePauseButton(){
		if(FlxG.paused)
			btnPause.loadGraphic(_img_pause_dis);
		else
			btnPause.loadGraphic(_img_pause_normal);
	}

	// pause interface
	public function Pause(pause:Bool){
		updatePauseButton();
	}

	public function addTween(tween:FlxTween){
		tweenMgr.add(tween);
	}

	public function clearTweens(){
		tweenMgr.clear();
	}

	public function removeTween(tween:FlxTween){
		tweenMgr.remove(tween);
	}
}