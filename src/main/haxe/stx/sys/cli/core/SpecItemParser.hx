package stx.sys.cli.core;

class SpecItemParser extends ParserCls<CliToken,SpecValue>{
  public final delegate : SpecValue;

  public function new(delegate:SpecValue){
    super();
    this.delegate = delegate;
  }
  public function defer(ipt:ParseInput<CliToken>,cont:Terminal<ParseResult<CliToken,SpecValue>,Noise>){
    __.log().trace('item ${this.delegate}');
    __.log().trace('${ipt.head()}');
    return switch(ipt.head()){
      case Some(Arg(x)) : 
        delegate.get_section(x).fold(
          (ok) -> {
            __.log().trace('$ok');
            final missing_options = delegate.get_missing_options();
            return missing_options.is_defined().if_else(
              () -> cont.receive(cont.value(ipt.no('missing options: $missing_options'))),
              () -> {
                final missing_arguments = delegate.get_missing_arguments();
                return missing_arguments.is_defined().if_else(
                  () -> cont.receive(cont.value(ipt.no('missing arguments: $missing_arguments'))),
                  () -> {
                    trace('subsection');
                    final next_spec_parser = SpecParser.makeI(new SpecValue(ok,[],[],None)).asParser();
                    return cont.receive(next_spec_parser.then(
                      (subspec) -> {
                        return delegate.with_rest(Some(subspec));
                      }
                    ).forward(ipt.tail()));
                  }
                );
              }
            );
          },
          () -> {
            trace(delegate.args);
            return delegate.get_arg().fold(
              (y) -> {
                final with_arg = delegate.with_arg(y.with(x));
                return cont.receive(cont.value(ipt.tail().ok(with_arg)));
              },
              () -> {
                return cont.receive(
                  cont.value(
                    delegate.is_args_full().if_else(
                      () -> ipt.no('extra argument'),
                      () -> ipt.no('extra argument')
                    ) 
                  )
                );
              }
            );
          }
        );
      case Some(Opt(string)) : 
        switch(delegate.args.is_defined()){
          case true  : 
            trace(delegate.args);
            trace(string);
            cont.receive(cont.value(ipt.no("no options should be defined after arguments")));
          case false :
            trace(string);
            delegate.get_opt(string).fold(
              (opt:OptionSpecApi) -> {
                trace(opt.kind);
                return switch(opt.kind){
                  case PropertyKind(false) : delegate.get_opt_value(opt).fold(
                    ok -> cont.receive(cont.value(ipt.no('${opt.name} already defined'))),
                    () -> {  
                      final opt_val = opt.with(None);
                      return opt_val.is_assignment().if_else(
                        () -> cont.receive(cont.value(ipt.tail().ok(delegate.with_opt(opt_val)))),
                        () -> (opt.kind == FlagKind).if_else(
                          () -> cont.receive(cont.value(ipt.tail().ok(delegate.with_opt(opt_val)))),
                          () -> switch(ipt.tail().head()){
                            case Some(Arg(x)) : 
                              cont.receive(cont.value(ipt.tail().tail().ok(
                                delegate.with_opt(opt.with(Some(x)))
                              )));
                            default     : cont.receive(cont.value(ipt.no('$opt requires value')));
                          }
                        )
                      );
                    }
                  );
                  case PropertyKind(true) : 
                    final opt_val = opt.with(Some(string));
                    trace(opt_val.is_assignment());
                    return opt_val.is_assignment().if_else(
                      () -> cont.receive(cont.value(ipt.tail().ok(delegate.with_opt(opt.with_assignment(string))))),
                      () -> (opt.kind == FlagKind).if_else(
                        () -> cont.receive(cont.value(ipt.tail().ok(delegate.with_opt(opt_val)))),
                        () -> switch(ipt.tail().head()){
                          case Some(Arg(x)) : cont.receive(cont.value(ipt.tail().tail().ok(
                            delegate.with_opt(opt.with(Some(x)))
                          )));
                          default     : cont.receive(cont.value(ipt.no('$opt requires value')));
                        }
                      )
                    );
                  case ArgumentKind : cont.receive(cont.value(ipt.no('option defined as argument',true)));
                  case FlagKind     :  
                    delegate.get_opt_value(opt).fold(
                      ok -> cont.receive(cont.value(ipt.no('${opt.name} already defined'))),
                      () -> {
                        final opt_val = opt.with(None);
                        return cont.receive(cont.value(ipt.tail().ok(delegate.with_opt(opt_val))));
                      }
                    );
                }
              },
              () -> cont.receive(cont.value(ipt.no('no option "$string" found'))) 
            );
        } 
      case None : cont.receive(cont.value(ipt.ok(delegate)));
    }
  }
}