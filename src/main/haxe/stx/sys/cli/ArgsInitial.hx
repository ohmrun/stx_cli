package stx.sys.cli;

@:forward(length) abstract ArgsInitial(Array<Dynamic>) from Array<Dynamic>{
  private function new(){
    this = __.sys().args();
  }
  static public inline function inj() return ArgsInitialConstructor.ZERO;
  public function is_haxelib_run(){
    return __.sys().env("HAXELIB_RUN") == "1";
  }
  public function method(){
    return is_haxelib_run() ? ExecutingHaxelibRun : ExecutingScript;
  }
  
  public function args_not_including_call_directory():Args{
    return is_haxelib_run().if_else(
      () -> this.rdropn(1),
      () -> this
    );
  }
  public function calling_directory():Option<String>{
    return is_haxelib_run().if_else(
      () -> this.last().map(Std.string),
      () -> None
    );
  }
  public function prj():Array<Dynamic>{
    return this;
  }
  public function toArguments(){

  }
}
@:access(stx.sys.cli) class ArgsInitialConstructor extends Clazz{
  static public var ZERO = new ArgsInitialConstructor();
  public function unit(){
    return new ArgsInitial();
  }  
}