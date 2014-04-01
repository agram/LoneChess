import Common;

class Message extends h2d.ScaleGrid
{
	public var texte:h2d.Text;
	public var i:h2d.Interactive;
	var game:Game;

	public function new(width, height) 
	{
		game = Game.inst;
		super(game.gfx.message.main[0], 8, 8);
		visible = true;
		colorKey = 0xFFFFFFFF;
		this.width = width;
		this.height = height;
		
		x = Const.WIDTH / 2 - width / 2;
		y = Const.HEIGHT / 2 - height / 2;
		
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