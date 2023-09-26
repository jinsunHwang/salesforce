let slOrderProgressArray = records.slOrderProgress;
                let slOrderProgress = [{
                    orderNumber : record.orderNumber
                    ,orderSeq : record.orderSeq
                    ,SupplySchDate : ''
                    ,remark : ''
                    ,slCreator : ''
                    ,slCreateDate : ''
                    ,supplyManager : ''
                }];
                if(!slOrderProgressArray.length) {
                    slOrderProgress =slOrderProgressArray.map(item=>{
                        return {
                            orderNumber : record.orderNumber
                            ,orderSeq : record.orderSeq
                            ,SupplySchDate : item.SUPPLY_Scheduling_Date__c
                            ,remark : item.REMARK__c
                            ,slCreator : item.CreatedBy.Name
                            ,slCreateDate : item.CreatedDate
                            ,supplyManager : ''
                        }
                    });
                } 
this.data2= [...slOrderProgress]
이코드가 더 좋니?
let slOrderProgressArray = records.slOrderProgress;
                let slOrderProgress =[];
                if(slOrderProgressArray.length) {
                    slOrderProgress =slOrderProgressArray.map(item=>{
                        return {
                            orderNumber : record.orderNumber
                            ,orderSeq : record.orderSeq
                            ,SupplySchDate : item.SUPPLY_Scheduling_Date__c
                            ,remark : item.REMARK__c
                            ,slCreator : item.CreatedBy.Name
                            ,slCreateDate : item.CreatedDate
                            ,supplyManager : ''
                        }
                    });
                } else {
                    slOrderProgress = [{
                        orderNumber : record.orderNumber
                        ,orderSeq : record.orderSeq
                        ,SupplySchDate : ''
                        ,remark : ''
                        ,slCreator : ''
                        ,slCreateDate : ''
                        ,supplyManager : ''
                    }];
                }
                this.data2= [...slOrderProgress]
아니면 이코드가 좋니?
