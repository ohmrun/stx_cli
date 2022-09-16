package stx.sys.cli.test;

class Data{
  static public function arg_required(){
    return Spec.__.Argument('arg0','tis an argument',true);
  }
  static public function arg_not_required(){
    return Spec.__.Argument('barg0','tis an argument',true);
  }
  static public function flagI(){
    return Spec.__.Flag('flag',"tis a flag");
  }
  static public function flagII(){
    return Spec.__.Flag('efflag',"tis a efflag");
  }
  static public function property(){
    return Spec.__.Property('prop','is prop',true,false);
  }
  static public function property_required(){
    return Spec.__.Property('prop','is Prop',false,true,'P');
  }
}