import Common;

class Message extends h2d.ScaleGrid
{
	public var texte:h2d.Text;
	public var i:h2d.Interactive;
	var game:Game;

	public function new() 
	{
		game = Game.inst;
		super(game.gfx.message.main[0], 8, 8);
		visible = true;
		colorKey = 0xFFFFFFFF;
		width = 100;
		height = 40;
		
		x = Const.WIDTH / 2 - 50;
		y = Const.HEIGHT / 2 - 20;
		
		var font = Res.Minecraftia.build(12, { antiAliasing : false } );
		texte = new h2d.Text(font);
		texte.color = new h3d.Vector();
		texte.x = 20;
		texte.y = 10;
		this.addChild(texte);

		i = new h2d.Interactive(Const.WIDTH, Const.HEIGHT, game.boardUi);
		i.onClick = function (_) {
			i.remove();
			remove();
		}
		
		game.boardUi.addChild(this);
	}
	
}