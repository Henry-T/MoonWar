package;

import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.FlxG;
import org.flixel.FlxPoint;

class LineMgr extends FlxSprite
{
	public var heads:Array<FlxSprite>;
	public var line:FlxText;
	public var lineBg:FlxSprite;

	public var finishCall:Void->Void;

	private var lines:Array<Line>;
	private var curLineId:Int;
	private var curHeadId:Int;
	private var lineCnt:Int;

	private static var  headPos:FlxPoint = new FlxPoint(8, 62);

	public function new():Void{ 	
		super(0,0,null);
		heads = new Array<FlxSprite>();

		lineBg = new FlxSprite(0, 50, "assets/img/lineBg.png"); lineBg.visible = false;
		lineBg.scrollFactor = new FlxPoint(0,0);
		line = new FlxText(100, 80, 400, ""); line.visible = false;
		line.scrollFactor = new FlxPoint(0,0);

		var h:FlxSprite;
		h = new FlxSprite(headPos.x,headPos.y,"assets/img/drHead.png");h.scrollFactor = new FlxPoint(0,0);
		heads.push(h);
		h = new FlxSprite(headPos.x,headPos.y,"assets/img/botHead.png");h.scrollFactor = new FlxPoint(0,0);
		heads.push(h);
		h = new FlxSprite(headPos.x,headPos.y,"assets/img/rmHead.png");h.scrollFactor = new FlxPoint(0,0);
		heads.push(h);
	}

	public function Start(lines:Array<Line>, finCall:Void->Void=null):Void{
		this.lines = lines;
		curLineId = -1;
		lineCnt = lines.length;
		finishCall = finCall;
		Next();
	}

	public function Next():Void{
		curLineId++;
		if(curLineId <= lineCnt-1){
			line.text = lines[curLineId].text;
			curHeadId = lines[curLineId].headId;
		}
		else{
			if(finishCall!=null)
				finishCall();
		}
	}

	override public function update(){
		if(FlxG.keys.justPressed("SPACE")){
			Next();
		}
		super.update();
	}

	override public function draw(){
		if(curLineId <= lineCnt-1){
			lineBg.draw();
			line.draw();
			heads[curHeadId].draw();
		}
		super.draw();
	}
}