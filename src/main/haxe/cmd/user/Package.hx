package cmd.user;

class Create extends Command{
  public var user(get,null):String;
  function get_user(){
    return this.arguments.args_without_specials()[0];
  }
  public function new(user:String){
    super('adduser',[Literal(user)]);
  }
}
class Delete extends Command{
  public var user(get,null):String;
  function get_user(){
    return this.arguments.args_without_specials()[0];
  }
  public function new(user:String){
    super('userdel',[Literal(user)]);
  }
}
class GrantSudo extends Command{
  public function new(user:String){
    super('usermod',["-aG","sudo",user].map(Literal));
  }
} 