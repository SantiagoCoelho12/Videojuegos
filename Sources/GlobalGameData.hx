import com.gEngine.display.Camera;
import com.gEngine.display.Layer;
import gameObjects.Player;

typedef GGD = GlobalGameData;

class GlobalGameData {
	public static var player:Player;
	public static var simulationLayer:Layer;
	public static var camera:Camera;

	public static function destroy() {
		player.destroy();
		player = null;
		simulationLayer = null;
		camera = null;
	}
}
