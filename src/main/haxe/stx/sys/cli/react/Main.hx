package stx.sys.cli.react;

using stx.sys.cli.Logging;

class Main{
  static public var handlers(get,null) : Queue<ProgramApi>;
  static public function get_handlers(){
    return handlers == null ? handlers = new Queue() : handlers;
  }
  static public function main(){
    trace("main");
    final LC            = __.log().logic();
    // final logic         = LC.tags([
    //   //'eu/ohmrun/fletcher',
    //   //'stx/stream',
    //   //'stx/stream/DEBUG',
    //   //'stx/parse',
    //   //'**',
    //   //'**/*',
    //   "stx/sys/cli",
    //   //'stx/io',
    //   //'**/**/*',
    //   //"stx/asys",
    //   //"stx/proxy"
    // ]).and(LC.level(TRACE));

    // __.logger().global().configure(
    //   log -> log.with_logic(l -> {
    //     final n = l.or(logic);
    //     //trace(n.toString());
    //     return n;
    //   })
    // );
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
        res -> {
          __.log().debug('$res');
          return new Executor().execute(res);
        }
      );
    return executor;
  }
  static public function react(){
    stx.sys.cli.react.Main.reply().environment(
      () -> {
        __.log().info('done');
      },
      (e) -> {
        __.log().fatal('$e');
        e.raise();
      }
    ).submit();
  }
}