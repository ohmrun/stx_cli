package sys.stx.cli.test;

import sys.stx.cli.CliParser in P;

class CliTest extends TestCase{
  // final p = new sys.stx.cli.Parser();

  //public function test(){
  //   final a = "test --axs --bbg 'quoted' 'quoted spaced' 'quoted spaced \\' escaped '".reader();
  //   final v = p.parse(a);
  //   __.ctx(
  //     Nada,
  //     (a:ParseResult<String,Dynamic>) -> {
  //       trace(a.toUpshot());
  //     }
  //   ).load(v.toFletcher()).crunch();
  //}
  public function one_level_spec(){
    final d = Data;
    return Spec.__.Make(
      CliConfigCtr.unit(),
      'main','program',
      [d.flagI()],
      [d.arg_required()]
    );
  }
  public function test_one_level_spec(){
    final spec  = one_level_spec();
    final data  = [Arg('argval'),Opt('-f')].reader();
    final prog  = spec.reply();
    final res   = prog.apply(data);
    trace(res);
  }
  public function one_level_specI(){
    final d = Data;
    return Spec.__.Make(
      CliConfigCtr.unit(),
      "subprogram",
      "is sub program",  
      [d.flagII(),d.property()],
      [d.arg_required()]
    ); 
  }
  public function two_level_spec(){
    final d = Data;
    return Spec.__.Make(
      CliConfigCtr.unit(),
      'main','program',
      [d.flagI()],
      [d.arg_required()],
      [
        'subprogram' => one_level_specI()
      ]
    );
  }
  public function test_two_level_spec(){
    final spec  = two_level_spec(); 
    final data  = [Opt('-f'),Arg('argval'),Arg('subprogram'),Opt('-e'),Opt('--prop'),Arg('100'),Opt('--prop=2'),Arg("69")].reader();
    final prog  = spec.reply();
    final res   = prog.apply(data);
    trace(res);
  }
}