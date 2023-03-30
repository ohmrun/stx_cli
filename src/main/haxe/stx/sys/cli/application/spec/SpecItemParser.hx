package stx.sys.cli.application.spec;

class SpecItemParser extends ParserCls<CliToken,SpecValue>{
  public final delegate : SpecValue;

  public function new(delegate:SpecValue){
    super();
    this.delegate = delegate;
  }
  public function apply(ipt:ParseInput<CliToken>){
    __.log().trace('item ${this.delegate}');
    __.log().trace('${ipt.head()}');
    final is_greedy = !delegate.rest.is_defined() && delegate.spec.config.greedy;
    
    return switch(ipt.head()){
      case Val(Arg(x)) : 
        delegate.get_section(x).fold(
          (ok) -> {
            __.log().trace('delegate section: $ok');
            final missing_options = delegate.get_missing_options();
            return missing_options.is_defined().if_else(
              () -> ipt.no('missing options: $missing_options'),
              () -> {
                final missing_arguments = delegate.get_missing_arguments();
                return missing_arguments.is_defined().if_else(
                  () -> ipt.no('missing arguments: $missing_arguments'),
                  () -> {
                    __.log().trace('subsection');
                    final next_spec_parser = SpecParser.makeI(new SpecValue(ok,[],[],None)).asParser();
                    return next_spec_parser.then(
                      (subspec) -> {
                        return delegate.with_rest(Some(subspec));
                      }
                    ).apply(ipt.tail());
                  }
                );
              }
            );
          },
          () -> {
            __.log().trace('${delegate.args}');
            return delegate.get_arg().fold(
              (y) -> {
                final with_arg = delegate.with_arg(y.with(x));
                return ipt.tail().ok(with_arg);
              },
              () -> {
                return if(is_greedy){
                  final arg_spec = new ArgumentSpec(x,'automatically added',false);
                  final with_arg = delegate.with_arg(arg_spec.with(x));
                  ipt.tail().ok(with_arg);
                }else{
                  delegate.is_args_full().if_else(
                    () -> ipt.no('extra argument'),
                    () -> ipt.no('extra argument')
                  );
                }
              }
            );
          }
        );
      case Val(Opt(string)) : 
        switch(delegate.args.is_defined()){
          case true  : 
            __.log().trace('${delegate.args}');
            __.log().trace(string);
            ipt.no("no options should be defined after arguments");
          case false :
            __.log().trace(string);
            delegate.get_opt(string).fold(
              (opt:OptionSpecApi) -> {
                __.log().trace('${opt.kind}');
                return switch(opt.kind){
                  case PropertyKind(false) : delegate.get_opt_value(opt).fold(
                    ok -> ipt.no('${opt.name} already defined'),
                    () -> {  
                      final opt_val = opt.with(None);
                      return opt_val.is_assignment().if_else(
                        () -> ipt.tail().ok(delegate.with_opt(opt_val)),
                        () -> (opt.kind == FlagKind).if_else(
                          () -> ipt.tail().ok(delegate.with_opt(opt_val)),
                          () -> switch(ipt.tail().head()){
                            case Val(Arg(x)) : 
                              ipt.tail().tail().ok(
                                delegate.with_opt(opt.with(Some(x)))
                              );
                            default     : ipt.no('$opt requires value');
                          }
                        )
                      );
                    }
                  );
                  case PropertyKind(true) : 
                    final opt_val = opt.with(Some(string));
                    __.log().trace(opt_val.is_assignment());
                    return opt_val.is_assignment().if_else(
                      () -> ipt.tail().ok(delegate.with_opt(opt.with_assignment(string))),
                      () -> (opt.kind == FlagKind).if_else(
                        () -> ipt.tail().ok(delegate.with_opt(opt_val)),
                        () -> switch(ipt.tail().head()){
                          case Val(Arg(x)) : ipt.tail().tail().ok(
                            delegate.with_opt(opt.with(Some(x)))
                          );
                          default     : ipt.no('$opt requires value');
                        }
                      )
                    );
                  case ArgumentKind : ipt.no('option defined as argument',true);
                  case FlagKind     :  
                    delegate.get_opt_value(opt).fold(
                      ok -> ipt.no('${opt.name} already defined'),
                      () -> {
                        final opt_val = opt.with(None);
                        return ipt.tail().ok(delegate.with_opt(opt_val));
                      }
                    );
                }
              },
              () -> if(is_greedy){
                final opt_type = switch(ipt.tail().head()){
                  case Val(Arg(_)) : __.accept(PropertyKind(true));
                  case Val(Opt(_)) :
                    final opt      = new stx.sys.cli.application.spec.term.PropertyWildcard(string,'auto property',PropertyKind(true),false); 
                    final opt_val = opt.with(Some(string));
                    if(opt_val.is_assignment()){
                      __.accept(PropertyKind(true));
                    }else{
                      __.accept(FlagKind);
                    }
                  case End(e) :
                    switch(e.data){
                      case Some(EXTERNAL(stx.fail.ParseFailureCode.ParseFailureCodeSum.E_Parse_Eof)) : 
                        __.reject(f -> f.of(E_Cli_Parse(
                          ParseFailure.make(
                            @:privateAccess ipt.tail().content.index,
                            stx.fail.ParseFailureCode.ParseFailureCodeSum.E_Parse_Eof,
                            false
                          )
                        )));
                      case x : 
                        __.reject(f -> f.of(E_Cli('$x')));
                    }
                  case x : 
                    __.log().error('$x');
                    __.reject(f -> f.of(E_Cli('Incorrect value')));
                }
                switch(opt_type){
                  case Accept(PropertyKind(_)) : 
                    final opt      = new stx.sys.cli.application.spec.term.PropertyWildcard(string,'auto property',PropertyKind(true),false); 
                    final opt_val = opt.with(None);
                    opt_val.is_assignment().if_else(
                      () -> ipt.tail().ok(delegate.with_opt(opt_val)),
                      () ->  switch(ipt.tail().head()){
                        case Val(Arg(x)) : 
                          ipt.tail().tail().ok(
                            delegate.with_opt(opt.with(Some(x)))
                          );
                        default     : ipt.no('$opt requires value');
                      }
                    );
                  case Accept(FlagKind) : 
                    final opt      = new stx.sys.cli.application.spec.term.PropertyWildcard(string,'auto property',FlagKind,false); 
                    ipt.tail().ok(delegate.with_opt(opt.with(None)));
                  case Reject(e)        : 
                    switch(e.data){
                      case Some(EXTERNAL(E_Cli_Parse(eI))) : 
                        ParseResult.make(
                          ipt.tail(),
                          None,
                          Refuse.make(Some(EXTERNAL(eI)),None,e.pos)
                        );
                      default                   :
                        __.log().fatal(_ -> _.thunk(() -> '$e'));
                        ipt.no('weird condition error'); 
                    }
                  case x : 
                    __.log().fatal(_ -> _.thunk(() -> '$x'));
                    ipt.no('weird condition error');
                }
              }else{
                ipt.no('no option "$string" found');
              }
            );
        } 
      default : ipt.ok(delegate);
    }
  }
}