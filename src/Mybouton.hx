import Common;

class Mybouton
{
	var mcSelected:h2d.Graphics;
	var game:Game;
	public var interactive:h2d.Interactive;
	
	public function new(numero, t) 
	{
		game = Game.inst;		
		
		mcSelected = new h2d.Graphics(game.boardUi);
		mcSelected.beginFill(0xFF978E7E);
		mcSelected.drawRect(0, 0, 100, 20);
		mcSelected.alpha = 1;
		mcSelected.endFill();
		mcSelected.x = 280;
		mcSelected.y = numero;
		
		//var fg = h2d.Tile.fromColor(0x80808080, 10, 10);
		//var a = new h2d.Bitmap(fg, mcSelected);
		//a.x = -5;
		//a.y = -5;
		
		var font = Res.Minecraftia.build(8, { antiAliasing : false } );
		var texte = new h2d.Text(font, mcSelected);
		texte.color = new h3d.Vector();
		texte.x = 5;
		texte.y = 5;
		texte.text = t;
		
		interactive = new h2d.Interactive(100, 20, mcSelected);
	}
	
}