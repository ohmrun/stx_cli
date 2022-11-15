package stx.sys.cli;

import stx.parse.Parser in Prs;
using stx.sys.cli.CliParser;

function id(str){
  return __.parse().id(str);
}
class CliParser{
  static public function g<T,U>(p:Prs<String,U>):Prs<String,U>{
    return Parse.gap.many()._and(p);
  }
  static public inline function eof<I,O>():AbstractParser<String,O> return g(stx.parse.Parsers.Eof());

  static public var literal       = Parse.literal.tagged('literal');
  static public var symbol        = Parse.symbol.tagged('literal');

  static public function word(){
    return literal.or(symbol);
  }

  static public function token() return g(Parse.primitive());
  static public var minus         = '-'.id();
  static public var double_minus  = '--'.id();

  public function new(){}

  public function parse(ipt:ParseInput<String>):Provide<ParseResult<String,Cluster<CliToken>>>{
    return 
        Provide.pure(opt()
        .or(arg())
        .and_(Parse.whitespace.or(Parsers.Eof()))
        .then(Option.pure)
        .one_many()
        .then(
          (arr) -> {
            __.log().debug(_ -> _.pure(arr));
            return arr.flat_map(
              opt -> opt.fold(
                x -> x,
                () -> [].imm()
              )
            );
          }
        ).apply(ipt));
  }
  public function opt():AbstractParser<String,Cluster<CliToken>>{
    return double_minus.and(word()).then(__.decouple((x,y) -> [Opt('$x$y')].imm())).or(
      minus.and(word()).then(
        __.decouple(
          (x:String,y:String) -> {
            final incase_assignment = y.split('=');
            final parts             = Chars.lift(incase_assignment[0]).iterator();
            final partsI            = Iter.make(parts).lfold(
              (next:Chars,memo:Array<String>) -> {
                return memo.snoc('$x$next');
              },
              []
            );
            if(Chars.lift(__.option(incase_assignment[1]).defv('')).is_defined()){
              //possible -xyz=2 becomes -x,-y,-z=2
              partsI[partsI.length-1] = '${partsI[partsI.length-1]}=${incase_assignment[1]}';
            } 
            return Cluster.lift(partsI.map(Opt));
          }
        )
    )).tagged('opt');
  }
  public function arg():AbstractParser<String,Cluster<CliToken>>{
    return word().then(x -> [Arg(x)]);
  }
}
