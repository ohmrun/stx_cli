package stx.sys.cli;

@:forward(length)abstract Arguments(Cluster<CliToken>) from Cluster<CliToken> to Cluster<CliToken>{
  public function new(self:Cluster<CliToken>) this = __.option(self).defv([].imm());
  @:arrayAccess
  public function get(int:Int):CliToken{
    return this[int];
  }
  static public function lift(self:Cluster<CliToken>):Arguments return new Arguments(self);
  
  public function specials():Cluster<String>{
    return this.map_filter(
      (x) -> switch(x){
        case Special(v) : Some(v);
        default         : None;
      }
    );
  }
  public function args_without_specials():Cluster<Dynamic>{
    return this.lfold(
      (next:CliToken,memo:Cluster<String>) -> switch(next){
        case Special(s)           : memo;
        case Isolate(prim)        : memo.snoc(prim.toAny());
        case Accessor(lit)        : memo.snoc(lit);
        case Literal(lit)         : memo.snoc(lit);
        case Suggest(name,false)  : memo.snoc('-$name');
        case Suggest(name,true)   : memo.snoc('--$name'); 
      },
      []
    );
  }
  public function tail():Arguments{
    return this.tail();
  }  

  public function prj():Cluster<CliToken> return this;
  private var self(get,never):Arguments;
  private function get_self():Arguments return lift(this);
}