package stx.sys.cli;

enum CliTokenSum{  
  Isolate(prim:Primitive);
  Special(name:String);
  Literal(lit:String);
  Accessor(lit:String);
  Suggest(name:String,double:Bool);
}
abstract CliToken(CliTokenSum) from CliTokenSum to CliTokenSum{
  public function new(self) this = self;
  static public function lift(self:CliTokenSum):CliToken return new CliToken(self);

  public function prj():CliTokenSum return this;
  private var self(get,never):CliToken;
  private function get_self():CliToken return lift(this);

  static public function isolate(self:Primitive){
    return lift(Isolate(self));
  }
  static public function special(self:String){
    return lift(Special(self));
  }
  static public function literal(self:String){
    return lift(Literal(self));
  }
  static public function accessor(self:String){
    return lift(Literal(self));
  }
  static public function suggest(name:String,double:Bool){
    return lift(Suggest(name,double));
  }
}