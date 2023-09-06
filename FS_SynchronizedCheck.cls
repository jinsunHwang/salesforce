/**
 * Created by A81820 on 2023-08-31.
 */

public with sharing class FS_SynchronizedCheck {

    public static Boolean checkModify(String objName,String compareField,List<Map<String,Object>>records,String pageId,String pageValue) {
        Set<String> recordIds = new Set<String>();
        Map<String,String> pageFieldMap = new Map<String,String>();
        for(Map<String,Object> record : records) {
            String idStr = String.valueOf(record.get(pageId));
            String valueStr = String.valueOf(record.get(pageValue));
            recordIds.add(idStr);
            pageFieldMap.put(idStr,valueStr);
        }
        String strQuery ='SELECT Id, ' + compareField + ' FROM ' + objName + ' WHERE Id IN ( '+FS_ComUtils.joinedSetString(recordIds)+' ) ';
        System.debug('current strQuery ::' +strQuery);
        List<SObject> sObjs = Database.query(strQuery);
        Map<String,SObject> currentSObject = FS_ComUtils.getSObjKeyMap(sObjs,'Id','','');
        for(String recordId : recordIds) {
            String pageField = pageFieldMap.get(recordId) != null ? pageFieldMap.get(recordId) : 'null';
            String currentField = String.valueOf(currentSObject.get(recordId).get(compareField)) != null ? String.valueOf(currentSObject.get(recordId).get(compareField))  : 'null' ;
            if(!'null'.equals(pageField) &&!'null'.equals(currentField) && pageField != currentField) {
                return true;
            }
        }
        return false;
    }
}
