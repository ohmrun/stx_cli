import stx.sys.cliage;

import cmd.store.Package;
import cmd.test.Package;

class Run{
  static function main(){
    var build = new Alias('build',new cmd.haxelib.Package.SpecificHaxelib('stx_build'));

    
    stx.sys.cli.handlers.whenever(new stx.sys.cli.handler.CommandInstantiator());
    stx.sys.cli.handlers.whenever(new stx.sys.cli.handler.ImplementationInstantiator());
    stx.sys.cli.handlers.whenever(new stx.sys.cli.handler.AliasInstantiator([build]));
    stx.sys.cli.main();
  }
}