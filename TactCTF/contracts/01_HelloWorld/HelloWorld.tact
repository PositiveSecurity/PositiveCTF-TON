import "../BaseLevel.tact";
import "@stdlib/deploy";

contract HelloWorld with Deployable, BaseLevel {
    completed: Bool;
    init(){
        self.completed = false;
    }

    receive("LevelCompleted"){
        self.completed = true;
    }
}