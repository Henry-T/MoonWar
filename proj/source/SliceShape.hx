package;
import nme.display.BitmapData;
import nme.geom.Rectangle;
import nme.geom.Point;
import org.flixel.FlxSprite;

// slice bimmap and extract to shape like panels or buttons
class SliceShape extends FlxSprite
{
	private var paddin:Int;		// for pixel art only
	public var scratchLen:Int;	// scratch space to fill
	private var pixelCache:BitmapData;	// backup before modify original bitmap
	private var _myRect:Rectangle;
	private var _myPoint:Point;

	public function new(x:Int=0, y:Int=0, width:Int=80, height:Int=60, simpleGraphics:Dynamic=null, paddin=0){
		super(x, y, simpleGraphics);
		this.width = width;
		this.height = height;
		this.paddin = paddin;
		scratchLen = _pixels.width - paddin * 2;

		// make a backup for origin bitmap for we will alt _pixels later
		pixelCache = new BitmapData(Std.int(_pixels.rect.width), Std.int(_pixels.rect.height));
		pixelCache.copyPixels(_pixels, _pixels.rect, _flashPointZero);
		
		_myRect = new Rectangle(); 
		_myPoint = new Point();
	}

	// update when exact pixel size changed
	public function rebuildGraphic(){
		// build corners
		_myRect.setTo(0, 0, paddin, paddin);
		_myPoint.setTo(0, 0);
		_pixels.copyPixels(pixelCache, _myRect, _myPoint);

	}

	// resize
	public function setSize(width:Int, height:Int){
		this.width = width; this.height = height;
		rebuildGraphic();
	}
}