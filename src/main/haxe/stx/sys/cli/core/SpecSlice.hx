package stx.sys.cli.core;

class SpecSlice{
  public function new(name,doc,opts,args){
    this.name = name;
    this.doc  = doc;
    this.opts = opts;
    this.args = args;
  }
  public final name       : String;
  public final doc        : String; 
  public final opts       : Cluster<OptionSpecApi>;
  public final args       : Cluster<ArgumentSpec>;
}
