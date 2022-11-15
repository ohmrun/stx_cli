package stx.sys.cli;

@:forward(length) abstract SysArgs(Cluster<Dynamic>) from Cluster<Dynamic>{
  static public function unit(){
    return new SysArgs();
  }
  @:noUsing static public function pure(args){
    return new SysArgs(args);
  }
  private function new(?args){
    //trace(__.sys().args().imm());
    this = __.option(args).defv(__.sys().args().imm());
  }
  public function is_haxelib_run(){
    return __.sys().env("HAXELIB_RUN") == "1";
  }
  public function method(){
    return is_haxelib_run() ? ExecutingHaxelibRun : ExecutingScript;
  }
  public function args_not_including_call_directory():Cluster<Dynamic>{
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
  public function as_parseable_string(){
    return args_not_including_call_directory().map(
      (str:String) -> (str.contains(" ") || str.contains(" ") || str.contains("\n")).if_else(
        () -> (!StringTools.startsWith(str,'"')).if_else(
          () -> '"$str"',
          () -> str
        ),
        () -> str
      )
    ).join("");
  }  
  public function prj():Cluster<Dynamic>{
    return this;
  }
  public function toArguments(){

  }
}
class SysArgsLift{

}