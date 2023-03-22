package stx.sys.cli;

using stx.sys.cli.Logging;

class Run{
  static public var handlers(get,null) : Queue<ProgramApi>;
  static public function get_handlers(){
    return handlers == null ? handlers = new Queue() : handlers;
  }
  static public function main(){
    trace("main");
    final log       = __.log().global;
          //log.includes.push('eu/ohmrun/fletcher');
          //log.includes.push('stx/stream');
          //log.includes.push('stx/stream/DEBUG');
          //log.includes.push('stx/parse');
          //log.includes.push('**');
          //log.includes.push('**/*');
          //log.includes.push("stx/sys/cli");
          //log.includes.push('stx/io');
          //log.includes.push('**/**/*');
          //log.level = DEBUG;
          //log.includes.push("stx/asys");
          //log.includes.push("stx/io");
    
    //handlers.add({ data : new stx.sys.cli.term.Command() });
    //handlers.add({ data : new stx.sys.cli.term.Echo() });

    react();
  }
  static public function reply(){
    __.log().debug('reply ${__.sys().cwd().get()} ${SysArgs.unit()}');
    final context   = stx.sys.cli.CliContext.pull(__.sys().cwd().get(),SysArgs.unit());
    final executor  = 
      Produce.lift(Fletcher.Then(
        context,
        Fletcher.Sync(
          (x:Res<CliContext,CliFailure>) -> {
            __.log().debug('$x');
            return __.accept(x);
          }
        )
      )).point(
        res -> new Executor().execute(res)
      );
    return executor;
  }
  static public function react(){
    stx.sys.cli.Run.reply().environment(
      () -> {
        __.log().info('done');
      },
      (e) -> {
        e.raise();
      }
    ).submit();
  }
}