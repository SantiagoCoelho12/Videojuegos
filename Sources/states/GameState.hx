package states;

import com.framework.utils.Input;
import com.gEngine.display.Layer;
import com.gEngine.GEngine;
import com.framework.utils.Random;
import com.gEngine.helper.Screen;
import kha.math.FastVector2;
import com.gEngine.display.Sprite;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.State;

class GameState extends State {

    var screenWidth:Int;
    var screenHeight:Int;

    override function load(resources:Resources) {

        screenWidth = GEngine.i.width;
        screenHeight = GEngine.i.height;
    }
    
    override function init() {
       
    }
    override function update(dt:Float) {
        super.update(dt);
    }
    override function render() {
        super.render();
    }
}