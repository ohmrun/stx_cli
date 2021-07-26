import stx.cli.Package;

import cmd.store.Package;
import cmd.test.Package;

class Run{
  static function main(){
    var build = new Alias('build',new cmd.haxelib.Package.SpecificHaxelib('stx_build'));

    
    stx.Cli.handlers.whenever(new stx.cli.pack.handler.CommandInstantiator());
    stx.Cli.handlers.whenever(new stx.cli.pack.handler.ImplementationInstantiator());
    stx.Cli.handlers.whenever(new stx.cli.pack.handler.AliasInstantiator([build]));
    stx.Cli.main();
  }
}