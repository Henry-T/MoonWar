package ;
import haxe.Timer;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.SimpleButton;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;
import nme.text.TextField;

@:bitmap("assets/img/bgStar_.png") class BackgroundBD extends BitmapData {}
@:bitmap("assets/img/miniMoon.png") class BDmoon extends BitmapData {}
@:bitmap("assets/img/miniBoss.png") class BDboss extends BitmapData {}
@:bitmap("assets/img/miniGuard.png") class BDguard extends BitmapData {}
@:bitmap("assets/img/miniBee.png") class BDbee extends BitmapData {}
@:bitmap("assets/img/miniBG.png") class BDbg extends BitmapData {}

class Preloader extends NMEPreloader
{
	private var background:Bitmap;
	private var moon:Bitmap;
	private var boss:Bitmap;
	private var troopAry:Array<Bitmap>;
	private var text:TextField;
	private var btnStart:SimpleButton;
	private var txtBg:Sprite;
	private var btnBg:Sprite;
	private var btnTxt:TextField;

	private static var yToBottom:Float = 50;
	private static var span:Float = 120;
	private static var spanBoss:Float = 120;
	
	private var lastPercent:Float;
	private static var mileStones:Array<Float> = [0.00, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60, 0.65, 0.70, 0.75, 0.80, 0.85, 0.90, 0.95, 1];
	
	private var lastTimeStamp:Float;
	
	private var loadedTimeStamp:Float;
	private var loaded:Bool;

	private var s:Sprite;
	private var s1:Sprite;
	private var s2:Sprite;
	private var sDis:Sprite;
	
	private var isForbid:Bool;

	private var stageWidth:Int;
	private var stageHeight:Int;

	public function new()
	{
		super();
		lastPercent = 0;
		lastTimeStamp = 0;
		loaded = false;
		
		stageWidth = Lib.current.stage.stageWidth;
		stageHeight = Lib.current.stage.stageHeight;

		background = new Bitmap(new BackgroundBD(550, 400));
		moon = new Bitmap(new BDmoon(64, 64, true, 0x00000000)); moon.x = 550 - span - moon.width / 2; moon.y = 400 - yToBottom - moon.height / 2;
		//moon = new Bitmap(Assets.getBitmapData("assets/img/miniMoon.png"));
		//moon.x = FlxG.width - span - moon.width / 2; moon.y = FlxG.height - yToBottom - moon.height / 2;
		troopAry = new Array<Bitmap>();
		boss = new Bitmap(new BDboss(32, 32, true, 0x00000000)); boss.x = spanBoss - boss.width / 2; boss.y = 400 - yToBottom - boss.height / 2;
		text = new TextField(); text.text = "0"; text.x = 50 - 10; text.y = 400 - yToBottom - 5; text.textColor = 0xffffffff;
		text.mouseEnabled = false;

		s = new Sprite();
		s.graphics.beginFill(0x2f3148,1);
		s.graphics.drawRoundRect(0,  0, 70, 30, 10, 10);
		s.graphics.beginFill(0x0f1019, 1);
		s.graphics.drawRoundRect(0, 10, 70, 30, 10, 10);
		s.graphics.endFill();
		s1 = new Sprite();
		s1.graphics.beginFill(0x2f3148,1);
		s1.graphics.drawRoundRect(0,  0, 70, 30, 10, 10);
		s1.graphics.beginFill(0x0f1019, 1);
		s1.graphics.drawRoundRect(0, 10, 70, 30, 10, 10);
		s1.graphics.endFill();
		s2 = new Sprite();
		s2.graphics.beginFill(0x2f3148,1);
		s2.graphics.drawRoundRect(0,  0, 70, 30, 10, 10);
		s2.graphics.beginFill(0x0f1019, 1);
		s2.graphics.drawRoundRect(0, 10, 70, 30, 10, 10);
		s2.graphics.endFill();
		sDis = new Sprite();
		sDis.graphics.beginFill(0x111111,1);
		sDis.graphics.drawRoundRect(0,  0, 70, 30, 10, 10);
		sDis.graphics.beginFill(0x666666, 1);
		sDis.graphics.drawRoundRect(0, 10, 70, 30, 10, 10);
		sDis.graphics.endFill();

		btnStart = new SimpleButton(sDis, s1, s2, s1); btnStart.x = stageWidth - 50 - btnStart.width/2; btnStart.y = stageHeight - yToBottom - btnStart.height/2; btnStart.visible = true;
		btnStart.enabled = false;
		
		btnTxt = new TextField(); btnTxt.text="WAIT"; btnTxt.x = stageWidth - 50 - btnTxt.width/2 + 30; btnTxt.y = stageHeight - yToBottom - 5;
		btnTxt.textColor = 0xffffffff;
		btnTxt.mouseEnabled = false;

		txtBg = new Sprite(); //txtBg.width = 90; txtBg.height = 50;
		txtBg.graphics.beginFill(0x2f3148, 1.0);
		//txtBg.graphics.drawRoundRect (0,  0, 70, 30, 10, 10);
		txtBg.graphics.beginFill(0x0f1019, 1.0);
		txtBg.graphics.drawRoundRect (0, 10, 70, 30, 10, 10);
		txtBg.x = 50 - txtBg.width/2; txtBg.y = 400 - 50 - txtBg.height / 2 - 10;

		addChildAt (boss, 0);
		addChildAt (moon, 0);
		addChildAt (background, 0);
		addChild(btnStart);
		addChild(txtBg);
		addChild(text);
		addChild(btnTxt);
		
		Lib.current.addEventListener(Event.ENTER_FRAME, update);
		btnStart.addEventListener(MouseEvent.MOUSE_DOWN, function(_) { if(isForbid)dispatchEvent(new Event (Event.COMPLETE)); } );
		
		//isForbid = false;
		
		// check for site locking
		if(loaderInfo != null){
			var allowed_site:String = "flashgamelicense.com";
			var domain:String = this.loaderInfo.url.split("/")[2];
			if (domain.indexOf(allowed_site) == (domain.length - allowed_site.length))
				isForbid = false;
			else
				isForbid = true;
		}
		else
			isForbid = false;
		
		#if debug
		//isForbid = true;
		#end

		// HACK
		//isForbid = true;
		nme.ui.Mouse.hide();
	}

