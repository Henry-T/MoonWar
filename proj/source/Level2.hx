package;
import org.flixel.FlxText;
import org.flixel.FlxG;
import org.flixel.FlxEmitter;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.system.FlxTile;
import org.flixel.FlxTimer;
import org.flixel.tmx.TmxObjectGroup;
import org.flixel.tweens.motion.QuadMotion;
import org.flixel.tweens.motion.LinearMotion;
import org.flixel.tweens.FlxTween;
import org.flixel.tweens.util.Ease;
import org.flixel.FlxCamera;

class Level2 extends Level
{
	public static var STpreDash 	: Int = 0;
	public static var STpreTalk 	: Int = 1;
	public static var STfight		: Int = 2;
	public static var STpostTalk	: Int = 3;

	public var lvlState : Int;	// 0-preDash 1-preTalk 2-fight 3-postTalk

	// tile breakers
	public var breakers:FlxGroup;
	public var brGP:FlxSprite;
	public var brBody:FlxSprite;
	public var brHandR:FlxSprite;
	public var brLeg:FlxSprite;
	public var brHandL:FlxSprite;

	// Camera Constant
	public static var camMoveTime:Float = 1*75;

	// Surface Base
	public static var BaseMaxLife:Int = 100;

	public var posBeeAry:Array<FlxPoint>;
	public var posGrdAry:Array<FlxPoint>;
	public var posBInSrc:FlxPoint;
	public var posBInCtrl:FlxPoint;
	public var posBIn:FlxPoint;
	public var posBInLand:FlxPoint;
	public var posBStart:FlxPoint;
	public var landHeight:Float;

	public var posCam1:FlxPoint;
	public var posCam2:FlxPoint;
	public var posCam3:FlxPoint;

	public var roam:Bool;
	public var roamDone:Bool;

	public var dash:Bool;
	public var dashDone:Bool;

	public var fighting:Bool;
	public var fightDone:Bool;

	public var exploPos1:FlxPoint;
	public var exploPos2:FlxPoint;

	public function new()
	{
		super();
		
		tileXML = nme.Assets.getText("assets/dat/level2.tmx");
		
		lines1 = [
			new Line(2, "Proceed!Crash them to ash!"), 
			new Line(0, "Calm giant buddy, take the gifts first."), 
		];
		
		lines2 = [
			new Line(2, "Uh,turbine...broken...I deside to handle you with my own hands!"),
		];

		lines3 = [
			new Line(0, "CubeBot, RageMetal still have the ability to ruin us."), 
			new Line(0, "Protect the Surface Base and try defeat it.")
		];

		lines4 = [
			new Line(0, "You're fantastic!"), 
			new Line(0, "No time to celebrate. We spotted it sinking into the tunnel."),
			new Line(0, "It is going for the Moon Core. Energy there can repare it."), 
			new Line(0, "We will go prevent that.")
		];

		posBeeAry = new Array<FlxPoint>();
		posGrdAry = new Array<FlxPoint>();

		roam = false;
		roamDone = false;
		dash = false;
		dashDone = false;
	}

