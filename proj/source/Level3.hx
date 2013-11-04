package;
import openfl.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import flixel.tile.FlxTile;
import org.flixel.tmx.TmxObjectGroup;
import flixel.addons.display.FlxBackdrop;

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
	public var botWalkSpd:Float = 80;
	public var preWalking:Bool;
	public var preWalking2:Bool;
	public var preMoveEnd:Bool;
	public var battling:Bool;
	public var battleEnd:Bool;
	public var onBoard:Bool;
	public var posCam1:FlxPoint;
	public var posCam2:FlxPoint;
	public var ground:FlxPoint;

	private var reached:Bool;

	// repair box
	public static var repairSpawnCD:Float = 3.0;
	public var repairSpawning:Bool;
	public var repairSpawnTime:Float;

	private var spawnFlag:Bool;

	public function new()
	{
		super();
		lines1 = [
			new Line(1,"Maintenance done."),
			new Line(0,"OK, a bunch of airforce is waiting ahead."),
			new Line(0,"Get onto the car, you are only weapon to fight.")
		];

		lines2 = [
			new Line(1, "They are near, Dr.Cube."),
			new Line(0, "You can handle them! I will give you a tip."),
		];

		lines3 = [
			new Line(0, "Here we are, this is transport station."),
			new Line(0, "Take the lift to go under ground.")
		];
		
		tileXML = openfl.Assets.getText("assets/dat/level3.tmx");
	}

	override public function create():Void
	{
		super.create();
		
		GameStatic.CurLvl = 2;
		
		lvlState = 0;
		preWalking = true;
		preWalking2 = false;
		preMoveEnd = false;
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
				bInLift2 = new FlxSprite(to.x - 10, to.y - 6, "assets/img/bInLift_r.png");
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
			else if (to.name == "battle")
				battlePos = new FlxPoint(to.x, to.y);
			else if (to.name == "cam1")
				posCam1 = new FlxPoint(to.x + to.width*0.5, to.y+to.height*0.5);
			else if (to.name == "cam2")
				posCam2 = new FlxPoint(to.x + to.width*0.5, to.y+to.height*0.5);
			else if (to.name == "ground")
				ground = new FlxPoint(to.x, to.y);
		}
		
		// bg for game and preDash
		bd1 = new FlxBackdrop("assets/img/star2.png", 0.1, 0.1, true, true);
		bd2 = new FlxBackdrop("assets/img/bgSkyStar.png", 0.3, 0.3, true, true);
		bd3 = new FlxBackdrop("assets/img/mSurf2.png", 1, 1, true, false);
		bd3.x = 0;
		bd3.y = ground.y;
		//bg1 = new FlxSprite(0,0, "assets/img/mSurf2.png");
		//bg1.x = 0; bg1.y = 0;
		//bg2 = new FlxSprite(0,0, "assets/img/mSurf2.png");
		//bg2.x = FlxG.width; bg2.y = 0;
		
		spawnUps = new FlxGroup(); 
		// add(spawnUps);
		bigGuns = new FlxGroup(); 
		//add(bigGuns);
		
		t = new Trans(tPos.x, tPos.y, null);
		t.active=false;

		
		AddAll();
		this.remove(bgStar);
		this.remove(bgMetal);
		
		// initial
		FlxG.camera.focusOn(posCam1);
		switchState(0);
		bgMetal.visible = false;
		spawnFlag = false;

		bot.On = false;
		bot.x = botPos1.x;
		bot.y = botPos1.y;
		bot.gunHand.animation.play("down");

		onBoard = false;

		ResUtil.playGame1();
		reached = false;

		repairSpawnTime = 0;
		repairSpawning = false;
		ShowSceneName("3 - ROAD TO TRANSPORT STATION");
	}

	public function switchState(s:Int):Void
	{
		lvlState = s;
		switch(lvlState)
		{
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
		hpBar.visible = true;
		switchState(1);
	}

	public function updateTiny():Void
	{
		switch(lvlState)
		{
		case 0:	// pre
			if(preWalking)
			{
				bot.animation.play("walk", false);
				bot.velocity.x = botWalkSpd;
				if(bot.x > botPos2.x)
				{
					preWalking = false;
					bot.velocity.x = 0;
					bot.animation.play("idle");
					TimerPool.Get().run(0.5, function(t:FlxTimer) { 
						lineMgr.Start(lines1, function() {
							TimerPool.Get().run(0.5, talkOver);
						});
					});
				}
			}
			if(preWalking2)
			{
				bot.animation.play("walk", false);
				bot.velocity.x = botWalkSpd;
				if(bot.x >= botPos3.x)
				{
					preWalking2 = false;
					bot.y -= 10;
					bot.velocity.y = -bot._jumpPower;
					bot.animation.play("jump_up", true); 
					TimerPool.Get().run(3, preEnd);
					onBoard = true;
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
			var offsetX:Float = FlxG.width * 0.5 - 550 * 0.5;	// Designed on 550x400, so I need a offset for other screen resolutions
			var offsetY:Float = FlxG.height * 0.5 - 400 * 0.5;
			b.resetMode(FlxG.camera.scroll.x + eD.CamX * 20 + offsetX, FlxG.camera.scroll.y + eD.CamY * 20 + offsetY, eD.Type);
			b.target = bot;
		}
	}

	override public function update():Void
	{
		super.update();
		if((confirm.visible&&confirm.isModel)
		 || FlxG.paused || endPause)	return;

		FlxG.collide(bot, t);

		// spawn repair box on time schedule
		// if(battling){
		// 	if(repairSpawning){
		// 		repairSpawnTime += FlxG.elapsed;
		// 		if(repairSpawnTime > repairSpawnCD){
		// 			repairSpawnTime = 0;
		// 			repairSpawning = false;
		// 			//spawnRepair();
		// 		}
		// 	}
		// 	else {
		// 		if(hps.countLiving() <= 0){	// NOTE countLiving() normally returns -1
		// 			repairSpawning = true;
		// 		}
		// 	}
		// }
		
		if (!preMoveEnd && !battling && !battleEnd && t.x > battlePos.x)
		{
			t.velocity.x = 0;
			bot.velocity.x = 0;
			//bg1.velocity.x = -300;
			//bg2.velocity.x = -300;
			bd1.velocity.x = -33;
			bd2.velocity.x = -100;
			bd3.velocity.x = -300;

			preMoveEnd = true;
			lineMgr.Start(lines2, function(){
				tipManager.ShowTip(TipManager.Tip_Master2, function(){
					battling = true;
					bot.On = true;
				});
			});
		}
		
		if (battling)
		{
			if (Bees.countLiving() <= 0 && spawnFlag == false)	// Note <=0 !
			{
				spawnFlag = true;
				if (egPointer < eGroups.length)
				{
					var eg:EnemyGroup = cast(eGroups[egPointer] , EnemyGroup);
					TimerPool.Get().run(eg.timeSpan, function(t:FlxTimer) { spawnBee(); spawnFlag=false;} );
					if(egPointer == 4 || egPointer == 7)
						spawnRepair();
					egPointer++;
				}
				else
				{
					battleEnd = true;
					bot.On = false;
					for (r in hps.members) {
						if(r!=null && r.alive) r.kill();
					}
					TimerPool.Get().run(2.5, function(tmr:FlxTimer){
						// start trans again!
						battling = false;
						//bg1.velocity.x = 0;
						//bg2.velocity.x = 0;
						bd1.velocity.x = 0;
						bd2.velocity.x = 0;
						bd3.velocity.x = 0;
						t.velocity.x = 300;
					});
				}
			}
		}

		if(onBoard){
			// keep bot on transport
			if (bot.x < t.x - bot.width / 2)
				bot.x = t.x - bot.width / 2;
			if (bot.x > t.x + t.width - bot.width / 2)
				bot.x = t.x + t.width - bot.width / 2;
		}
		
		//if(!bg1.onScreen() && bg1.x < FlxG.camera.scroll.x)
		//	bg1.x += 2*FlxG.width;
		//if(!bg2.onScreen() && bg2.x < FlxG.camera.scroll.x)
		//	bg2.x += 2*FlxG.width;
		
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
			TweenCamera(posCam2.x, posCam2.y, 1,true, function(){
				lineMgr.Start(lines3, function(){
					onBoard = false;
					bot.On = true;
				});
			});
		}

		// End Level
		if (FlxG.overlap(bot, door2Down) && door2Down.open && input.JustDown_Action && bot.On)
		{
			if((bot.x > door2Down.x + 5) && (bot.x + bot.width < door2Down.x + door2Down.width - 5)){
				door2Up.Colse(bot);
				bot.On = false;
			}
		}
		if (door2Up.locked)
		{
		 	bInLift2.visible = true;
		 	bInLift2.velocity.y = Level.liftSpeed;
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

	public function spawnRepair(){
		var r:Repair = cast(hps.recycle(Repair), Repair);
		r.reset(t.x + 15, t.y - 20);
		r.Wait();
	}
}