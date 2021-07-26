package stx;

using stx.Async;
using stx.Pico;
using stx.Nano;
using stx.Log;

import stx.cli.Package;

import tink.priority.Queue;

class Cli{
  static public var handlers(default,never) : Queue<HandlerApi> = new Queue();
  static public function main(){

    var context   = stx.cli.pack.Context.unit();
    
    __.log()(context.info());
    var executor  = new Executor(context);
    var result    = executor.execute(); 
        result.environment(
          () -> {},
          (e) -> {
            trace(e);
            Sys.exit(1);
          }
        ).submit();
  }
}