	private var bShakeTween:LinearMotion;
	override public function create():Void
	{
		super.create();
		
		GameStatic.CurLvl = 2;
		lvlState = 0;
		
		// Load Tiles
		tileUp 		= GetTile("tileUp", FlxObject.UP); 
		tileBreak 	= GetTile("break", FlxObject.ANY); 
		//tileBreak.setTileProperties(0, FlxObject.ANY , onBreak, null, tileBreak._tileObjects.length);	// set all breakable to handle collision
		
		boss1 = new Boss1(-100, -100, this); 	// final pos 10, 230
		
		breakers = new FlxGroup();
		brGP = new FlxSprite();
		brGP.makeGraphic(72,26, 0x00ffffff);
		breakers.add(brGP);
		brBody = new FlxSprite();
		brBody.makeGraphic(72,37, 0x00ffffff);
		breakers.add(brBody);
		brHandR = new FlxSprite();
		brHandR.makeGraphic(33,14, 0x00ffffff);
		breakers.add(brHandR);
		brHandL = new FlxSprite();
		brHandL.makeGraphic(34,16, 0x00ffffff);
		breakers.add(brHandL);
		brLeg = new FlxSprite();
		brLeg.makeGraphic(78,47, 0x00ffffff);
		breakers.add(brLeg);
		
		// Exping
		eExplo = new FlxSprite(-100,0);
		eExplo.loadGraphic("assets/img/elecExplo.png", true, false, 25, 25);
		eExplo.addAnimation("expl", [10,0,1,2,3,4,5,6,7,8,9,10], 10, true);
		eExplo.scale = new FlxPoint(1.5, 1.5);
		eExplo.visible = false;
		
		// datas
		var fd:TmxObjectGroup = tmx.getObjectGroup("misc");
		for (td in fd.objects) {
			if(td.type == "posBee")
				posBeeAry.push(new FlxPoint(td.x, td.y));
			else if(td.type == "posGuard")
				posGrdAry.push(new FlxPoint(td.x, td.y));
			else if(td.name == "posBIn")
				posBIn = new FlxPoint(td.x, td.y);
			else if(td.name == "posBInSrc")
				posBInSrc = new FlxPoint(td.x, td.y);
			else if(td.name == "posBInCtrl")
				posBInCtrl = new FlxPoint(td.x, td.y);
			else if(td.name == "posBInLand")
				posBInLand = new FlxPoint(td.x, td.y);
			else if(td.name == "posBStart")
				posBStart = new FlxPoint(td.x, td.y);
			else if(td.name == "cam1")
				posCam1 = new FlxPoint(td.x+td.width*0.5, td.y+td.height*0.5);
			else if(td.name == "cam2")
				posCam2 = new FlxPoint(td.x+td.width*0.5, td.y+td.height*0.5);
			else if(td.name == "cam3")
				posCam3 = new FlxPoint(td.x+td.width*0.5, td.y+td.height*0.5);
			else if(td.name == "landHeight"){
				landHeight = td.y;
				boss1.landHeight = landHeight;
			}
			else if(td.name == "explo1")
				exploPos1 = new FlxPoint(td.x, td.y);
			else if(td.name == "explo2")
				exploPos2 = new FlxPoint(td.x, td.y);
			else if(td.name == "sBase"){
				//sBase = new FlxSprite(13 * 20, 20 * 5 + 6, "assets/img/sBase.png");
				sBase = new FlxSprite(td.x, td.y + 6, "assets/img/sBase.png");
				sBase.offset = new FlxPoint(121, 42);
				sBase.width = 60; sBase.height = 75;
				sBase.health = BaseMaxLife;
				boss1.appearLL = sBase.getMidpoint().x - 215;
				boss1.appearRL = sBase.getMidpoint().x + 215;
			}
		}

		smokeEmt1 = new FlxEmitter(550, 375);
		smokeEmt1.x = 0;			// x pos for preDash;
		smokeEmt1.y = landHeight - smokeEmt1.height * 0.5;
		smokeEmt1.makeParticles("assets/img/smoke.png", 10, 5, true, 0);
		smokeEmt1.start(false, 0.5, 0.03, 0);
		smokeEmt1.setXSpeed(0, 50);
		smokeEmt1.setYSpeed(80, -180);
		
		smokeEmt2 = new FlxEmitter(-100, 0);
		smokeEmt2.width = 65; smokeEmt2.height = 10;
		smokeEmt2.y = landHeight - smokeEmt2.height * 0.5;
		smokeEmt2.makeParticles("assets/img/smoke.png", 10, 5, true, 0);
		smokeEmt2.setXSpeed(-50, 50);
		smokeEmt2.setYSpeed(-30, -10);
		
		
		// Addings
		add(breakers);
		AddAll();
		
		// initial
		bot.On = false;
		ResUtil.playGame1();
		bgMetal.visible = false;
		FlxG.flash(0xff000000, 2);
		FlxG.camera.scroll = posCam1;
		roam = true;
		boss1.play("air");
		//ShowSkip(true, initForGame);
		smokeEmt1.on = false;
		smokeEmt2.on = false;

		ShowSceneName("Moon Surface Base");

		TweenCamera(posCam2.x, posCam2.y, 3, true, function(){
			roam = false;
			roamDone = true;

			// Create enemy
			boss1.x = posBInSrc.x; boss1.y = posBInSrc.y;boss1.FireOn = true;
			var bMoveTween:QuadMotion = new QuadMotion(function(){boss1.enableFloat(true);}, FlxTween.ONESHOT);
			bMoveTween.setMotion(posBInSrc.x, posBInSrc.y, posBInCtrl.x, posBInCtrl.y, posBIn.x, posBIn.y, 4, Ease.sineOut);
			bMoveTween.setObject(boss1);
			addTween(bMoveTween);

			for (grdPos in posGrdAry) {
				var grd:Guard = new Guard(grdPos.x + 200, grdPos.y);
				grd.velocity.x = -100;
				guards.add(grd);
			}
			for (bp in posBeeAry) {
				var bee:Bee = new Bee(bp.x, bp.y); 
				bee.resetMode(bp.x, bp.y, "Monk");
				bee.target = bot;
				bee.canShot = false;
				Bees.add(bee);
			}

			TimerPool.Get().start(4.5, 1, function(t:FlxTimer){
				lineMgr.Start(lines1, function(){
					TimerPool.Get().start(0.8, 1,function(t:FlxTimer){
						for (grd in guards.members)grd.kill();
						for (b in Bees.members)b.kill();

						// compare anim
						AddHugeExplo(exploPos1.x, exploPos1.y);
						for (c in cubes.members) {
							var cb:Cube = cast(c, Cube);
							if(cb.alive && cb.isBomb && cb.group == 0)
								cb.kill();
							else if(cb.alive && !cb.isBomb && cb.group == 0){
								cb.angularVelocity = -90 + FlxG.random() * 180;
								cb.acceleration.y = 200;
								cb.velocity.x = -300 + FlxG.random() * 600;
								cb.velocity.y = -100 + FlxG.random() * -300; 
							}
						}
						FlxG.flash(0xffffffff, 0.1, function(){
							bShakeTween = new LinearMotion(null, FlxTween.PINGPONG);
							bShakeTween.setMotion(boss1.x-3, boss1.y, boss1.x + 3, boss1.y, 0.1, Ease.cubeInOut);
							bShakeTween.setObject(boss1);
							addTween(bShakeTween);
							boss1.play("airShock");
							TimerPool.Get().start(1.0, 1, function(t:FlxTimer){
								this.removeTween(bShakeTween);
							});
							TimerPool.Get().start(1.0, 1, function(t:FlxTimer){
								AddHugeExplo(exploPos2.x, exploPos2.y);
								for (c in cubes.members) {
									var cb:Cube = cast(c, Cube);
									if(cb.alive && cb.isBomb && cb.group == 1)
										cb.kill();
									else if(cb.alive && !cb.isBomb && cb.group == 1){
										cb.angularVelocity = -90 + FlxG.random() * 180;
										cb.acceleration.y = 200;
										cb.velocity.x = -300 + FlxG.random() * 600;
										cb.velocity.y = -100 + FlxG.random() * -300; 
									}
								}
								FlxG.flash(0xffffffff, 0.2, null);
							});
						});

						TimerPool.Get().start(2.5, 1, function(t:FlxTimer){
							boss1.enableFloat(false);
							boss1.play("fall");
							TimerPool.Get().start(1.5, 1, function(t:FlxTimer){boss1.play("idle");});
							boss1.bossFire.play("off");
							var bLandTween:LinearMotion = new LinearMotion(function(){
								TimerPool.Get().start(0.5, 1, function(t:FlxTimer){
									lineMgr.Start(lines2, function(){
										dash = true;
										boss1.play("walk");
										smokeEmt1.on = true;
										FlxG.camera.follow(boss1, FlxCamera.STYLE_LOCKON, null, 0.5);
										var bDashTween:LinearMotion = new LinearMotion(function(){
											dash = false;
											dashDone = true;
											boss1.velocity.x = 0;
											boss1.play("idle");
											smokeEmt1.on = false;

											birthRay.x = 150;
											birthRay.y = bot.y + bot.height - birthRay.height*birthRay.scale.y;
											birthRay.play("birth");
											bot.x = start.x;
											bot.y = start.y;

											FlxG.camera.follow(null);
											TweenCamera(posCam3.x, posCam3.y, 2, true, function(){
												lineMgr.Start(lines3, function(){
													bot.On = true;
													boss1.switchState(1);
													ShowBossHP(true);
													baseHPBg.visible = true;
													baseHPBar.visible = true;
													hpBar.visible = true;
												});
											});
										}, FlxTween.ONESHOT);
										bDashTween.setMotion(boss1.x, boss1.y, posBStart.x, posBStart.y, 7, Ease.quadInOut);
										bDashTween.setObject(boss1);
										addTween(bDashTween);
									});
								});
							}, FlxTween.ONESHOT);
							bLandTween.setMotion(boss1.x, boss1.y, boss1.x, posBInLand.y, 1.5, Ease.cubeIn);
							bLandTween.setObject(boss1);
							addTween(bLandTween);
						});
					});
				});
			});
		});
	}

