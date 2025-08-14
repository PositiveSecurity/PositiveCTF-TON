message UpgradeCode {
    newCode: Cell;
}
message ChangeOwner {
    newOwner: Address;
    pass: String;
}
message GetCounter {
    flag: Int as uint32;
}