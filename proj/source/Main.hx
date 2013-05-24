package;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.Lib;
import nme.ui.Keyboard;
import org.flixel.FlxGame;
import mochi.as3.MochiAd;
import mochi.as3.MochiServices;
 
/**
 * @author Joshua Granick
 */
class Main extends Sprite 
{
	
	public function new () 
	{
		super();
		
		if (stage != null) 
			init();
		else 
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function AllowDomain():Bool{
		if(loaderInfo == null)
			return false;	// don't allow local play
		var curUrl:String = this.loaderInfo.url;
		var siteUrl = curUrl.split("://")[1].split("/")[0];
		if(siteUrl == "www.flashgamelicense.com" || siteUrl == "www.flashgamelicense.com")
			return true;
		return false;
	}
	
	private function init(?e:Event = null):Void 
	{
		#if flash
		#if !debug
		if(!AllowDomain()){
			this.alpha = 0;
			return;
		}
		#end
		#end

		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		initialize();

		//var _mochiads_game_id:String = "8c1974c3dc338c76";
		//MochiServices.connect("8c1974c3dc338c76", root);
		//MochiAd.showPreGameAd({clip:root, id:"2d8d1d2659355cf2", res:"550x400"});
		var game:FlxGame = new MWGame();
		addChild(game);
		
		#if (cpp || neko)
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUP);
		#end

	}
	
	#if (cpp || neko)
	private function onKeyUP(e:KeyboardEvent):Void 
	{
		if (e.keyCode == Keyboard.ESCAPE)
		{
			Lib.exit();
		}
	}
	#end
	
	private function initialize():Void 
	{
		Lib.current.stage.align = StageAlign.TOP;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
	}
	
	// Entry point
	public static function main() {
		
		Lib.current.addChild(new Main());
	}
	
}