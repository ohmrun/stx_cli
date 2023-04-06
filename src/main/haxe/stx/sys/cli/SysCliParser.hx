package stx.sys.cli;

/**
 * Parser designed to pull a cluster of `CliToken`s from `Sys.args`
 */
class SysCliParser{
  static private function args(){
    return std.Sys.args();
  }
  static public function reply(){
    return apply(args());
  }
  static public function apply(args:Cluster<String>){
    return (parse(args).toRes().fold(
      x   -> __.accept(x.fold(cls -> cls,() -> Cluster.unit())), 
      er  -> __.reject(er.errate(e -> E_Cli_Parse(e)))
    ));
  }
  static public function parse(self:Cluster<String>):ParseResult<String,Cluster<CliToken>>{
    final reader = LiftClusterReader.reader(self);
    return value().apply(reader);
  }
  static public function value():Parser<String,Cluster<CliToken>>{
    return Parsers.Something().sub(
      (opt:Option<String>) -> opt.fold(
        ok -> __.couple(ok.reader(),
          CliParser.opt().or(CliParser.arg())
        ),
        () -> __.couple(''.reader(),Parsers.Failed('no value'))
      )
    ).one_many().then(x -> x.flat_map(x -> x));
  }
}