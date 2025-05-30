import "@stdlib/deploy";
trait BaseLevel {
    completed: Bool;

    receive(msg: DeployOk){}

    get fun completed(): Bool {
        return self.completed;
    }
}