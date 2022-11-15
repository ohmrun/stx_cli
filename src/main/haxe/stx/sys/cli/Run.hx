package stx.sys.cli;

class Run{
  static public var handlers(default,never) : Queue<Program> = new Queue();
  static public function main(){
    trace("init");
    final log       = __.log().global;
          //log.includes.push('eu/ohmrun/fletcher');
          //log.includes.push('stx/stream');
          //log.includes.push('stx/stream/DEBUG');
          //log.includes.push('stx/parse');
          //log.includes.push('**');
          //log.includes.push('**/*');
          log.includes.push("stx/sys/cli");
          log.includes.push('stx/io');
          //log.includes.push('**/**/*');
          log.level = DEBUG;
          log.includes.push("stx/asys");
          log.includes.push("stx/io");
    
    //handlers.add({ data : new stx.sys.cli.term.Command() });
    //handlers.add({ data : new stx.sys.cli.term.Echo() });

    final context   = stx.sys.cli.CliContext.pull(__.sys().cwd().get(),SysArgs.unit());
    final executor  = 
      Produce.lift(Fletcher.Then(
        context,
        Fletcher.Sync(
          (x:Res<CliContext,CliFailure>) -> __.accept(x)
        )
      )).point(
        res -> new Executor().execute(res)
      );

    executor.environment(
        () -> {
          __.log().info('done');
        },
        (e) -> {
          e.raise();
        }
      ).submit();
  }
}