package stx.sys.cli;

using stx.Parse;

import stx.parse.parsers.StringParsers in SParse;
import stx.parse.Parser in Prs;
using stx.sys.cli.CliParser;

//local helpers//
function id(str:String){
  return __.parse().parsers().string().id(str);
}
/////////////////

/**
 * Parser designed to pull a cluster of `CliToken`s from a `String`
 */
class CliParser{
  static public function g<T,U>(p:Prs<String,U>):Prs<String,U>{
    return SParse.gap.many()._and(p);
  }
  static public inline function eof<I,O>():AbstractParser<String,O> return g(stx.parse.Parsers.Eof());

  static public var literal       = SParse.literal.tagged('literal');
  static public var symbol        = SParse.symbol.tagged('symbol');

  static public function word(){
    return literal.or(symbol);
  }

  static public function token() return g(SParse.primitive());
  static public var minus         = '-'.id();
  static public var double_minus  = '--'.id();

  public function new(){}

  public function parse(ipt:ParseInput<String>):Provide<ParseResult<String,Cluster<CliToken>>>{
    trace('parse');
    return 
        Provide.pure(
          (
            opt()
              .or(arg())
              .and_(SParse.whitespace.or(Parsers.Eof()))
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
              ).apply(ipt)
          )
        ).map(
            (x) -> {
              __.log().debug('$x');
              return x;
            }
        );
  }
  static public function opt():AbstractParser<String,Cluster<CliToken>>{
    return double_minus.and(word()).then(__.decouple((x,y) -> [Opt('$x$y')].imm())).or(
      minus.and(word()).then(
        __.decouple(
          (x:String,y:String) -> {
            final incase_assignment = y.split('=');
            final parts             = Chars.lift(incase_assignment[0]).toIter();
            final partsI            = parts.lfold(
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
  static public function arg():AbstractParser<String,Cluster<CliToken>>{
    return word().then(x -> [Arg(x)]);
  }
}
