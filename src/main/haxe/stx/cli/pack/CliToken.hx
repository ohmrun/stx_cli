package stx.cli.pack;

enum CliToken{  
  Isolate(prim:Primitive);
  Special(name:String);
  Literal(lit:String);
  Accessor(lit:String);
  Suggest(name:String,double:Bool);
}