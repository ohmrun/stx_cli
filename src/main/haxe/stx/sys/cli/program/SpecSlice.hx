package stx.sys.cli.program;

class SpecSlice{
  public function new(config,name,doc,opts,args){
    this.config   = config;
    this.name     = name;
    this.doc      = doc;
    this.opts     = opts;
    this.args     = args;
  }
  public final config     : CliConfig;
  public final name       : String;
  public final doc        : String; 
  public final opts       : Cluster<OptionSpecApi>;
  public final args       : Cluster<ArgumentSpec>;
}
