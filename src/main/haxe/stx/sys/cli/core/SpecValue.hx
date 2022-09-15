package stx.sys.cli.core;

class SpecValue extends ParserCls<CliToken,SpecValue>{
  public function new(spec,args,opts,rest){
    super();
    this.spec = spec;
    this.args = args;
    this.opts = opts;
    this.rest = rest;
  }
  public final spec : Spec;
  public final args : Cluster<OptionValueApi>;
  public final opts : Cluster<OptionValueApi>;

  public final rest : Option<SpecValue>;

  public function copy(?spec,?args,?opts,?rest){
    return new SpecValue(
      __.option(spec).defv(this.spec),
      __.option(args).defv(this.args),
      __.option(opts).defv(this.opts),
      __.option(rest).defv(this.rest)
    );
  }
  public function with_rest(x){
    return copy(null,null,null,x);
  }
  public function with_arg(x){
    return copy(null,args.snoc(x));
  }
  public function with_opt(x){
    return copy(null,args.snoc(x));
  }
  public function get_section(name:String):Option<Spec>{
    return __.option(spec.rest[name]);
  }
  public function get_arg():Option<ArgumentSpec>{
    return this.spec.args.ldropn(this.args.length).search(x -> true);
  }
  public function is_args_full():Bool{
    return this.args.length >= this.spec.args.length;
  }
  public function get_opt(str:String):Option<OptionSpecApi>{
    return this.spec.opts.search(x -> x.matches(str));
  }
  public function get_opt_value(opt:OptionSpecApi):Option<OptionValueApi>{
    return this.opts.search(val -> val.type.name == opt.name);
  }
  public function is_opt_defined(opt:OptionSpecApi){
    return get_opt_value(opt).is_defined();
  }
  public function get_missing_options():Cluster<OptionSpecApi>{
    final leftover =  spec.opts.filter(
      (spec) -> {
        final is_remaining = opts.any(opt -> opt.type.name == spec.name);
        if(is_remaining){
          spec.required;
        }else{
          true;
        } 
      }
    );
    return leftover;
  }
  public function get_missing_arguments():Cluster<ArgumentSpec>{
    final leftover =  spec.args.filter(
      (spec) -> {
        final is_remaining = opts.any(opt -> opt.type.name == spec.name);
        if(is_remaining){
          spec.required;
        }else{
          true;
        } 
      }
    );
    return leftover;
  }
  public function defer(ipt:ParseInput<CliToken>,cont:Terminal<ParseResult<CliToken,SpecValue>,Noise>){
    return switch(ipt.head()){
      case Some(Arg(x)) : 
        get_section(x).fold(
          (ok) -> {
            final missing_options = get_missing_options();
            return missing_options.is_defined().if_else(
              () -> cont.receive(cont.value(ipt.no('$missing_options'))),
              () -> {
                final missing_arguments = get_missing_arguments();
                return missing_arguments.is_defined().if_else(
                  () -> cont.receive(cont.value(ipt.no('$missing_arguments'))),
                  () -> {
                    final sub_spec_value   = new SpecValue(ok,[],[],None);
                    final next_spec_parser = Parsers.Anon(sub_spec_value.defer,None);
                    return cont.receive(next_spec_parser.then(
                      (subspec) -> {
                        return this.with_rest(Some(subspec));
                      }
                    ).forward(ipt.tail()));
                  }
                );
              }
            );
          },
          () -> {
            return get_arg().fold(
              (y) -> {
                final with_arg = this.with_arg(y.with(x));
                return cont.receive(cont.value(ipt.ok(with_arg)));
              },
              () -> {
                return cont.receive(
                  cont.value(
                    is_args_full().if_else(
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
        switch(args.is_defined()){
          case true  : cont.receive(cont.value(ipt.no("no options should be defined after arguments")));
          case false : get_opt(string).fold(
            (opt:OptionSpecApi) -> {
              return switch(opt.kind){
                case PropertyKind(false) : get_opt_value(opt).fold(
                  ok -> cont.receive(cont.value(ipt.no('${opt.name} already defined'))),
                  () -> {
                    final opt_val = opt.with(None);
                    return opt_val.is_assignment().if_else(
                      () -> cont.receive(cont.value(ipt.tail().ok(this.with_opt(opt_val)))),
                      () -> (opt.kind == FlagKind).if_else(
                        () -> cont.receive(cont.value(ipt.tail().ok(this.with_opt(opt_val)))),
                        () -> switch(ipt.tail().head()){
                          case Some(Arg(x)) : 
                            cont.receive(cont.value(ipt.tail().tail().ok(
                              this.with_opt(opt.with(Some(x)))
                            )));
                          default     : cont.receive(cont.value(ipt.no('$opt requires value')));
                        }
                      )
                    );
                  }
                );
                case PropertyKind(true) : 
                  final opt_val = opt.with(None);
                  return opt_val.is_assignment().if_else(
                    () -> cont.receive(cont.value(ipt.tail().ok(this.with_opt(opt_val)))),
                    () -> (opt.kind == FlagKind).if_else(
                      () -> cont.receive(cont.value(ipt.tail().ok(this.with_opt(opt_val)))),
                      () -> switch(ipt.tail().head()){
                        case Some(Arg(x)) : cont.receive(cont.value(ipt.tail().tail().ok(
                          this.with_opt(opt.with(Some(x)))
                        )));
                        default     : cont.receive(cont.value(ipt.no('$opt requires value')));
                      }
                    )
                  );
                case ArgumentKind : cont.receive(cont.value(ipt.no('option defined as argument',true)));
                case FlagKind     :  
                  get_opt_value(opt).fold(
                    ok -> cont.receive(cont.value(ipt.no('${opt.name} already defined'))),
                    () -> {
                      final opt_val = opt.with(None);
                      return cont.receive(cont.value(ipt.tail().ok(this.with_opt(opt_val))));
                    }
                  );
              }
            },
            () -> cont.receive(cont.value(ipt.no('no option found'))) 
          );
        } 
      case None : cont.receive(cont.value(ipt.ok(this)));
    }
  }
}
