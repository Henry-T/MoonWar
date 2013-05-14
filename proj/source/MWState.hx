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

	// gui - confirm panel
	public var confirmGroup:FlxGroup;
	public var confirmMask:FlxSprite;
	public var confirmBg:SliceShape;
	public var note_confirm:FlxText;
	public var btnConfirm_confirm:MyButton;
	public var btnCancel_confirm:MyButton;
	public var imgConfirm_confirm:FlxSprite;
	public var imgCancel_confirm:FlxSprite;

	public var confirmReady:Bool;
	public var confirmCallBack:Void->Void;
	public var cancelCallBack:Void->Void;

	public function new (){
		super();
	}

	public override function create(){
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


		// gui - confirm panel
		confirmGroup = new FlxGroup();

		confirmMask = new FlxSprite(0,0);
		confirmMask.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
		confirmMask.alpha = 0.5;
		confirmMask.scrollFactor.make(0,0);

		confirmBg = new SliceShape(0, FlxG.height*0.91,FlxG.width, Std.int(FlxG.height * 0.08), "assets/img/ui_barh_y.png", SliceShape.MODE_HERT, 1);
		confirmBg.scrollFactor.make(0,0);

		note_confirm = new FlxText(10, FlxG.height*0.95 - 6, Std.int(FlxG.width * 0.6), "choose yes or no ?");
		note_confirm.scrollFactor.make(0,0);
		note_confirm.setFormat(ResUtil.FNT_Pixelex,GameStatic.txtSize_menuButton, 0xff000000, "left");

		btnCancel_confirm = new MyButton(FlxG.width*0.6+15, FlxG.height*0.95-ResUtil.bmpBtnBMenuNormal.height*0.5, "Cancel", onConfirm);
		btnCancel_confirm.loadGraphic(ResUtil.bmpBtnYMenuNormal);
		btnCancel_confirm.label.setFormat(ResUtil.FNT_Pixelex,GameStatic.txtSize_menuButton, 0xffffffff, "center");
		btnCancel_confirm.scrollFactor.make(0,0);

		btnConfirm_confirm = new MyButton(FlxG.width*0.6+15 + 5 + btnCancel_confirm.width, FlxG.height*0.95-ResUtil.bmpBtnBMenuNormal.height*0.5, "Confirm", onCancel);
		btnConfirm_confirm.loadGraphic(ResUtil.bmpBtnYMenuNormal);
		btnConfirm_confirm.label.setFormat(ResUtil.FNT_Pixelex,GameStatic.txtSize_menuButton, 0xffffffff, "center");
		btnConfirm_confirm.scrollFactor.make(0,0);

		imgConfirm_confirm = new FlxSprite();	imgConfirm_confirm.scrollFactor.make(0,0);
		imgConfirm_confirm.x = btnConfirm_confirm.x + 4;
		imgConfirm_confirm.y = confirmBg.y;
		imgCancel_confirm = new FlxSprite();	imgCancel_confirm.scrollFactor.make(0,0);
		imgCancel_confirm.x = btnCancel_confirm.x + 4;
		imgCancel_confirm.y = confirmBg.y;

		#if !FLX_NO_KEYBOARD
		if(GameStatic.screenDensity == GameStatic.Density_S){
			imgConfirm_confirm.loadGraphic("assets/img/key_X_S.png");
			imgCancel_confirm.loadGraphic("assets/img/key_Z_S.png");
		}
		else if(GameStatic.screenDensity == GameStatic.Density_M){
			imgConfirm_confirm.loadGraphic("assets/img/key_X_M.png");
			imgCancel_confirm.loadGraphic("assets/img/key_Z_M.png");
		}
		#end

		#if !FLX_NO_TOUCH
		if(GameStatic.screenDensity == GameStatic.Density_S){
			imgConfirm_confirm.loadGraphic("assets/img/key_X_A.png");
			imgCancel_confirm.loadGraphic("assets/img/key_Z_A.png");
		}
		else if(GameStatic.screenDensity == GameStatic.Density_M){
			imgConfirm_confirm.loadGraphic("assets/img/key_X_B.png");
			imgCancel_confirm.loadGraphic("assets/img/key_Z_B.png");
		}
		#end

		confirmGroup.add(confirmBg);
		confirmGroup.add(confirmMask);
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

	public function ShowConfirm(info:String="YES or NO?", callConfirm:Void->Void=null, callCancel:Void->Void=null, useMask:Bool=false){
		confirmReady = true;
		setConfirmVisable(true, useMask);
		note_confirm.text = info;
		confirmCallBack = callConfirm;
		cancelCallBack = callCancel;
	}

	private function onConfirm(){
		setConfirmVisable(false);
		confirmReady = false;
		if(confirmCallBack != null)
			confirmCallBack();
	}

	private function onCancel(){
		setConfirmVisable(false);
		confirmReady = false;
		if(cancelCallBack != null)
			cancelCallBack();
	}

	private function setConfirmVisable(visable:Bool, useMask:Bool=false){
		confirmBg.visible = visable;
		note_confirm.visible = visable;
		btnConfirm_confirm.visible = visable;
		btnCancel_confirm.visible = visable;
		imgConfirm_confirm.visible = visable;
		imgCancel_confirm.visible = visable;

		if(useMask)
			confirmMask.visible = true;
		else 
			confirmMask.visible = false;
	}
}