package stx.cli.pack;

@:forward(length)abstract ArgumentsParsed(Array<CliToken>) from Array<CliToken> to Array<CliToken>{
  public function new(self) this = __.option(self).defv([]);
  @:arrayAccess
  public function get(int:Int):CliToken{
    return this[int];
  }
  static public function lift(self:Array<CliToken>):ArgumentsParsed return new ArgumentsParsed(self);
  
  public function specials():Array<String>{
    return this.map_filter(
      (x) -> switch(x){
        case Special(v) : Some(v);
        default         : None;
      }
    );
  }
  public function args_without_specials():StdArray<Dynamic>{
    return this.lfold(
      (next:CliToken,memo:Array<String>) -> switch(next){
        case Special(s)           : memo;
        case Isolate(prim)        : memo.snoc(prim.toAny());
        case Accessor(lit)        : memo.snoc(lit);
        case Literal(lit)         : memo.snoc(lit);
        case Suggest(name,false)  : memo.snoc('-$name');
        case Suggest(name,true)   : memo.snoc('--$name'); 
      },
      []
    ).prj();
  }
  public function tail():ArgumentsParsed{
    return this.tail();
  }  

  public function prj():Array<CliToken> return this;
  private var self(get,never):ArgumentsParsed;
  private function get_self():ArgumentsParsed return lift(this);
}