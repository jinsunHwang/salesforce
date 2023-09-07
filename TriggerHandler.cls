public virtual class TriggerHandler implements ITrigger {

    private static Map<String, LoopCount> loopCountMap;
    private static Set<String> bypassedHandlers;

    @TestVisible
    private TriggerContext context;

    @TestVisible
    private Boolean isTriggerExecuting;

    static {
        loopCountMap = new Map<String, LoopCount>();

        bypassedHandlers = new Set<String>();
    }

    public TriggerHandler() {
        this.setTriggerContext();
    }

    public void run() {
//        System.debug('TriggerHandler >> ' + bypassedHandlers);
//        System.debug('TriggerHandler >> ' + validateRun());
        if (!validateRun()) {
            return;
        }

        addToLoopCount();

        //Trigger Context에 따른 메서드 실행
        switch on this.context {
            when BEFORE_INSERT {
                this.beforeInsert();
            }
            when BEFORE_UPDATE {
                this.beforeUpdate();
            }
            when BEFORE_DELETE {
                this.beforeDelete();
            }
            when AFTER_INSERT {
                this.afterInsert();
            }
            when AFTER_UPDATE {
                this.afterUpdate();
            }
            when AFTER_DELETE {
                this.afterDelete();
            }
            when AFTER_UNDELETE {
                this.afterUndelete();
            }
        }
    }

    //최대 루프 수 설정
    public void setMaxLoopCount(Integer max) {
        String handlerName = getHandlerName();
        if (!TriggerHandler.loopCountMap.containsKey(handlerName)) {
            TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
        } else {
            TriggerHandler.loopCountMap.get(handlerName).setMax(max);
        }
    }

    public void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }

    public static void bypass(String handlerName) {
        TriggerHandler.bypassedHandlers.add(handlerName);
//        System.debug('TriggerHandler bypass >> ' + bypassedHandlers);
    }

    public static void clearBypass(String handlerName) {
        TriggerHandler.bypassedHandlers.remove(handlerName);
//        System.debug('TriggerHandler clearBypass >> ' + bypassedHandlers);
    }

    public static Boolean isBypassed(String handlerName) {
        return TriggerHandler.bypassedHandlers.contains(handlerName);
    }

    public static void clearAllBypasses() {
        TriggerHandler.bypassedHandlers.clear();
    }

    @TestVisible
    private void setTriggerContext() {
        this.setTriggerContext(null, false);
    }

    @TestVisible
    //Trigger Context, Test Mode 여부를 판별하여 TriggerExecuting 값 리턴
    private void setTriggerContext(String ctx, Boolean testMode) {
        if (!Trigger.isExecuting && !testMode) {
            this.isTriggerExecuting = false;
            return;
        } else {
            this.isTriggerExecuting = true;
        }

        //Context 값 세팅
        if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
                (ctx != null && ctx == 'before insert')) {
            this.context = TriggerContext.BEFORE_INSERT;
        } else if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
                (ctx != null && ctx == 'before update')) {
            this.context = TriggerContext.BEFORE_UPDATE;
        } else if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
                (ctx != null && ctx == 'before delete')) {
            this.context = TriggerContext.BEFORE_DELETE;
        } else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
                (ctx != null && ctx == 'after insert')) {
            this.context = TriggerContext.AFTER_INSERT;
        } else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
                (ctx != null && ctx == 'after update')) {
            this.context = TriggerContext.AFTER_UPDATE;
        } else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
                (ctx != null && ctx == 'after delete')) {
            this.context = TriggerContext.AFTER_DELETE;
        } else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
                (ctx != null && ctx == 'after undelete')) {
            this.context = TriggerContext.AFTER_UNDELETE;
        }
    }

    @TestVisible
    //루프 수 증가 및 예외 처리
    private void addToLoopCount() {
        String handlerName = getHandlerName();
        if (TriggerHandler.loopCountMap.containsKey(handlerName)) {
            Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName).increment();
            if (exceeded) {
                Integer max = TriggerHandler.loopCountMap.get(handlerName).max;
                throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
            }
        }
    }

    @TestVisible
    //Trigger 실행 여부 확인
    private Boolean validateRun() {
        if (!this.isTriggerExecuting || this.context == null) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }
        return !TriggerHandler.bypassedHandlers.contains(getHandlerName());
    }

    @TestVisible
    private String getHandlerName() {
        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }

    public static void runTriggerByCustomMeta(Object objTrigger) {
        SObjectType sObjectType = (Trigger.new != null ? Trigger.new : Trigger.old).getSObjectType();
        String targetName = String.valueOf(objTrigger).substring(0,String.valueOf(objTrigger).indexOf(':'));

//        System.debug('Trigger SObject API Name : ' + sObjectType);
//        System.debug('Trigger Name : ' + targetName);

        //Trigger Handler Setting Custom Metadata 호출
        List<TriggerHandlerSetting__mdt> listTriggerSettingMdt = [
                SELECT  HandlerClassName__c, MigHandlerClassName__c, IsActive__c, IsMigration__c
                FROM    TriggerHandlerSetting__mdt
                WHERE   SobjectApiName__c = :String.valueOf(sObjectType)
                AND     TriggerName__c = :targetName
        ];

        for(TriggerHandlerSetting__mdt handler : listTriggerSettingMdt) {
            if(handler.IsActive__c){
                Type t = null;
                if(handler.IsMigration__c && String.isNotBlank(handler.MigHandlerClassName__c) && !TriggerHandler.bypassedHandlers.contains(handler.MigHandlerClassName__c)){
                    t = Type.forName(handler.MigHandlerClassName__c);
                }
                else if(!TriggerHandler.bypassedHandlers.contains(handler.HandlerClassName__c)) {
                    t = Type.forName(handler.HandlerClassName__c);
                }

                if(t != null){
                    ITrigger instance = (ITrigger) t.newInstance();
                    instance.run();
                }
            }
        }
    }

    @TestVisible
    protected virtual void beforeInsert() {
    }
    @TestVisible
    protected virtual void beforeUpdate() {
    }
    @TestVisible
    protected virtual void beforeDelete() {
    }
    @TestVisible
    protected virtual void afterInsert() {
    }
    @TestVisible
    protected virtual void afterUpdate() {
    }
    @TestVisible
    protected virtual void afterDelete() {
    }
    @TestVisible
    protected virtual void afterUndelete() {
    }

    @TestVisible
            //루프 수 관리
    private class LoopCount {
        private Integer max;
        private Integer count;

        public LoopCount() {
            this.max = 5;
            this.count = 0;
        }

        public LoopCount(Integer max) {
            this.max = max;
            this.count = 0;
        }

        public Boolean increment() {
            this.count++;
            return this.exceeded();
        }

        public Boolean exceeded() {
            return this.max >= 0 && this.count > this.max;
        }

        public Integer getMax() {
            return this.max;
        }

        public Integer getCount() {
            return this.count;
        }

        public void setMax(Integer max) {
            this.max = max;
        }
    }

    @TestVisible
            //사용 가능한 Trigger Context
    private enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
        AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
        AFTER_UNDELETE
    }

    public class TriggerHandlerException extends Exception {
    }

}
