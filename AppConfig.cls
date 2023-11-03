/**
 * Created by user on 2023-11-02.
 */

public with sharing class AppConfig {

    private static AppConfig instance;
    private AppConfig(){}

    public static AppConfig getInstance() {
        if(instance == null){
            instance = new AppConfig();
        }
        return instance;
    }

    public MemberRepository memberRepository(){
        return new MemoryMemberRepository();
    }

    public DiscountPolicy discountPolicy() {
        return new RateDiscountPolicy();
    }

    public MemberService memberService(){
        return new MemberServiceImpl(memberRepository());
    }

    public OrderService orderService(){
        return new OrderServiceImpl(memberRepository(),discountPolicy());
    }
}
