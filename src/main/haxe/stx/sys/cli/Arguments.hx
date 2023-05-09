package stx.sys.cli;

@:forward(length)abstract Arguments(Cluster<CliToken>) from Cluster<CliToken> to Cluster<CliToken>{
  public function new(self:Cluster<CliToken>) this = __.option(self).defv([].imm());
  @:arrayAccess
  public function get(int:Int):CliToken{
    return this[int];
  }
  @:noUsing static public function lift(self:Cluster<CliToken>):Arguments return new Arguments(self);
  
  public function tail():Arguments{
    return this.tail();
  }  

  public function prj():Cluster<CliToken> return this;
  private var self(get,never):Arguments;
  private function get_self():Arguments return lift(this);

  public function reader(){
    return stx.parse.lift.LiftArrayReader.reader(@:privateAccess this.prj());
  }
}