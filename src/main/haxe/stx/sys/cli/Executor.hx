package stx.sys.cli;

class Executor{
  public var context(default,null) : Context;

  public function new(?context){
    this.context = context == null ? Context.unit() : context;
  }
  public function execute(){
    return @:privateAccess stx.sys.Cli.handlers.toArray().lfold(
      (next:Program,memo:Produce<stx.io.Process,CliFailure>) -> memo.fold_flat_map(
        (res:Res<Process,CliFailure>) -> res.fold(
          ok -> Produce.pure(ok),
          no -> switch(no.val){
          case Some(EXCEPT(E_NoImplementation))   : (Cascade.fromApi(next).provide(context));
            default                               : (Produce.reject(no));
          }
        )
      ),
      Produce.reject(__.fault().of(E_NoImplementation))
    ).point(
      (o:Process) -> Execute.lift(
        Action.lift(
          Server._.next(
            Proxy._.errate(o.prj(),E_Cli_Io),
            function rec(y:ProcessResponse) : Proxy<ProcessRequest,ProcessResponse,Noise,Closed,Noise,CliFailure>{
              return switch(y){
                case PResState({ exit_code : Some(0) }) : 
                  __.ended(Tap);
                case PResState({ exit_code : Some(i) }) : 
                  __.ended(End(__.fault().of(E_ErrorCode(i))));
                case PResState({ exit_code : None }) :
                  __.await(PReqIdle,rec);
                case PResValue(res)   : 
                  function pull(output:Output,val:InputResponse){
                    return Belay.lift(
                      Effect.lift(
                        //put output pipe(O) to result(R)
                        Output._.relate(
                          val.toOutputRequest().fold(
                            v   -> output.provide(v),
                            ()  -> output
                          ))
                          //close the input pipe( I = OutputRequest )
                          .derive()
                          .errate(E_Cli_Io)
                      ).toExecute()
                       .errate(E_Cli_Coroutine)
                       .then(
                        Fletcher.Sync(
                          (report:Report<CliFailure>) -> report.fold(
                            err  -> __.ended(End(err)),
                            ()   -> __.await(PReqIdle,rec)
                          )
                        )
                      )
                    );
                  }
                  //$type(pull);
                  switch(res){
                    case Failure(er) : pull(__.asys().stderr(),er);
                    case Success(ok) : pull(__.asys().stdout(),ok);
                  }
                  //:Outcome<InputResponse,InputResponse>
                case PResError(raw) :
                  //:Rejection<ProcessFailure>
                  __.ended(End(raw.errate(E_Cli_ProcessFailure)));
                case PResReady : 
                  __.await(PReqIdle,rec);
              }
            }
          )
        ).toExecute()
         .errate(E_Cli_Coroutine)
      ) 
    );
  }
}