	public override function onLoaded()
	{
		btnStart.visible = true;
		loadedTimeStamp = Timer.stamp();
		loaded = true;
		btnTxt.text = "START";
		//btnTxt.x = FlxG.width - 50 - btnTxt.width/2; btnTxt.y = FlxG.height - yToBottom - btnTxt.height/2;
		btnStart.enabled = true;
		//btnStart.upState = s;
		//dispatchEvent (new Event (Event.COMPLETE));
	}
	
	public function update(_)
	{
		
		var deltaTime:Float = 0;
		
		if (lastTimeStamp == 0)
		{
			lastTimeStamp = Timer.stamp();
			deltaTime = 0;
		}
		else
		{
			deltaTime = Timer.stamp() - lastTimeStamp;
			lastTimeStamp = Timer.stamp();
		}
		
		// troop movement
		for (tp in troopAry)
		{
			tp.x += 200 * deltaTime;
			if (tp.x > moon.x + moon.width/2 && this.contains(tp))
			{
				removeChild(tp);
			}
		}
		
		// auto start 3 seconds after loaded!
		// change to 3 when finished
		#if debug
		if (loaded && (Timer.stamp() - loadedTimeStamp) > 0.5)
			dispatchEvent (new Event (Event.COMPLETE));
		#end
	}
	
	public override function onUpdate(bytesLoaded:Int, bytesTotal:Int)
	{	
		var percentLoaded = bytesLoaded / bytesTotal;
		if (percentLoaded > 1)
		{
			percentLoaded == 1;
		}
		text.text = Std.string(Math.round(percentLoaded * 100));
		
		for (i in 0 ... mileStones.length-2)
		{
			if (percentLoaded > mileStones[i+1] && lastPercent < mileStones[i+1] /* && lastPercent > mileStones[i]*/)
			{
				var r:Float = Math.random();
				var trop:Bitmap = null;
				if (r < 0.33)
					trop = new Bitmap(new BDbee(16, 16));
				else if (r < 0.66)
					trop = new Bitmap(new BDbg(16, 16));
				else
					trop = new Bitmap(new BDguard(16, 16));
					
				trop.x = boss.x + 4;
				trop.y = boss.y + 4;
				
				//addChild(trop);
				//troopAry.push(trop);
			}
		}
		percentLoaded = lastPercent;
	}
}