	// called when skip the level intro
	public function initForGame(){
		bShakeTween.cancel();
		clearTweens();
		FlxG.camera.scroll = posCam3;
		timer1.stop();
		timer2.stop();
		timer3.stop();

		bot.x = 152;
		bot.y = 130;
		bot.On = true;

		boss1.reset(posBStart.x, posBStart.y);
		boss1.switchState(1);
		boss1.FireOn = false;
		boss1.facing = FlxObject.LEFT;
		boss1.play("idle");

		ShowBossHP(true);
		baseHPBg.visible = true;
		baseHPBar.visible = true;

		smokeEmt1.on = false;
	}

	override public function update():Void
	{
		super.update();
		if((confirm.visible&&confirm.isModel)
		 || FlxG.paused || endPause)	return;

		// remove cubes when out of view range
		for (c in cubes.members) {
			var cube:Cube = cast(c, Cube);
			if(cube.alive && cube.y > FlxG.camera.bounds.bottom)
				cube.kill();
		}

		if(dashDone  && !fightDone){
			//if(Math.abs(FlxG.camera.scroll.x - posCam3.x) > 3){
			//	FlxG.camera.scroll.x -= 5;
			//}
			//else{
			//	FlxG.camera.scroll = posCam3;
			//}
		}

		// handle guards
		for (i in 0...guards.length) {
			var gd:Guard = cast(guards.members[i], Guard);
			if(gd.x <= posGrdAry[i].x){
				gd.On = false;
				gd.velocity.x = 0;
			}
		}

		// smoke
		if(dash){
			smokeEmt1.x = boss1.x;
			smokeEmt1.y = landHeight - smokeEmt1.height * 0.5;
		}

		//tileBreak.overlapsWithCallback(boss, onBreak);
		//tileBreak.overlaps(boss);

		//for(var i:Int=0;i<breakers.countLiving();i++)
		//{
		//	cast(breakers.members[i] , FlxSprite).offset = new FlxPoint(50,50);	
		//	cast(breakers.members[i] , FlxSprite).x = boss.x;
		//	cast(breakers.members[i] , FlxSprite).y = boss.y;		
		//}
		
		// gui
		var v:Float = boss1.health / Boss1.maxLife / 10 * 310;
		if(v<0)v = 0;
		hbH.scale = new FlxPoint(v,1);
		
		// collision for this level
		FlxG.collide(tileUp,bot);
		//tileBreak.overlaps(breakers);
		FlxG.overlap(boss1, bullets, function(b:FlxObject, bul:FlxObject){b.hurt(1);bul.kill();});	// bullet
		FlxG.collide(tile, ducks, duckHitTile);							// duck
		FlxG.collide(tileUp, ducks, function(t:FlxObject, d:FlxObject){
			if(Math.abs(d.velocity.x)<1) 
				if(d.x > FlxG.camera.scroll.x + FlxG.width * 0.5)
					d.velocity.x = -80;
				else 
					d.velocity.x = 80;
		});		
		FlxG.overlap(sBase, ducks, function(b:FlxObject, d:FlxObject) { if (boss1.health > 0) { b.hurt(5); } d.kill(); } );
		
		// tile breaker follows boss
		brGP.x = boss1.x + 40;
		brGP.y = boss1.y + 26;
		brBody.x = boss1.x + 41;
		brBody.y = boss1.y + 54;
		brHandR.x = boss1.x + 6;
		brHandR.y = boss1.y + 80;
		brHandL.x = boss1.x + 118;
		brHandL.y = boss1.y + 83;
		brLeg.x = boss1.x + 38;
		brLeg.y = boss1.y + 97;
		
		// misc
		eExplo.x = boss1.x + 30;
		eExplo.y = boss1.y + 30;

		baseHPBar.scale.x = sBase.health/BaseMaxLife;

		// End of Game for sbase destoried
		if(sBase.health <= 0){
			EndLevel(false);
		}
		
		smokeEmt2.x = boss1.x;
		smokeEmt2.y = landHeight - smokeEmt2.height * 0.5;
	}

	private function duckHitTile(tile:FlxObject, duck:FlxObject):Void
	{
		if(duck.isTouching(FlxObject.LEFT))
			duck.velocity.x = 80;
		else if(duck.isTouching(FlxObject.RIGHT))
			duck.velocity.x = -80;
	}

	public function switchState(state:Int):Void
	{
		lvlState = state;	
		switch(lvlState)
		{
		case STpostTalk:	// used in Boss1.hx
			ShowBossHP(false);
			bot.On = false;
			baseHPBar.visible = false;
			baseHPBg.visible = false;
			lineMgr.Start(lines4, function(){boss1.switchState(8); lvlState = 4;});
		case 5:				// used in Boss1.hx
			EndLevel(true);
		}
	}

	public function onBreak(t:FlxObject, b:FlxObject):Void
	{
		var tile:FlxTile = cast(t, FlxTile);
		if(tile.mapIndex!=0 && tileBreak.getTileByIndex(tile.mapIndex) != 0)
		{
			tileBreak.setTileByIndex(tile.mapIndex, 0);
			breakEmt.x = tile.x;
			breakEmt.y = tile.y;
			for(i in 0...4)
				breakEmt.emitParticle();
		}
	}
}