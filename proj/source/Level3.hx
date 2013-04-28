package;
import nme.Assets;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
import org.flixel.FlxTimer;
import org.flixel.system.FlxTile;
import org.flixel.tmx.TmxObjectGroup;

class Level3 extends Level
{
	// Enemy
	public var egPointer:Int;
	public var eGroups:Array<EnemyGroup>;

	// state
	public var lvlState:Int;	// 0-preTalk   1-fight	  2- talking
	public var botPos1:FlxPoint;
	public var botPos2:FlxPoint;
	public var botPos3:FlxPoint;
	public var tPos:FlxPoint;
	public var tPos2:FlxPoint;
	public var battlePos:FlxPoint;
	public static var botWalkSpd:Float = 80;
	public var preWalking:Bool;
	public var preWalking2:Bool;
	public var battling:Bool;
	public var battleEnd:Bool;

	// trans

	// ducks
	public var dms:FlxGroup;
	public var duckStart:Float;
	public var duckEnd:Float;

	public var posCam1:FlxPoint;

	private var reached:Bool;

	public function new()
	{
		super();
		lines1 = [
			new Line(1,"Maintenance done."),
			new Line(0,"OK, a bunch of airforce is waiting ahead."),
			new Line(0,"Get onto the car, you are only weapon to fight.")
		];

		lines2 = [
			new Line(0, "Here we are, this is transport station."),
			new Line(0, "Take the lift to go under ground.")
		];
		
		tileXML = nme.Assets.getText("assets/dat/level3.tmx");
	}

	override public function create():Void
	{
		super.create();
		
		GameStatic.CurLvl = 3;
		
		lvlState = 0;
		preWalking = true;
		preWalking2 = false;
		battling = false;
		battleEnd = false;
		
		// Load Enemy Data
		egPointer = 0;
		eGroups = new Array();
		var enemyXml:Xml = Xml.parse(Assets.getText("assets/dat/enemy2.xml"));
		for ( eg in enemyXml.firstElement().elementsNamed("EnemyGroup"))
		{
			eGroups.push(new EnemyGroup(eg));
		}
		
		var os:TmxObjectGroup = tmx.getObjectGroup("misc");
		for (to in os.objects)
		{
			if (to.name == "door2"){
				door2Up = new LDoor(to.x, to.y, false);
				door2Down = new LDoor(to.x, to.y, true);
				bInLift2 = new FlxSprite(to.x - 10, to.y - 6, "assets/img/bInLift.png");
			}
			else if (to.name == "comOut"){
				var com:Com = cast(coms.recycle(Com), Com);
				com.make(to);
				com.onTig = function(){door2Down.Unlock();};
			}
			else if(to.name=="botPos1")
				botPos1 = new FlxPoint(to.x, to.y);
			else if(to.name == "botPos2")
				botPos2 = new FlxPoint(to.x, to.y);
			else if(to.name == "botPos3")
				botPos3 = new FlxPoint(to.x, to.y);
			else if(to.name == "tPos")
				tPos = new FlxPoint(to.x, to.y);
			else if(to.name == "tPos2")
				tPos2 = new FlxPoint(to.x, to.y);
			else if(to.name == "duckStart")
				duckStart = to.x;
			else if(to.name == "duckEnd")
				duckEnd = to.x;
			else if (to.name == "battle")
				battlePos = new FlxPoint(to.x, to.y);
			else if (to.name == "cam1")
				posCam1 = new FlxPoint(to.x, to.y);
		}
		
		// bg for game and preDash
		bg1 = new FlxSprite(0,0, "assets/img/mSurf2.png");
		bg1.x = 0; bg1.y = 0;
		bg2 = new FlxSprite(0,0, "assets/img/mSurf2.png");
		bg2.x = FlxG.width; bg2.y = 0;
		
		dms = new FlxGroup();
		//add(dms);
		var dm:Dumom = new Dumom(this);
		dm.SpawnPos = new FlxPoint(-30, 100);
		dm.DuckSpawnCold = 1000;
		dms.add(dm);
		dm = new Dumom(this);
		dm.SpawnPos = new FlxPoint(-30, 300);
		dm.DuckSpawnCold = 1000;
		dms.add(dm);
		dm = new Dumom(this);
		dm.SpawnPos = new FlxPoint(-30, 500);
		dm.DuckSpawnCold = 1000;
		dms.add(dm);
		dm = new Dumom(this);
		dm.SpawnPos = new FlxPoint(830, 100);
		dm.DuckSpawnCold = 1000;
		dms.add(dm);
		dm = new Dumom(this);
		dm.SpawnPos = new FlxPoint(830, 300);
		dm.DuckSpawnCold = 1000;
		dms.add(dm);
		dm = new Dumom(this);
		dm.SpawnPos = new FlxPoint(830, 500);
		dm.DuckSpawnCold = 1000;
		dms.add(dm);
		
		// tiles
		tile.follow();
		
		spawnUps = new FlxGroup(); 
		// add(spawnUps);
		bigGuns = new FlxGroup(); 
		//add(bigGuns);
		
		t = new Trans(220, 240, null);
		t.active=false;
		
		bot.x = botPos1.x; botPos1.y = botPos1.y;
		
		AddAll();
		
		// initial
		FlxG.camera.scroll.x = t.x + t.width / 2 -FlxG.width / 2;
		switchState(0);
		bgMetal.visible = false;
		bot.On = false;
		ResUtil.playGame1();
		reached = false;
		
	}

