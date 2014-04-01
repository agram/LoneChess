import Common;

class Titre extends hxd.App {
	public static var inst : Titre;	
	var bmp:h2d.Bitmap;
	var interactive:h2d.Interactive;
	
	public var board:h2d.Layers;
	public var texte:h2d.Text;
	public var anims:Array<h2d.Anim>;
	
	override function init() {
		s2d.setFixedSize(Const.MAP_WIDTH, Const.MAP_HEIGHT);
		engine.backgroundColor = 0x68AFD8;
		board = new h2d.Layers();
		s2d.add(board, Const.L_GROUND);
		
		//bmp = new h2d.Bitmap(Res.titre.toTile());
		//bmp.scale(0.5);
		//bmp.x = (Const.MAP_WIDTH - width) / 2 ;
		//bmp.y = (Const.MAP_HEIGHT - height) / 2;
		//bmp.colorKey = 0xFFFFFF;
		//s2d.addChild(bmp);
		
		var font = Res.Minecraftia.build(24, { antiAliasing : false } );
		var texte = new h2d.Text(font, s2d);
		texte.text = 'LONE CHESS';
		texte.x = 35;
		texte.y = 70;

		var font = Res.Minecraftia.build(12, { antiAliasing : false } );
		var texte = new h2d.Text(font, s2d);
		texte.text = 'Clic to play';
		texte.x = 70;
		texte.y = 150;

		interactive = new h2d.Interactive(s2d.width, s2d.height, s2d);
		interactive.cursor = Default;
		interactive.onRelease = function(_) {
			bmp.remove();
			interactive.remove();
			startGame ();
		};
	}		
	
	function startGame () {
		bmp.remove();
		interactive.remove();
		
		s2d.dispose();
		Game.inst = new Game(engine);
	}
	
	public static function main() {	
		hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create(null,{compressSounds:true}));
		inst = new Titre();
	}
}