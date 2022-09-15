package stx.sys.cli;

enum CliTokenSum{
  Opt(tok:String);
  Arg(str:String);
}
abstract CliToken(CliTokenSum) from CliTokenSum to CliTokenSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:CliTokenSum):CliToken return new CliToken(self);

  public function prj():CliTokenSum return this;
  private var self(get,never):CliToken;
  private function get_self():CliToken return lift(this);

  static public function arg(self:String){
    return lift(Arg(self));
  }
  static public function opt(name:String){
    return lift(Opt(name));
  }
}