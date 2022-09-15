package stx.sys.cli.core;

import stx.sys.cli.core.spec.term.PropertyDefaultSpec;
import stx.sys.cli.core.spec.term.FlagDefaultSpec;

class Spec extends SpecSlice{
  static public var __(default,never) = new SpecCtr();
  public function new(name,doc,opts,args,rest){
    super(name,doc,opts,args);
    this.rest = rest;
  }
  public final rest      : Map<String,Spec>;
}
class SpecCtr extends Clazz{
  public function Make(name,doc,opts,args,rest:CTR<SpecCtr,Map<String,Spec>>){
    return new Spec(name,doc,opts,args,rest.apply(this));
  }
  public function Property(name,doc,repeatable,required,?short){
    return new PropertyDefaultSpec(name,doc,repeatable,required);
  }
  public function Flag(name,doc,?short){
    return new FlagDefaultSpec(name,doc);
  }
  public function Argument(name:String,doc:String,required:Bool){
    return new ArgumentSpec(name,doc,required);
  }
}