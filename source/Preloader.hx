package ;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.events.Event;

@:bitmap("assets/img/bgStar.png") class BackgroundBD extends BitmapData {}

class Preloader extends NMEPreloader
{
 private var background:Bitmap;
 
 public function new()
 {
	super();

	background = new Bitmap(new BackgroundBD(550, 400));
	addChildAt (background, 0);
 }

 public override function onLoaded()
	{
		dispatchEvent (new Event (Event.COMPLETE));
	}
}