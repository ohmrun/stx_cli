package stx.sys.cli;

enum CliToken{  
  Isolate(prim:Primitive);
  Special(name:String);
  Literal(lit:String);
  Accessor(lit:String);
  Suggest(name:String,double:Bool);
}