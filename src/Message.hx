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
		width = Std.int(Const.DEPLOY_ZONE / 2);
		height = 48;
		
		x = Const.DEPLOY_ZONE / 4;
		y = Const.HEIGHT / 2 - 24;
		
		var font = Res.Minecraftia.build(6, { antiAliasing : false } );
		texte = new h2d.Text(font);
		texte.color = new h3d.Vector();
		texte.x = 8;
		texte.y = 8;
		this.addChild(texte);

		i = new h2d.Interactive(Const.WIDTH, Const.HEIGHT, this);
		i.x = -Const.DEPLOY_ZONE / 4;
		i.y = -Const.HEIGHT / 2 - 24;
		i.visible = false;
	}
	
}

class StatsTroup extends h2d.ScaleGrid
{
	public var texte:h2d.Text;
	public var i:h2d.Interactive;
	var game:Game;
	public var troupId:Int;
	
	public function new(troupId) 
	{
		game = Game.inst;
		super(game.gfx.message.statsTroup[0], 8, 8);
		this.troupId = troupId;
		visible = true;
		colorKey = 0xFFFFFFFF;
		width = Const.DEPLOY_ZONE_W - 1;
		height = 50;
		
		x = Const.DEPLOY_ZONE + 1;
		y = 0;
		
		var font = Res.Minecraftia.build(3, { antiAliasing : false } );
		texte = new h2d.Text(font);
		texte.color = new h3d.Vector();		
		texte.x = 8;
		texte.y = 8;
		this.addChild(texte);

		i = new h2d.Interactive(width, height, this);
		
		game.boardUi.addChild(this);
	}
	
	static public function showAllHero() {
		var i = 0;
		for (t in Game.inst.troups) {
			if(t.isPlayer()) {
				if (t.isHero) {
					t.icone.stats.visible = true;
					t.icone.stats.y = i++ * 50;
				}
				else {
					t.icone.stats.visible = false;
					t.icone.stats.y = 0;
				}
			}			
		}
	}
	
	static public function showAllTroups(hero:Hero) {
		
	}
}