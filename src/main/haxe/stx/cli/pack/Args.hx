package stx.cli.pack;

@:forward(map,join,length,is_defined) abstract Args(Array<Dynamic>) from Array<Dynamic>{
  @:arrayAccess
  public function get(int:Int):Dynamic{
    return this[int];
  }
  public function toString(){
    return this.join(", ");
  }
  public function tail():Args{
    return this.tail();
  }
  public function prj():Array<Dynamic>{
    return this;
  }
}