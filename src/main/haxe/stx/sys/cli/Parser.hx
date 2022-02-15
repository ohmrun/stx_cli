package stx.sys.cli;

import stx.parse.Parser in Prs;
using stx.sys.cli.Parser;

function id(str){
  return __.parse().id(str);
}
class Parser{
  static public function g<T,U>(p:Prs<String,U>):Prs<String,U>{
    return Parse.gap.many()._and(p);
  }
  static public inline function eof<I,O>():AbstractParser<String,O> return g(stx.parse.Parsers.Eof());

  static public var dot           = ".".id();
  static public var underscore    = "_".id();  
  static public var cutlery       = __.parse().reg('[/\\-_.]');

  static public var alpha         = Parse.alpha;
  static public var head          = Parse.alpha.or(underscore).tagged('head');
  static public var tail          = alpha.or(dot).or(underscore).tagged('tail');
  static public var argument      = Parse.literal.or(Parse.symbol).tagged('literal').then(Literal);

  static public function word(){
    return g(head.and(tail.many()).then(
      (tp) -> [tp.fst()].imm().concat(tp.snd())
    ).tokenize());
  }

  static public function token() return g(Parse.primitive());
  static public var minus         = '-'.id();
  static public var double_minus  = '--'.id();
  static public var triple_minus  = '---'.id();

  public function new(){}

  public function parse(ipt:ParseInput<String>):Provide<ParseResult<String,Cluster<CliToken>>>{
    return special()
        .or(suggest())
        .or(isolate())
        .or(accessor())
        .or(argument)
        .then(Option.pure)
        .many()
        .then(
          (arr) -> {
            //__.log().debug(_ -> _.pure(arr));
            return arr.flat_map(
              opt -> opt.toArray().imm()
            );
          }
        ).provide(ipt);
  }
  public function suggest():AbstractParser<String,CliToken>{
    return double_minus._and(word()).then(Suggest.bind(_,true)).or(
      minus._and(word()).then(Suggest.bind(_,false))
    ).tagged('suggest');
  }
  public function special():AbstractParser<String,CliToken>{
    return triple_minus._and(word()).then(Special).tagged('special');
  }
  public function isolate():AbstractParser<String,CliToken>{
    return token().then(Isolate).tagged('isolate');
  }
  public function accessor(){
    return word().then(Accessor).tagged('accessor');
  }
}