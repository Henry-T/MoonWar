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

	public var timer1:FlxTimer;
	public var timer2:FlxTimer;
	public var timer3:FlxTimer;

	public var exitEnabled:Bool;

	public function new() 
	{
		super();
	}

	override public function create():Void
	{
		super.create();

		timer1 = TimerPool.Get();
		timer2 = TimerPool.Get();
		timer3 = TimerPool.Get();
		
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

		var tween1:LinearMotion = new LinearMotion(null, FlxTween.ONESHOT);
		tween1.setObject(txtTheEnd);
		tween1.setMotion(txtTheEnd.x, txtTheEnd.y, txtTheEnd.x, txtTheEnd.y + 100, 1.5, FlxEase.bounceOut);
		addTween(tween1);

		TimerPool.Get().run(1.5, function(t:FlxTimer){
			var tween2:VarTween = new VarTween(null, FlxTween.ONESHOT);
			tween2.tween(txtThanks, "alpha", 1, 1, FlxEase.quadOut);
			addTween(tween2);
		});

		TimerPool.Get().run(1.5, function(t:FlxTimer){
			var tween3:VarTween = new VarTween(null, FlxTween.ONESHOT);
			tween3.tween(bottomPnl, "alpha", 1, 1.5, FlxEase.quadOut);
			addTween(tween3);
		});

		TimerPool.Get().run(2, function(t:FlxTimer){
			var tween4:VarTween = new VarTween(null, FlxTween.ONESHOT);
			tween4.tween(btnBack, "alpha", 1, 1.5, FlxEase.quadOut);
			addTween(tween4);
		});

		TimerPool.Get().run(2, function(t:FlxTimer){
			var tween5:VarTween = new VarTween(null, FlxTween.ONESHOT);
			tween5.tween(btnBack.label,"alpha", 1, 1.5, FlxEase.quadOut);
			addTween(tween5);
		});

		TimerPool.Get().run(2, function(t:FlxTimer){
			var tween6:VarTween = new VarTween(null, FlxTween.ONESHOT);
			tween6.tween(btnBack, "y", FlxG.height * 0.9, 1.5, FlxEase.quadOut);
			addTween(tween6);
		});

		TimerPool.Get().run(3.5, function(t:FlxTimer){
			selector.visible = true;
			exitEnabled = true;
		});
	}

	public override function update(){
		super.update();

		#if !FLX_NO_KEYBOARD
		if(exitEnabled && GameStatic.useKeyboard && FlxG.keyboard.justPressed.X){
			FlxG.switchState(new GameMap());
		}
		#end
	}
}