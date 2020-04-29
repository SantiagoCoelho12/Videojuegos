package states;

import com.gEngine.display.Layer;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.loading.Resources;
import com.framework.utils.State;
import gameObjects.Player;

class GameOver extends State {
    var score:String;
    var julia:Player;
    var time:Float=0;
	var simulationLayer:Layer;


    public function new(/*score:String*/) {
        super();
       // this.score=score;
    }

    override function load(resources:Resources) {
        //var atlas:JoinAtlas=new JoinAtlas(1024,1024);
		//atlas.add(new SparrowLoader("julia", "julia_xml"));
        //atlas.add(new ImageLoader("gameOver"));
        //atlas.add(new FontLoader(Assets.fonts.Kenney_ThickName,30));
        //resources.add(atlas);
    }

    override function init() {
        //var image=new Sprite("gameOver");
        //image.x=GEngine.virtualWidth*0.5-image.width()*0.5;
        //image.y=100;
        //stage.addChild(image);
        //var scoreDisplay=new Text(Assets.fonts.Kenney_ThickName);
        //scoreDisplay.text="Your score is "+score+"\n\n\n Press enter to play again";
        //scoreDisplay.x=GEngine.virtualWidth/2-scoreDisplay.width()*0.5;
        //scoreDisplay.y=GEngine.virtualHeight/2;
        //scoreDisplay.color=Color.Red;
        //stage.addChild(scoreDisplay);
        //simulationLayer = new Layer();
		//stage.addChild(simulationLayer);
        //julia = new Player(1024 / 2, 720 / 2, simulationLayer);
        //addChild(julia);
        //julia.damage();

    }
    
    override function update(dt:Float) {
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.Return)){
            changeState(new GameState()); 
        }
    }
}