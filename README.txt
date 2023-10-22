
static 메서드에는 static 변수만 사용가능하다.

자식 클래스에서 부모 클래스의 값을 참조하려면 public 이나 protected만 사용 가능하다.


부모 클래스는 
public virtual with sharing class Parent {

}

(추상)
public abstract with sharing class Parent {

}


자식이 override 하려면
public override Integer func(){

}
