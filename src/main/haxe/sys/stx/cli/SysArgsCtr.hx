package sys.stx.cli;

@stx.meta(["ctr"])
class SysArgsCtr{
  static public function unit(self:STX<SysArgs>){
    final is_haxelib_run  = Sys.env("HAXELIB_RUN") == "1";
    final args            = Sys.args(); 
    return new SysArgs(is_haxelib_run,args);
  }
}