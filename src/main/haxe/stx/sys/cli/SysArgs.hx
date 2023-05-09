package stx.sys.cli;

class SysArgs{
  public final haxelib_run      : Bool;
  public final data             : Cluster<Dynamic>;

  public function new(haxelib_run,data){
    this.haxelib_run    = haxelib_run;
    this.data           = data;
  }
  public function is_haxelib_run(){
    return haxelib_run;
  }
  public function method(){
    return haxelib_run ?  ExecutingHaxelibRun : ExecutingScript;
  }
  public function args_not_including_call_directory():Cluster<Dynamic>{
    return is_haxelib_run().if_else(
      () -> data.rdropn(1),
      () -> data
    );
  }
  public function calling_directory():Option<String>{
    return is_haxelib_run().if_else(
      () -> data.last().map(Std.string),
      () -> None
    );
  }
}