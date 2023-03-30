package stx.sys.cli.application.spec;

class SpecParser extends stx.parse.parser.term.FlatMap<CliToken,SpecValue,SpecValue>{
  static public function makeI(spec_value){
    return new SpecParser(new SpecItemParser(spec_value).asParser());
  } 
  public function flat_map(r:SpecValue):Parser<CliToken,SpecValue>{
    return new SpecParser(new SpecItemParser(r).asParser()).asParser();
  }
  override public function through_bind(input:ParseInput<CliToken>,result:ParseResult<CliToken,SpecValue>){

    for (v in result.value){
      __.log().trace('${v.args}');
      __.log().trace('${v.opts}');
    }

    return switch(input.is_end() || result.has_error() ){
      case true  : Parsers.Stamp(result);
      case false : makeI(result.value.defv(null)).asParser();
    }
  }
} 