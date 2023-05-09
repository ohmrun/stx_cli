package sys.stx.cli.test;

class ReadmeTest extends TestCase{
  public function test(){
    final ctr = __.cli().spec();//Wildcard Static Extension
    final spec = ctr.Make(
      ctr.Config().unit(),
        'any name you like',
        'doc stating purpose',
        [
          ctr.Property('prop0','repeatable property',true,false,'p'),
          ctr.Property('prop1','required property',false,true,'q'),
          ctr.Flag('flagged','flag')
        ],
        [
          ctr.Argument('info','what, pray tell me?',false)
        ],
        [
          "section" => ctr.Make(
            ctr.Config().unit(),
            "another name",
            "doesn't have to share name, parser matches on `section`",
            [
              ctr.Property('prop1','property of this section',false,false,'r')
            ],
            []
          ) 
        ]
    );
    final val : Upshot<Option<sys.stx.cli.application.spec.SpecValue>,CliFailure> = __.cli().apply(spec);//uses Sys.args() as input
    trace(val);
  }
}