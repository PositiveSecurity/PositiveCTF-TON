import "@stdlib/deploy";
import "../BaseLevel.tact";

contract Fuzzing with Deployable, BaseLevel {
    completed: Bool;
    steps: Int as uint32;
    m: Int as uint32;
    n: Int as uint32;
    o: Int as uint32;
    p: Int as uint32;
    q: Int as uint32;
    r: Int as uint32;
    s: Int as uint32;
    t: Int as uint32;
    init(){
        self.completed = false;
        self.steps = 0;
        self.m = 19;
        self.n = 12;
        self.o = 41;
        self.p = 33;
        self.q = 10;
        self.r = 4;
        self.s = 23;
        self.t = 12;
    }

    receive("alpha"){
        self.m += 15;
        self.n -= 5;
        self.o = self.o << 1;
        self.steps += 1;
    }

    receive("beta"){
        self.p += 10;
        self.q = self.q << 1;
        self.r -= 7;
        self.steps += 1;
    }

    receive("gamma"){
        self.s = self.s >> 1;
        self.t += 20;
        self.m = self.m << 1;
        self.steps += 1;
    }

    receive("delta"){
        self.n = self.n << 1;
        self.o += 12;
        self.p = self.p >> 1;
        self.steps += 1;
    }

    receive("epsilon"){
        self.q -= 8;
        self.r = self.r << 1;
        self.s += 5;
        self.steps += 1;
    }

    receive("zeta"){
        self.t = self.t << 1;
        self.m -= 9;
        self.n += 14;
        self.steps += 1;
    }

    receive("theta"){
        self.o -= 6;
        self.p += 7;
        self.q = self.q << 1;
    }

    receive("verify"){
        if (
            (((((((self.m + self.n) + self.o) + self.p) + self.q) + self.r) + self.s) + self.t) == 777 &&
            self.steps <= 15
        ) {
            self.completed = true;
        }
    }

    get fun steps(): Int {
        return self.steps;
    }

    get fun sum(): Int {
        return ((((((self.m + self.n) + self.o) + self.p) + self.q) + self.r) + self.s) + self.t;
    }
}