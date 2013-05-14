package ;

import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.FlxGroup;
import org.flixel.FlxG;
import nme.display.BitmapData;

class Confirm extends FlxGroup{
	public static var Mode_TextOnly 	: Int = 0;
	public static var Mode_YesNo 		: Int = 1;
	public static var Mode_OK 			: Int = 2;	// this is also used for mainmenu

	// gui - confirm panel
	public var confirmMask:FlxSprite;
	public var confirmBg:SliceShape;
	public var note:MyText;
	public var btnConfirm:MyButton;
	public var btnCancel:MyButton;
	public var imgUp:FlxSprite;
	public var imgDown:FlxSprite;
	public var imgConfirm:FlxSprite;
	public var imgCancel:FlxSprite;

	public var confirmReady:Bool;

	private var _mode:Int;
	public var _confirmCall:Void->Void;
	public var _cancelCall:Void->Void;

	public var isModel:Bool;	// if true block anything else and handle input

	private var _bgTextOnly : BitmapData;
	private var _bgFull : BitmapData;

	public function new(){
		super();

		confirmMask = new FlxSprite(0,0);
		confirmMask.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
		confirmMask.alpha = 0.5;
		confirmMask.scrollFactor.make(0,0);

		confirmBg = new SliceShape(0, FlxG.height*0.91,FlxG.width, Std.int(FlxG.height * 0.08), ResUtil.IMG_ui_barh_yellow, SliceShape.MODE_HERT, 1);
		confirmBg.scrollFactor.make(0,0);

		note = new MyText(10, FlxG.height*0.95 - 6, FlxG.width - 20, "word");	// !Don't change text here for it will be used to masure height of bg bar
		note.scrollFactor.make(0,0);
		note.setFormat(ResUtil.FNT_Pixelex,GameStatic.txtSize_menuButton, 0xff000000, "left");

		_bgTextOnly = new SliceShape(0,0,FlxG.width, note.GetTextHeight() + 6, ResUtil.IMG_ui_barh_blue, SliceShape.MODE_HERT, 1).pixels.clone();
		_bgFull = new SliceShape(0,0,FlxG.width, FlxG.height * 0.08, ResUtil.IMG_ui_barh_blue, SliceShape.MODE_HERT, 1).pixels.clone();

		btnCancel = new MyButton(FlxG.width*0.6+15, FlxG.height*0.95-ResUtil.bmpBtnBMenuNormal.height*0.5, "Cancel", onConfirm);
		btnCancel.loadGraphic(ResUtil.bmpBtnYMenuNormal);
		btnCancel.label.setFormat(ResUtil.FNT_Pixelex,GameStatic.txtSize_menuButton, 0xffffffff, "center");
		btnCancel.scrollFactor.make(0,0);

		btnConfirm = new MyButton(FlxG.width*0.6+15 + 5 + btnCancel.width, FlxG.height*0.95-ResUtil.bmpBtnBMenuNormal.height*0.5, "Confirm", onCancel);
		btnConfirm.loadGraphic(ResUtil.bmpBtnYMenuNormal);
		btnConfirm.label.setFormat(ResUtil.FNT_Pixelex,GameStatic.txtSize_menuButton, 0xffffffff, "center");
		btnConfirm.scrollFactor.make(0,0);

		// Pre-scale images to fit the button rectangle's height
		imgConfirm = new FlxSprite();	imgConfirm.scrollFactor.make(0,0);
		imgConfirm.x = btnConfirm.x + 4;
		imgConfirm.y = confirmBg.y;
		imgCancel = new FlxSprite();	imgCancel.scrollFactor.make(0,0);
		imgCancel.x = btnCancel.x + 4;
		imgCancel.y = confirmBg.y;

		imgUp = new FlxSprite();	imgUp.scrollFactor.make(0,0);
		imgUp.x = 0;
		imgUp.y = 0;

		imgDown = new FlxSprite();	imgDown.scrollFactor.make(0,0);
		imgDown.x = 0;
		imgDown.y = 0;

		#if !FLX_NO_KEYBOARD
		if(GameStatic.screenDensity == GameStatic.Density_S){
			imgConfirm.loadGraphic("assets/img/key_X_S.png");
			imgCancel.loadGraphic("assets/img/key_Z_S.png");
		}
		else if(GameStatic.screenDensity == GameStatic.Density_M){
			imgConfirm.loadGraphic("assets/img/key_X_M.png");
			imgCancel.loadGraphic("assets/img/key_Z_M.png");
		}
		#end

		#if !FLX_NO_TOUCH
		if(GameStatic.screenDensity == GameStatic.Density_S){
			imgConfirm.loadGraphic("assets/img/key_X_B.png");
			imgCancel.loadGraphic("assets/img/key_Z_B.png");
		}
		else if(GameStatic.screenDensity == GameStatic.Density_M){
			imgConfirm.loadGraphic("assets/img/key_X_M.png");
			imgCancel.loadGraphic("assets/img/key_Z_M.png");
		}
		#end

		add(confirmMask);
		add(confirmBg);
		add(note);
		add(btnConfirm);
		add(btnCancel);
		add(imgConfirm);
		add(imgCancel);

		isModel = false;
		visible = false;
	}

	public override function update(){
		super.update();

		#if !FLX_NO_KEYBOARD
		if(cast(FlxG.state, MWState).input.JustDown_Shoot)
			onConfirm();
		else if(cast(FlxG.state, MWState).input.JustDown_Jump)
			onCancel();
		#end
	}

	public function ShowConfirm(mode:Int, model:Bool, info:String, yesTxt:String, noTxt:String, useMask:Bool, confirmCall:Void->Void=null, cancelCall:Void->Void=null){
		// - if use Touch control, no key image is needed and button text is centered
		// - if use Keyboard control, a key image attacked on left of every button, and button text is aligned right
		// - Mode only influence visiblity of btnCancel and imgCancel by now
		_mode = mode;
		isModel = model;
		note.text = info;
		btnConfirm.label.text = yesTxt;
		btnCancel.label.text = noTxt;
		_confirmCall = confirmCall;
		_cancelCall = cancelCall;

		confirmMask.visible = useMask;

		switch (_mode) {
			case Mode_TextOnly:
				confirmBg.loadGraphic(_bgTextOnly);
				confirmBg.y = FlxG.height * 0.95 - confirmBg.height * 0.5;
				note.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_dialog, 0xffffffff, "center");
				imgConfirm.visible = false;
				btnConfirm.visible = false;
				imgCancel.visible = false;
				btnCancel.visible = false;
			case Mode_OK:
				confirmBg.loadGraphic(_bgFull);
				confirmBg.y = FlxG.height * 0.95 - confirmBg.height * 0.5;
				note.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_dialog, 0xffffffff, "left");
				imgConfirm.visible = true;
				btnConfirm.visible = true;
				imgCancel.visible = false;
				btnCancel.visible = false;
			case Mode_YesNo:
				confirmBg.loadGraphic(_bgFull);
				confirmBg.y = FlxG.height * 0.95 - confirmBg.height * 0.5;
				note.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_dialog, 0xffffffff, "left");
				imgConfirm.visible = true;
				btnConfirm.visible = true;
				imgCancel.visible = true;
				btnCancel.visible = true;
		}

		visible = true;
	}

	private function onConfirm(){
		visible = false;
		if(_confirmCall != null)
			_confirmCall();
	}

	private function onCancel(){
		visible = false;
		if(_cancelCall != null)
			_cancelCall();
	}
}