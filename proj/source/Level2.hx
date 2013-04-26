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

class Level2 extends Level
{
	public static var STpreDash 	: Int = 0;
	public static var STpreTalk 	: Int = 1;
	public static var STfight		: Int = 2;
	public static var STpostTalk	: Int = 3;

	public var lvlState : Int;	// 0-preDash 1-preTalk 2-fight 3-postTalk

	public static var xExtend:Float = 550 * 4.5;

	// tile breakers
	public var breakers:FlxGroup;
	public var brGP:FlxSprite;
	public var brBody:FlxSprite;
	public var brHandR:FlxSprite;
	public var brLeg:FlxSprite;
	public var brHandL:FlxSprite;

	// Boss Fighting Constant
	public static var bossX:Float = 464 - 77;
	public static var bossY:Float = 360 - 95 - 8;//304 - 77;
	public static var bossBury:Float = 200;
	public static var bossPreDashSpeed :Float = 5;

	// Camera Constant
	public static var camMoveTime:Float = 1*75;

	// Surface Base
	public var sbLife:Float;
	public var tSBHeal:FlxText;

	public var posBeeAry:Array<FlxPoint>;
	public var posGrdAry:Array<FlxPoint>;
	public var posBIn:FlxPoint;
	public var posBStart:FlxPoint;

	public var posCam1:FlxPoint;
	public var posCam2:FlxPoint;
	public var posCam3:FlxPoint;

	public var roam:Bool;
	public var roamDone:Bool;

	public var dash:Bool;
	public var dashDone:Bool;

	public var fighting:Bool;
	public var fightDone:Bool;

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

	override public function create():Void
	{
		super.create();
		
		GameStatic.CurLvl = 2;
		lvlState = 0;
		bossBury = 300;
		
		// Load Tiles
		tileUp 		= GetTile("tileUp", FlxObject.UP); 
		tileBreak 	= GetTile("break", FlxObject.ANY); 
		tileBreak.setTileProperties(0, FlxObject.ANY , onBreak, null, tileBreak._tileObjects.length);	// set all breakable to handle collision
		
		sBase = new FlxSprite(13 * 20, 20 * 5 + 10, "assets/img/sBase.png");
		sBase.offset = new FlxPoint(121, 42);
		sBase.width = 60; sBase.height = 75;
		sBase.health = 100;
		
		boss1 = new Boss1(bossX + xExtend, bossY/* + bossBury*/, this); 	// final pos 10, 230
		
		smokeEmt1 = new FlxEmitter(550, 375);
		smokeEmt1.x = xExtend - 100;			// x pos for preDash;
		smokeEmt1.y = 265 + 100;
		smokeEmt1.makeParticles("assets/img/smoke.png", 10, 5, true, 0);
		smokeEmt1.start(false, 0.5, 0.03, 0);
		smokeEmt1.setXSpeed(0, 50);
		smokeEmt1.setYSpeed(80, -180);
		
		smokeEmt2 = new FlxEmitter(-100, 0);
		smokeEmt2.width = 65; smokeEmt2.height = 10;
		smokeEmt2.makeParticles("assets/img/smoke.png", 10, 5, true, 0);
		smokeEmt2.setXSpeed(-50, 50);
		smokeEmt2.setYSpeed(-30, -10);
		
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
		
		tSBHeal = new FlxText(10, 100, 100);

		// datas
		var fd:TmxObjectGroup = tmx.getObjectGroup("misc");
		for (td in fd.objects) {
			if(td.type == "posBee")
				posBeeAry.push(new FlxPoint(td.x, td.y));
			else if(td.type == "posGuard")
				posGrdAry.push(new FlxPoint(td.x, td.y));
			else if(td.name == "posBIn")
				posBIn = new FlxPoint(td.x, td.y);
			else if(td.name == "posBStart")
				posBStart = new FlxPoint(td.x, td.y);
			else if(td.name == "cam1")
				posCam1 = new FlxPoint(td.x, td.y);
			else if(td.name == "cam2")
				posCam2 = new FlxPoint(td.x, td.y);
			else if(td.name == "cam3")
				posCam3 = new FlxPoint(td.x, td.y);
		}
		
		// Addings
		add(breakers);
		AddAll();
		add(tSBHeal);
		
		// initial
		bot.On = false;
		ResUtil.playGame1();
		bgMetal.visible = false;
		FlxG.flash(0xff000000, 2);
		FlxG.camera.scroll = posCam1;
		roam = true;
		tileCover.visible = false;
	}

	override public function update():Void
	{
		if(roam){
			FlxG.camera.scroll.x += FlxG.elapsed * 150;
			if(FlxG.camera.scroll.x > posCam2.x) {
				roam = false;
				roamDone = true;
				// Create enemy
				boss1.x = posBIn.x; boss1.y = posBIn.y;
				for (grdPos in posGrdAry) {
					var grd:Guard = new Guard(grdPos.x + 10, grdPos.y);
					grd.velocity.x = -100;
					guards.add(grd);
				}
				for (bp in posBeeAry) {
					var bee:Bee = new Bee(bp.x, bp.y); 
					bee.resetMode(bp.x, bp.y, "Monk");
					bee.target = bot;
					Bees.add(bee);
				}

				timer1.start(3, 1, function(t:FlxTimer){
					lineMgr.Start(lines1, function(){
						for (grd in guards.members)grd.kill();
						for (b in Bees.members)b.kill();
						timer1.start(2, 1, function(t:FlxTimer){
							lineMgr.Start(lines2, function(){
								dash = true;
								boss1.velocity.x = -400;
								smokeEmt1.on = true;
							});
						});
					});
				});
			}
		}

		if(dash){
			if(boss1.x < posBStart.x){
				dash = false;
				dashDone = true;
				boss1.velocity.x = 0;
				FlxG.camera.scroll = posCam3;
				birthRay.x = 150;
				birthRay.play("birth");
				bot.x = 152;
				bot.y = 130;
				smokeEmt1.on = false;
				lineMgr.Start(lines3, function(){
					bot.On = true;
					boss1.switchState(1);
					ShowBossHP(true);
				});
			}
		}

		// camera
		if(dash){
			FlxG.camera.scroll.x = boss1.x - FlxG.width/2;
		}
		if(dashDone  && !fightDone){
			if(Math.abs(FlxG.camera.scroll.x - posCam3.x) > 3){
				FlxG.camera.scroll.x -= 5;
			}
			else{
				FlxG.camera.scroll = posCam3;
			}
		}

		// handle guards
		if(guards.countLiving()==2){
			if(cast(guards.members[0], Guard).x <= posGrdAry[0].x)
				cast(guards.members[0], Guard).On = false;
			if(cast(guards.members[1], Guard).x <= posGrdAry[1].x)
				cast(guards.members[1],Guard).On = false;
		}

		// smoke
		if(dash){
			smokeEmt1.x = boss1.x;
			smokeEmt1.y = 360 - 5;
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
		tileBreak.overlaps(breakers);
		FlxG.overlap(boss1, bullets, function(b:FlxObject, bul:FlxObject){b.hurt(1);bul.kill();});	// bullet
		FlxG.collide(tile, ducks, duckHitTile);							// duck
		FlxG.collide(tileUp, ducks);		
		FlxG.overlap(sBase, ducks, function(b:FlxObject, d:FlxObject) {b.hurt(10);d.kill();});
		
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
		tSBHeal.text = Std.string(sBase.health);
		
		smokeEmt2.x = boss1.x;
		smokeEmt2.y = 360 - 5;
		
		super.update();	
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