package ;
import flash.display.BitmapData;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.tweens.motion.LinearMotion;
import flixel.tweens.misc.VarTween;
import flixel.addons.display.FlxBackdrop;

class EndScreen extends MWState 
{
	public var txtTheEnd:FlxSprite;
	public var txtThanks:FlxSprite;
	public var bg:FlxBackdrop;
	public var btnBack:FlxButton;

	public var bottomPnl:SliceShape;
	public var selector:SliceShape;

	public var btnGBigNormal:BitmapData;
	public var btnGBigOver:BitmapData;

	public var exitEnabled:Bool;

	public function new() 
	{
		super();
	}

	override public function create():Void
	{
		super.create();
		
		btnGBigNormal = new SliceShape(0,0, GameStatic.button_menuWidth, GameStatic.button_menuHeight, "assets/img/ui_box_y.png", SliceShape.MODE_BOX, 3).pixels.clone();
		btnGBigOver = new SliceShape(0,0, GameStatic.button_menuWidth, GameStatic.button_menuHeight, "assets/img/ui_boxact_y.png", SliceShape.MODE_BOX, 3).pixels.clone();

		bg = new FlxBackdrop("assets/img/star2.png", 0, 0, true, true);
		txtTheEnd = new FlxSprite("assets/img/theEnd.png");
		txtTheEnd.x = FlxG.width * 0.5 - txtTheEnd.width * 0.5;
		txtTheEnd.y = FlxG.height * 0.1;

		txtThanks = new FlxSprite("assets/img/thanks.png");
		txtThanks.x = FlxG.width * 0.5 - txtThanks.width * 0.5;
		txtThanks.y = FlxG.height * 0.4;

		bottomPnl = new SliceShape(0, FlxG.height-50, FlxG.width + 10, 40, "assets/img/ui_barh_y.png", SliceShape.MODE_HERT, 1);

		selector = new SliceShape(0, 0, GameStatic.border_menuWidth, GameStatic.border_menuHeight, "assets/img/ui_boxact_border.png", SliceShape.MODE_BOX, 2);
		btnBack = new FlxButton(0, 0, "BACK", function() { FlxG.switchState(new MainMenu()); } );
		btnBack.loadGraphic(btnGBigNormal);
		btnBack.setOnOverCallback(function(){btnBack.loadGraphic(btnGBigOver);});
		btnBack.setOnOutCallback(function(){btnBack.loadGraphic(btnGBigNormal);});
		btnBack.x = FlxG.width * 0.5 - btnBack.width/2;
		btnBack.y = FlxG.height * 1.10;
		btnBack.label.setFormat(ResUtil.FNT_Pixelex, 16, 0xffffff, "center");

		add(bg);
		add(txtTheEnd);
		add(txtThanks);
		add(bottomPnl);
		add(selector);
		add(btnBack);

		// initial
		exitEnabled = false;
		ResUtil.playTitle();
		txtTheEnd.y -= 100;
		txtThanks.alpha = 0;
		bottomPnl.alpha = 0;
		btnBack.alpha = 0;
		btnBack.label.alpha = 0;
		selector.visible = false;
		selector.x = btnBack.x + GameStatic.offset_border;
		selector.y = FlxG.height * 0.9 + GameStatic.offset_border;

		FlxTween.linearMotion(txtTheEnd, txtTheEnd.x, txtTheEnd.y, txtTheEnd.x, txtTheEnd.y + 100, 1.5, true, {type:FlxTween.ONESHOT, ease:FlxEase.bounceOut});

		FlxTimer.start(1.5, function(t:FlxTimer){
			FlxTween.multiVar(txtThanks, {alpha:1}, 1, {type:FlxTween.ONESHOT, ease:FlxEase.quadOut});
		});

		FlxTimer.start(1.5, function(t:FlxTimer){
			FlxTween.multiVar(bottomPnl, {alpha:1}, 1.5, {type:FlxTween.ONESHOT, ease:FlxEase.quadOut});
		});

		FlxTimer.start(2, function(t:FlxTimer){
			FlxTween.multiVar(btnBack, {alpha:1}, 1.5, {type:FlxTween.ONESHOT, ease:FlxEase.quadOut});
		});

		FlxTimer.start(2, function(t:FlxTimer){
			FlxTween.multiVar(btnBack.label, {alpha:1}, 1.5, {type:FlxTween.ONESHOT, ease:FlxEase.quadOut});
		});

		FlxTimer.start(2, function(t:FlxTimer){
			FlxTween.multiVar(btnBack, {y:FlxG.height*0.9}, 1.5, {type:FlxTween.ONESHOT, ease:FlxEase.quadOut});
		});

		FlxTimer.start(3.5, function(t:FlxTimer){
			selector.visible = true;
			exitEnabled = true;
		});
	}

	public override function update(){
		super.update();

		#if !FLX_NO_KEYBOARD
		if(exitEnabled && GameStatic.useKeyboard && FlxG.keyboard.justPressed("X")){
			FlxG.switchState(new GameMap());
		}
		#end
	}
}