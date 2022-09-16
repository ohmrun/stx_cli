package stx.sys.cli.test;

import stx.sys.cli.CliParser in P;

class CliTest extends TestCase{
  // final p = new stx.sys.cli.Parser();

  //public function test(){
  //   final a = "test --axs --bbg 'quoted' 'quoted spaced' 'quoted spaced \\' escaped '".reader();
  //   final v = p.parse(a);
  //   __.ctx(
  //     Noise,
  //     (a:ParseResult<String,Dynamic>) -> {
  //       trace(a.toRes());
  //     }
  //   ).load(v.toFletcher()).crunch();
  //}
  public function one_level_spec(){
    final d = Data;
    return Spec.__.Make(
      'main','program',
      [d.flagI()],
      [d.arg_required()],
      None
    );
  }
  public function test_one_level_spec(){
    final spec  = one_level_spec();
    final data  = [Arg('argval'),Opt('-f')].reader();
    final prog  = spec.reply();
    __.ctx(
      data,
      (ok:ParseResult<CliToken,SpecValue>) -> {
        trace(ok.error);
        for(v in ok){
          for(o in v){
            trace(o.args);
            trace(o.opts);
          }
        }
      }
    ).load(prog.toFletcher())
     .crunch();
  }
  public function one_level_specI(){
    final d = Data;
    return Spec.__.Make(
      "subprogram",
      "is sub program",  
      [d.flagII(),d.property()],
      [d.arg_required()], 
      None
    ); 
  }
  public function two_level_spec(){
    final d = Data;
    return Spec.__.Make(
      'main','program',
      [d.flagI()],
      [d.arg_required()],
      Some([
        'subprogram' => one_level_specI()
      ])
    );
  }
  public function test_two_level_spec(){
    final spec  = two_level_spec(); 
    final data  = [Opt('-f'),Arg('argval'),Arg('subprogram'),Opt('-e'),Opt('--prop'),Arg('100'),Opt('--prop=2'),Arg("69")].reader();
    final prog  = spec.reply();
    __.ctx(
      data,
      (ok:ParseResult<CliToken,SpecValue>) -> {
        trace(ok.error);
        for(v in ok){
          for(o in v){
            trace(o.args);
            trace(o.opts);
            for(x in o.rest){
              trace(x.args);
              trace(x.opts);
              trace(x.spec.doc);
            }
          }
        }
      }
    ).load(prog.toFletcher())
     .crunch();
  }
}