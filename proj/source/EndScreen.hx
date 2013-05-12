package ;
import nme.display.BitmapData;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxTimer;
import org.flixel.tweens.FlxTween;
import org.flixel.tweens.util.Ease;
import org.flixel.tweens.motion.LinearMotion;
import org.flixel.tweens.misc.VarTween;
import org.flixel.addons.FlxBackdrop;

class EndScreen extends GameScreen 
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

		timer1 = new FlxTimer();
		timer2 = new FlxTimer();
		timer3 = new FlxTimer();
		
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
		btnBack.onOver = function(){btnBack.loadGraphic(btnGBigOver);};
		btnBack.onOut = function(){btnBack.loadGraphic(btnGBigNormal);};
		btnBack.x = FlxG.width * 0.5 - btnBack.width/2;
		btnBack.y = FlxG.height * 1.10;
		btnBack.label.setFormat("assets/fnt/pixelex.ttf", 16, 0xffffff, "center");

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
		tween1.setMotion(txtTheEnd.x, txtTheEnd.y, txtTheEnd.x, txtTheEnd.y + 100, 1.5, Ease.bounceOut);
		addTween(tween1);

		TimerPool.Get().start(1.5, 1, function(t:FlxTimer){
			var tween2:VarTween = new VarTween(null, FlxTween.ONESHOT);
			tween2.tween(txtThanks, "alpha", 1, 1, Ease.quadOut);
			addTween(tween2);
		});

		TimerPool.Get().start(1.5, 1, function(t:FlxTimer){
			var tween3:VarTween = new VarTween(null, FlxTween.ONESHOT);
			tween3.tween(bottomPnl, "alpha", 1, 1.5, Ease.quadOut);
			addTween(tween3);
		});

		TimerPool.Get().start(2, 1, function(t:FlxTimer){
			var tween4:VarTween = new VarTween(null, FlxTween.ONESHOT);
			tween4.tween(btnBack, "alpha", 1, 1.5, Ease.quadOut);
			addTween(tween4);
		});

		TimerPool.Get().start(2, 1, function(t:FlxTimer){
			var tween5:VarTween = new VarTween(null, FlxTween.ONESHOT);
			tween5.tween(btnBack.label,"alpha", 1, 1.5, Ease.quadOut);
			addTween(tween5);
		});

		TimerPool.Get().start(2, 1, function(t:FlxTimer){
			var tween6:VarTween = new VarTween(null, FlxTween.ONESHOT);
			tween6.tween(btnBack, "y", FlxG.height * 0.9, 1.5, Ease.quadOut);
			addTween(tween6);
		});

		TimerPool.Get().start(3.5, 1, function(t:FlxTimer){
			selector.visible = true;
			exitEnabled = true;
		});
	}

	public override function update(){
		super.update();

		if(exitEnabled && GameStatic.useKeyboard && FlxG.keys.justPressed("X")){
			FlxG.switchState(new GameMap());
		}
	}
}