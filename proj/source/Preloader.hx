package ;
import haxe.Timer;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.SimpleButton;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.KeyboardEvent;
import nme.Lib;
import nme.text.TextField;

@:bitmap("assets/img/star2.png") class BackgroundBD extends BitmapData {}
@:bitmap("assets/img/miniMoon.png") class BDmoon extends BitmapData {}
@:bitmap("assets/img/miniBoss.png") class BDboss extends BitmapData {}
@:bitmap("assets/img/pl_arrow.png") class BDarrow extends BitmapData {}

class Preloader extends NMEPreloader
{
	private var background:Sprite;
	private var moon:Bitmap;
	private var boss:Bitmap;
	private var infoTxt:TextField;
	private var bar:Sprite;

	private static var yToBottom:Float = 50;
	private static var span:Float = 120;
	private static var spanBoss:Float = 120;
	
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

	private var barL:Float;
	private var barR:Float;
	private var barMid:Float;

	private var percentLoaded:Float;

	public function new()
	{
		super();
		lastTimeStamp = 0;
		loaded = false;
		
		stageWidth = Lib.current.stage.stageWidth;
		stageHeight = Lib.current.stage.stageHeight;

		//background = new Bitmap(new BackgroundBD(550, 400));
		background = new Sprite();
		background.graphics.beginFill(0x000000, 1);
		background.graphics.drawRect(0, 0, stageWidth, stageHeight);
		background.graphics.endFill();
		background.graphics.beginBitmapFill(new BackgroundBD(550, 400));
		background.graphics.drawRect(0, 0, stageWidth, stageHeight);
		background.graphics.endFill();
		moon = new Bitmap(new BDmoon(64, 64, true, 0x00000000)); moon.x = 550 - span - moon.width / 2; moon.y = 400 - yToBottom - moon.height / 2;
		//moon = new Bitmap(Assets.getBitmapData("assets/img/miniMoon.png"));
		//moon.x = FlxG.width - span - moon.width / 2; moon.y = FlxG.height - yToBottom - moon.height / 2;
		boss = new Bitmap(new BDboss(32, 32, true, 0x00000000)); boss.x = spanBoss - boss.width / 2; boss.y = 400 - yToBottom - boss.height / 2;

		barL = boss.x + boss.width + 5;
		barR = moon.x - 5;
		barMid = 400 - yToBottom;

		background.graphics.beginFill(0xffffff, 1);
		background.graphics.lineStyle(1, 0xffffff, 1);
		background.graphics.moveTo(barL, barMid - 9);
		background.graphics.lineTo(barR, barMid - 9);
		background.graphics.moveTo(barL, barMid + 9);
		background.graphics.lineTo(barR, barMid + 9);
		background.graphics.endFill();

		bar = new Sprite();
		bar.x = barL + 2;
		bar.y = barMid - 8;

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

		infoTxt = new TextField();
		infoTxt.text="Please Wait While Loading";
		infoTxt.textColor = 0xffffffff;
		infoTxt.mouseEnabled = false;

		addChildAt (boss, 0);
		addChildAt (moon, 0);
		addChildAt (background, 0);
		addChild(bar);
		addChild(infoTxt);
		
		Lib.current.addEventListener(Event.ENTER_FRAME, update);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent){
			trace(loaded );
			trace(e.keyCode);
			if(loaded && e.keyCode == 88)
				dispatchEvent(new Event (Event.COMPLETE));
		});
		
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
		nme.ui.Mouse.show();
	}

	public override function onLoaded()
	{
		loadedTimeStamp = Timer.stamp();
		loaded = true;
		infoTxt.text = "Press X to Start";
		//dispatchEvent (new Event (Event.COMPLETE));
	}
	
	public function update(_)
	{
		infoTxt.x = stageWidth * 0.5 - infoTxt.textWidth/2;
		infoTxt.y = barMid - 10 - infoTxt.textHeight;
		
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
	}
	
	public override function onUpdate(bytesLoaded:Int, bytesTotal:Int)
	{	
		if(bytesLoaded >= bytesTotal)
			loaded = true;
		percentLoaded = bytesLoaded / bytesTotal;
		if (percentLoaded > 1)
		{
			percentLoaded == 1;
		}
		bar.graphics.beginBitmapFill(new BDarrow(16, 16));
		bar.graphics.drawRect(0, 0, (barR - barL)*percentLoaded, 16);
		bar.graphics.endFill();
	}
}