	public function switchState(s:Int):Void
	{
		lvlState = s;
		switch(lvlState)
		{
			case 0:
			bot.On = false;
			
			case 1:
			t.active = true;
		}
	}

	public function talkOver(t:FlxTimer):Void
	{
		preWalking2 = true;
	}
	public function preEnd(t:FlxTimer):Void
	{
		switchState(1);
	}

	public function updateTiny():Void
	{
		switch(lvlState)
		{
		case 0:	// pre
			if(preWalking)
			{
				bot.play("walk", false);
				bot.velocity.x = botWalkSpd;
				if(bot.x > botPos2.x)
				{
					preWalking = false;
					bot.velocity.x = 0;
					bot.play("idle");
					timer1.start(0.5, 1, function(t:FlxTimer) { 
						lineMgr.Start(lines1, function() {
							timer1.start(0.5, 1, talkOver);
						});
					});
				}
			}
			if(preWalking2)
			{
				bot.play("walk", false);
				bot.velocity.x = botWalkSpd;
				if(bot.x >= botPos3.x)
				{
					preWalking2 = false;
					bot.y -= 10;
					bot.velocity.y = -bot._jumpPower;
					bot.play("jump_up", true); 
					timer1.start(3, 1, preEnd);
				}
			}
		case 1:	// fight
			FlxG.camera.scroll.x += FlxG.elapsed * t.velocity.x;
		case 2:	// post
		}
	}

	public function spawnBee():Void {
		var eg:EnemyGroup = cast(eGroups[egPointer - 1] , EnemyGroup);
		for (eD in eg.enemyDatas )
		{
			var b:Bee = cast(Bees.recycle(Bee) , Bee);
			b.reset(-1000, -1000);
			b.resetMode(FlxG.camera.scroll.x + eD.CamX * 20, FlxG.camera.scroll.y + eD.CamY * 20, eD.Type);
			b.target = bot;
		}
	}

	override public function update():Void
	{
		FlxG.collide(bot, t);

		super.update();
		
		if (!battling && !battleEnd && t.x > battlePos.x)
		{
			battling = true;

			t.velocity.x = 0;
			bot.velocity.x = 0;
			bg1.velocity.x = -300;
			bg2.velocity.x = -300;
			bot.On = true;
		}
		
		if (battling)
		{
			if (Bees.countLiving() <= 0 && timer1.finished)	// Note <=0 !
			{
				if (egPointer < eGroups.length)
				{
					var eg:EnemyGroup = cast(eGroups[egPointer] , EnemyGroup);
					timer1.start(eg.timeSpan, 1, function(t:FlxTimer) { spawnBee(); } );
					egPointer++;
				}
				else
				{
					bot.On = false;
					// start trans again!
					bg1.velocity.x = 0;
					bg2.velocity.x = 0;
					t.velocity.x = 300;
					battling = false;
					battleEnd = true;
				}
			}
		}

		if(battling){
			// keep bot on transport
			if (bot.x < t.x - bot.width / 2)
			bot.x = t.x - bot.width / 2;
			if (bot.x > t.x + t.width - bot.width / 2)
			bot.x = t.x + t.width - bot.width / 2;
		}
		
		if(!bg1.onScreen() && bg1.x < FlxG.camera.scroll.x)
			bg1.x += 2*FlxG.width;
		if(!bg2.onScreen() && bg2.x < FlxG.camera.scroll.x)
			bg2.x += 2*FlxG.width;
		
		birthPos = new FlxPoint(t.x + 60, 390);

		if(bot.x < FlxG.camera.scroll.x)
			bot.x = FlxG.camera.scroll.x;
		if (bot.x > FlxG.camera.scroll.x + FlxG.width)
			bot.x = FlxG.camera.scroll.x + FlxG.width;

		// Reach Trans Station
		if(!reached && t.x >= tPos2.x)
		{
			reached = true;
			t.velocity.x = 0;
			FlxG.camera.follow(null);
			TweenCamera(posCam1.x, posCam1.y, 1,true, function(){
				lineMgr.Start(lines2, function(){
					bot.On = true;
				});
			});
		}

		// End Level
		if (FlxG.overlap(bot, door2Down) && door2Down.open && FlxG.keys.justPressed(bot.actionKey))
		{
			if((bot.x > door2Down.x + 5) && (bot.y + bot.width < door2Down.x + door2Down.width - 5)){
				door2Up.Colse(bot);
				bot.On = false;
			}
		}
		if (door2Up.locked)
		{
		 	bInLift2.visible = true;
		 	bInLift2.velocity.y = 30;
		 	bot.active = false;
		}
		
		if (!isEnd && bInLift2.y > end.y){
			EndLevel(true);
		}


		FlxG.collide(bot, t);

		updateTiny();
	}

	public function DrawGui():Void
	{
		//game.SpriteBatch.DrawString(game.debugFont, (((t.transLife))).toString(), new FlxPoint(), Color.White);
	}
}