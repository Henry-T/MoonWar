package;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.tile.FlxTile;
import flixel.util.FlxTimer;
import org.flixel.tmx.TmxObjectGroup;
import flixel.tweens.motion.QuadMotion;
import flixel.tweens.motion.LinearMotion;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxCamera;

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
		
		tileXML = openfl.Assets.getText("assets/dat/level2.tmx");
		
		lines1 = [
			new Line(2, "Proceed!Crash them to ash!"), 
			new Line(0, "Calm giant buddy, take the gifts first."), 
		];
		
		lines2 = [
			new Line(2, "Uh,turbine...broken...I deside to handle you with my own hands!"),
		];

		lines3 = [
			new Line(0, "CubeBot, RageMetal still have the ability to ruin us."), 
			new Line(0, "Protect the Surface Base and try defeat it."),
			new Line(0, "I have a tip for you.")
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
		
		GameStatic.CurLvl = 1;
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
		eExplo.animation.add("expl", [10,0,1,2,3,4,5,6,7,8,9,10], 10, true);
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
				boss1.appearLL = sBase.getMidpoint().x - 205;
				boss1.appearRL = sBase.getMidpoint().x + 205;
			}
		}
		
		// Emitter for predash
		smokeEmt1 = new FlxEmitter(0, 0);
		smokeEmt1.x = 0;
		smokeEmt1.y = landHeight - smokeEmt1.height * 0.5;
		smokeEmt1.makeParticles("assets/img/smoke.png", 10, 5, true, 0);
		smokeEmt1.setXSpeed(0, 50);
		smokeEmt1.setYSpeed(80, -180);
		
		// Emitter for fight
		smokeEmt2 = new FlxEmitter(0, 0);
		smokeEmt2.width = 65; smokeEmt2.height = 10;
		smokeEmt2.makeParticles("assets/img/smoke.png", 10, 5, true, 0);
		smokeEmt2.setXSpeed(-50, 50);
		smokeEmt2.setYSpeed(-30, -10);
		smokeEmt2.start(false, 0.5, 0.2, 15); 
		
		// ui
		baseHPBg = new FlxSprite(0, 0, "assets/img/baseHPBg.png");
		baseHPBg.x = sBase.getMidpoint().x - baseHPBg.width * 0.5;
		baseHPBg.y = sBase.y - 50; 
		if(baseHPBg.y < 20)	baseHPBg.y = 20;
		baseHPBg.visible = false;

		baseHPBar = new FlxSprite(0, 0);
		baseHPBar.makeGraphic(30, 6, 0xff02da88);
		baseHPBar.origin.set(0,0);
		baseHPBar.x = baseHPBg.x + 1;
		baseHPBar.y = baseHPBg.y + 1; 
		if(baseHPBar.y < 20)	baseHPBar.y = 20;
		baseHPBar.visible = false;
		
		
		// Addings
		add(breakers);
		AddAll();
		
		// initial
		bot.On = false;
		ResUtil.playGame1();
		bgMetal.visible = false;
		FlxG.camera.flash(0xff000000, 2);
		FlxG.camera.scroll = posCam1;
		roam = true;
		boss1.animation.play("air");
		//ShowSkip(true, initForGame);

		ShowSceneName("2 - Moon Surface Base");

		TweenCamera(posCam2.x, posCam2.y, 3, true, function(){
			roam = false;
			roamDone = true;

			// Create enemy
			boss1.x = posBInSrc.x; boss1.y = posBInSrc.y;boss1.FireOn = true;
			FlxTween.quadMotion( boss1 , posBInSrc.x, posBInSrc.y, posBInCtrl.x, posBInCtrl.y, posBIn.x, posBIn.y, 4, true, {type:FlxTween.ONESHOT, ease:FlxEase.sineOut} );

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

			FlxTimer.start(4.5, function(t:FlxTimer){
				lineMgr.Start(lines1, function(){
					FlxTimer.start(0.8, function(t:FlxTimer){
						for (grd in guards.members)
							if(grd!=null) grd.kill();
						for (b in Bees.members)
							if(b!=null) b.kill();

						// compare anim
						AddHugeExplo(exploPos1.x, exploPos1.y);
						for (c in cubes.members) {
							if(c==null) continue;
							var cb:Cube = cast(c, Cube);
							if(cb.alive && cb.isBomb && cb.group == 0)
								cb.kill();
							else if(cb.alive && !cb.isBomb && cb.group == 0){
								cb.angularVelocity = -90 + Math.random() * 180;
								cb.acceleration.y = 200;
								cb.velocity.x = -300 + Math.random() * 600;
								cb.velocity.y = -100 + Math.random() * -300; 
							}
						}
						FlxG.camera.flash(0xffffffff, 0.1, function(){
							bShakeTween = FlxTween.linearMotion(boss1, boss1.x-3, boss1.y, boss1.x+3, boss1.y, 0.1, true, {type:FlxTween.PINGPONG, ease:FlxEase.cubeInOut});
							boss1.animation.play("airShock");
							FlxTimer.start(1.0, function(t:FlxTimer){
								bShakeTween.cancel();
							});
							FlxTimer.start(1.0, function(t:FlxTimer){
								AddHugeExplo(exploPos2.x, exploPos2.y);
								for (c in cubes.members) {
									if(c==null) continue;
									var cb:Cube = cast(c, Cube);
									if(cb.alive && cb.isBomb && cb.group == 1)
										cb.kill();
									else if(cb.alive && !cb.isBomb && cb.group == 1){
										cb.angularVelocity = -90 + Math.random() * 180;
										cb.acceleration.y = 200;
										cb.velocity.x = -300 + Math.random() * 600;
										cb.velocity.y = -100 + Math.random() * -300; 
									}
								}
								FlxG.camera.flash(0xffffffff, 0.2, null);
							});
						});

						FlxTimer.start(2.5, function(t:FlxTimer){
							boss1.enableFloat(false);
							boss1.animation.play("fall");
							FlxTimer.start(1.5, function(t:FlxTimer){boss1.animation.play("idle");});
							boss1.bossFire.animation.play("off");
							FlxTween.linearMotion( boss1, boss1.x, boss1.y, boss1.x, posBInLand.y, 1.5, true, {type:FlxTween.ONESHOT, ease:FlxEase.quadInOut, complete:function(t:FlxTween){
								FlxTimer.start(0.5, function(t:FlxTimer){
									lineMgr.Start(lines2, function(){
										dash = true;
										boss1.animation.play("walk");
										smokeEmt1.start(false, 0.5, 0.03, 0);
										smokeEmt1.on = true;
										FlxG.camera.follow(boss1, FlxCamera.STYLE_LOCKON, null, 0.5);
										FlxTween.linearMotion(boss1, boss1.x, boss1.y, posBStart.x, posBStart.y, 7, true, {type:FlxTween.ONESHOT, ease:FlxEase.quadInOut, complete:function(t:FlxTween){
										//var bDashTween:LinearMotion = new LinearMotion(function(t:FlxTween){
											dash = false;
											dashDone = true;
											boss1.velocity.x = 0;
											boss1.animation.play("idle");
											smokeEmt1.on = false;

											birthRay.x = 150;
											birthRay.y = bot.y + bot.height - birthRay.height*birthRay.scale.y;
											birthRay.animation.play("birth");
											bot.x = start.x;
											bot.y = start.y;

											FlxG.camera.follow(null);
											TweenCamera(posCam3.x, posCam3.y, 2, true, function(){
												trace("line should start !");
												lineMgr.Start(lines3, function(){
													tipManager.ShowTip(TipManager.Tip_Master1, function(){
														bot.On = true;
														boss1.switchState(1);
														ShowBossHP(true);
														baseHPBg.visible = true;
														baseHPBar.visible = true;
														hpBar.visible = true;
													});
												});
											});
										}});
									});
								});
							}});
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

		bot.x = 152;
		bot.y = 130;
		bot.On = true;

		boss1.reset(posBStart.x, posBStart.y);
		boss1.switchState(1);
		boss1.FireOn = false;
		boss1.facing = FlxObject.LEFT;
		boss1.animation.play("idle");

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
			if(c == null) continue;
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
			if(guards.members[i]==null) continue;
			var gd:Guard = cast(guards.members[i], Guard);
			if(gd.x <= posGrdAry[i].x){
				gd.On = false;
				gd.velocity.x = 0;
			}
		}

		smokeEmt1.x = boss1.x;
		smokeEmt1.y = boss1.y + boss1.height;

		smokeEmt2.x = boss1.getMidpoint().x;
		smokeEmt2.y = landHeight;

		//tileBreak.overlapsWithCallback(boss, onBreak);
		//tileBreak.overlaps(boss);

		// NOTE ! breakers.members may get null gap ! use for-in with null check 
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
		if (lvlState == STpostTalk){	// used in Boss1.hx
			ShowBossHP(false);
			bot.On = false;
			baseHPBar.visible = false;
			baseHPBg.visible = false;
			lineMgr.Start(lines4, function(){boss1.switchState(8); lvlState = 4;});
		}
		else if (lvlState == 5){				// used in Boss1.hx
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