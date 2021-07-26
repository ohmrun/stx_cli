package cmd.store;

using stx.cli.Package;

import sys.io.File;
import haxe.io.Path;

class Append extends Implementation{
  
  override public function reply():Execute<CliFailure>{
    var value     = switch(this.args){
      case [Isolate(PString(str))] : str;
      default : throw this.args;
    }
    var fname     = 'store.hxl';
    var dir       = new Path(context.calling_directory.fudge());
    var archive   = '$dir$fname';
    var handle    = File.append(archive,false);
        handle.writeString(value+'\n');
    return Execute.unit();
  }
}
//abstract Interpret{
  //static var instance(default,null) : Map<String,
//}
class Create extends Command{
  public function new(){
    super('touch',[Literal('store.hxl')]);
  }
}
// class Pull extends Implementation{
//   private var interpreter   : String;
//   public function new(interpreter:String){
//     this.interpreter = interpreter;
//   }
// }