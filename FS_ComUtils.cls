/****************************************************************************************
 * File Name    : FS_ComUtils.cls
 * Author       : jinsun.hwang
 * Date         : 2023-05-24
 * Description  :
 * Modification Log
 * ===============================================================
 * Ver      Date 		Author    			Modification
 * ===============================================================
   1.1		2023-05-24 	jinsun.hwang
****************************************************************************************/
public with sharing class FS_ComUtils {

    public static String getSObjStr(SObject sObj,String key) {
        String result='';
        if (key.contains('.')) {
            String[] keys = key.split('\\.');
            SObject parentObj = sObj;
            for (Integer i= 0 ; i < keys.size()-1; i++ ) {
                parentObj = parentObj.getSObject(keys[i]);
            }
            if (parentObj != null) {
                result =String.valueOf(parentObj.get(keys[keys.size()-1]));
            }
        } else {
            result =String.valueOf(sObj.get(key));
        }
        return result;
    }
    public static Set<String> setToKeysObject (List<Object> objs) {
        Set<String> setKeys = new Set<String>();
        for(Object obj : objs) {
            setKeys.add(String.valueOf(obj));
        }
        return setKeys;
    }

    public static Set<String> setToKeysObject (List<Object> objs,String key) {
        Set<String> setKeys = new Set<String>();
        for(Object obj : objs) {
            if (obj instanceof Map<String,Object>) {
                Map<String,Object> objectMap = (Map<String,Object>) obj;
                setKeys.add(String.valueOf(objectMap.get(key)));
            }
        }
        return setKeys;
    }


    public static Set<String> setToKeys (List<SObject> sObjs,String key) {
        Set<String> setKeys = new Set<String>();
        for(SObject sObj : sObjs) {
            setKeys.add(getSObjStr(sObj,key));
        }
        return setKeys;
    }

    public static Set<String> setToKeys (List<SObject> sObjs,String key,String joinKey,String key2 ) {
        Set<String> setKeys = new Set<String>();
        String joinStr = '';
        for(SObject sObj : sObjs) {
            if (!''.equals(key2)) {
                joinStr = getSObjStr(sObj,key2);
            }
            setKeys.add(getSObjStr(sObj,key)+joinKey+joinStr);
        }
        return setKeys;
    }

    public static SObject getSObjQuery(String strQuery) {
        List<SObject> sObj = Database.query(strQuery);
        return sObj.isEmpty() ? null : (SObject) sObj[0];
    }

    public static SObject getSObjQuery(String fieldStr, String sObjStr, String whereStr) {
        String query = 'SELECT ' + fieldStr + ' FROM ' + sObjStr + ' ' + whereStr;
        List<SObject> sObj = Database.query(query);
        return sObj.isEmpty() ? null : (SObject) sObj[0];
    }

    public static SObject getSObjQuery(String fieldStr, String sObjStr, String whereStr, Set<String> Ids) {
        String query = 'SELECT ' + fieldStr + ' FROM ' + sObjStr + ' ' + whereStr;
        List<SObject> sObj = Database.query(query);
        return sObj.isEmpty() ? null : (SObject) sObj[0];
    }

    public static List<SObject> getSObjQuerys(String strQuery) {
        List<SObject> sObj = Database.query(strQuery);
        return sObj.isEmpty() ? null : sObj;
    }

    public static List<SObject> getSObjQuerys(String fieldStr, String sObjStr, String whereStr) {
        String query = 'SELECT ' + fieldStr + ' FROM ' + sObjStr + ' ' + whereStr;
        List<SObject> sObj = Database.query(query);
        return sObj.isEmpty() ? null : sObj;
    }

    public static List<SObject> getSObjQuerys(String fieldStr, String sObjStr, String whereStr, Set<String> Ids) {
        String query = 'SELECT ' + fieldStr + ' FROM ' + sObjStr + ' ' + whereStr;
        List<SObject> sObj = Database.query(query);
        return sObj.isEmpty() ? null : sObj;
    }

    public static Map<String,SObject> getSObjQueryMap(String strQuery,String keyStr) {
        List<SObject> sObjs = Database.query(strQuery);
        Map<String,SObject> sObjMap = new Map<String,SObject>();
        for(SObject sObj : sObjs) {
            sObjMap.put(getSObjStr(sObj,keyStr),sObj);
        }
        return sObjMap.isEmpty() ? null :sObjMap;
    }
    public static Map<String,SObject> getSObjQueryMapJoin(String strQuery,String keyStr,String joinKey,String keyStr2) {
        List<SObject> sObjs = Database.query(strQuery);
        Map<String,SObject> sObjMap = new Map<String,SObject>();
        String joinStr = '';
        for(SObject sObj : sObjs) {
            if (!''.equals(keyStr2)) {
                joinStr = getSObjStr(sObj,keyStr2) ;
            }
            sObjMap.put(getSObjStr(sObj,keyStr) + joinKey + joinStr, sObj);
        }
        return sObjMap.isEmpty() ? null :sObjMap;
    }

    public static Map<String,SObject> getSObjQueryMap(String fieldStr, String sObjStr, String whereStr, String keyStr) {
        String query = 'SELECT ' + fieldStr + ' FROM ' + sObjStr + ' WHERE ' + whereStr ;
        List<SObject> sObjs = Database.query(query);
        Map<String,SObject> sObjMap = new Map<String,SObject>();
        for(SObject sObj : sObjs) {
            sObjMap.put(getSObjStr(sObj,keyStr),sObj);
        }
        return sObjMap.isEmpty() ? null :sObjMap;
    }

    public static Map<String,SObject> getSObjQueryMap(String fieldStr, String sObjStr, String whereStr, String keyStr, Set<String> Ids) {
        String query = 'SELECT ' + fieldStr + ' FROM ' + sObjStr + ' WHERE ' + whereStr ;
        List<SObject> sObjs = Database.query(query);
        Map<String,SObject> sObjMap = new Map<String,SObject>();
        for(SObject sObj : sObjs) {
            sObjMap.put(getSObjStr(sObj,keyStr),sObj);
        }
        return sObjMap.isEmpty() ? null :sObjMap;
    }

    public static SObject getSObj(List<SObject> sObjs,String getStr,String compare) {
        List<SObject> result = new List<SObject>();
        for(SObject sObj : sObjs) {
            if((String)sObj.get(getStr) == compare){
                result.add(sObj);
            }
        }
        return result[0];
    }

    public static Map<String, SObject> getSObjKeyMap(List<SObject>sObjs, String keyStr, String joinKey, String keyStr2) {
        Map<String, SObject> sObjMap = new Map<String, SObject>();
        String joinStr = '';
        for (SObject sObj : sObjs) {
            if (!''.equals(keyStr2)) {
                joinStr = getSObjStr(sObj,keyStr2) ;
            }
            sObjMap.put(getSObjStr(sObj,keyStr) + joinKey + joinStr, sObj);
        }
        return sObjMap.isEmpty() ? null : sObjMap;
    }

    public static Map<String,List<SObject>> getStringListSObject(List<SObject> sObjs,String key) {
        Map<String, List<SObject>> mapLists = new Map<String, List<SObject>>();
        for (SObject sObj : sObjs) {
            String keyValue =  getSObjStr(sObj,key) ;
            if (!mapLists.containsKey(keyValue)) {
                mapLists.put(keyValue, new List<SObject>());
            }
            mapLists.get(keyValue).add(sObj);
        }
        return mapLists;
    }

    public static Map<String,List<SObject>> getStringListSObject(List<SObject> sObjs,String key,String joinKey,String key2) {
        Map<String, List<SObject>> mapLists = new Map<String, List<SObject>>();
        for (SObject sObj : sObjs) {
            String keyValue =  getSObjStr(sObj,key) +joinKey;
            if(!''.equals(key2)){
                keyValue+=getSObjStr(sObj,key2);
            }
            if (!mapLists.containsKey(keyValue)) {
                mapLists.put(keyValue, new List<SObject>());
            }
            mapLists.get(keyValue).add(sObj);
        }
        return mapLists;
    }

    public static Map<String,List<SObject>> getStringListSObjectQuery(String strQuery,String key) {
        Map<String, List<SObject>> mapLists = new Map<String, List<SObject>>();
        List<SObject> sObjs = Database.query(strQuery);
        for (SObject sObj : sObjs) {
            String keyValue =  getSObjStr(sObj,key) ;
            if (!mapLists.containsKey(keyValue)) {
                mapLists.put(keyValue, new List<SObject>());
            }
            mapLists.get(keyValue).add(sObj);
        }
        return mapLists;
    }

    public static Map<String,List<SObject>> getStringListSObjectQuery(String strQuery,String key,String joinKey,String key2) {
        Map<String, List<SObject>> mapLists = new Map<String, List<SObject>>();
        List<SObject> sObjs = Database.query(strQuery);
        for (SObject sObj : sObjs) {
            String keyValue =  getSObjStr(sObj,key) +joinKey;
            if(!''.equals(key2)){
                keyValue+=getSObjStr(sObj,key2);
            }
            if (!mapLists.containsKey(keyValue)) {
                mapLists.put(keyValue, new List<SObject>());
            }
            mapLists.get(keyValue).add(sObj);
        }
        return mapLists;
    }

    public static Object caseWhenThen(List<Object> params) {
        if (params == null || params.size() < 3 || Math.mod(params.size(), 2) == 0) {
            return null;
        }
        Object result = params[params.size() - 1];
        for (Integer i = 0; i < params.size() - 1; i += 2) {
            Boolean condition = (Boolean) params[i];
            Object value = params[i + 1];
            if (condition) {
                result = value; break;
            }
        }
        return result;
    }

    public static String maskingStr(String inputString) {
        String resultString='';
        if(inputString.length() > 2) {
            Integer stringLength = inputString.length();
            resultString = inputString.substring(0,1);
            for(Integer j = 0; j < stringLength - 2; j++) {
                resultString += '*';
            }
            resultString += inputString.substring(stringLength - 1,stringLength);
        } else {
            resultString = inputString;
        }
        return resultString;
    }
    public static List<AggregateResult> aggregateSObject(Set<String> ids,String idField,String sObjName,String fieldName,String groupBy) {
        if (ids == null || ids.isEmpty()) {
            return null;
        }
        if (String.isBlank(sObjName)) {
            return null;
        }
        if (String.isBlank(fieldName)) {
            return null;
        }
        String query = 'SELECT ' + groupBy +' , ' + fieldName +' FROM ' + sObjName + ' WHERE '+idField+' IN :ids GROUP BY ' + groupBy;
        List<AggregateResult> aggResults = Database.query(query);

        if (aggResults != null && !aggResults.isEmpty()) {
            return aggResults;
        } else {
            return null;
        }
    }

    public static Map<String,AggregateResult> aggregateSObjectMap(Set<String> ids,String idField,String sObjName,String fieldName,String groupBy,String key) {
        if (ids == null || ids.isEmpty()) {
            return null;
        }
        if (String.isBlank(sObjName)) {
            return null;
        }
        if (String.isBlank(fieldName)) {
            return null;
        }
        if (String.isBlank(key)) {
            return null;
        }
        String query = 'SELECT ' + groupBy +' , ' + fieldName +' FROM ' + sObjName + ' WHERE '+idField+' IN :ids GROUP BY ' + groupBy;
        System.debug('aggregateSObjectMap strQuery ::'+query);
        List<AggregateResult> aggResults = Database.query(query);

        if (aggResults != null && !aggResults.isEmpty()) {
            Map<String,AggregateResult> resultMap = new Map<String,AggregateResult>();
            for(AggregateResult agg : aggResults ){
                resultMap.put((String)agg.get(key),agg);
            }
            return resultMap;
        } else {
            return null;
        }
    }

    public static Decimal aggregateSObjectDecimal(Set<String> ids,String idField,String sObjName, String fieldName, String aggFunction) {
        if (ids == null || ids.isEmpty()) {
            return null;
        }
        if (String.isBlank(sObjName)) {
            return null;
        }
        if (String.isBlank(fieldName)) {
            return null;
        }
        if (String.isBlank(aggFunction)) {
            return null;
        }
        Set<String> validFunctions = new Set<String>{'COUNT', 'SUM', 'MIN', 'MAX', 'AVG'};
        if (!validFunctions.contains(aggFunction.toUpperCase())) {
            return null;
        }
        String query = 'SELECT ' + aggFunction + '(' + fieldName + ') result FROM ' + sObjName + ' WHERE '+idField+' IN :ids';
        List<AggregateResult> aggResults = Database.query(query);
        if (aggResults != null && !aggResults.isEmpty()) {
            return (Decimal)aggResults[0].get('result');
        } else {
            return null;
        }
    }

    public static Map<String,Decimal> aggregateSObjectDecimal(Set<String> ids,String idField,String sObjName, String fieldName, String aggFunction,String groupBy) {
        if (ids == null || ids.isEmpty()) {
            return null;
        }
        if (String.isBlank(sObjName)) {
            return null;
        }
        if (String.isBlank(fieldName)) {
            return null;
        }
        if (String.isBlank(aggFunction)) {
            return null;
        }
        if (String.isBlank(groupBy)) {
            return null;
        }
        Set<String> validFunctions = new Set<String>{'COUNT', 'SUM', 'MIN', 'MAX', 'AVG'};
        if (!validFunctions.contains(aggFunction.toUpperCase())) {
            return null;
        }
        String query = 'SELECT ' +groupBy+', ' + aggFunction + '(' + fieldName + ') result FROM ' + sObjName + ' WHERE '+idField+' IN :ids GROUP BY '+groupBy;
        List<AggregateResult> aggResults = Database.query(query);
        Map<String,Decimal> agMap = new Map<String,Decimal>();
        for(AggregateResult ag : aggResults) {
            String agStr = String.valueOf(ag.get(groupBy));
            Decimal resultField = (Decimal)ag.get('result');
            agMap.put(agStr,resultField);
        }

        if (aggResults != null && !aggResults.isEmpty()) {
            return agMap;
        } else {
            return null;
        }
    }

    public static Decimal aggregateSObjectDecimal(List<SObject> sObjectList, String fieldName, String aggFunction) {
        if (sObjectList == null || sObjectList.isEmpty()) {
            return null;
        }
        if (String.isBlank(fieldName)) {
            return null;
        }
        if (String.isBlank(aggFunction)) {
            return null;
        }
        Set<String> validFunctions = new Set<String>{'COUNT', 'SUM', 'MIN', 'MAX', 'AVG'};
        if (!validFunctions.contains(aggFunction.toUpperCase())) {
            return null;
        }
        String sObjectType = sObjectList[0].getSObjectType().getDescribe().getName();
        String query = 'SELECT ' + aggFunction + '(' + fieldName + ') result FROM ' + sObjectType + ' WHERE Id IN :sObjectList';
        List<AggregateResult> aggResults = Database.query(query);
        if (aggResults != null && !aggResults.isEmpty()) {
            return (Decimal)aggResults[0].get('result');
        } else {
            return null;
        }
    }

    public static Map<String,Decimal> aggregateSObjectDecimal(List<SObject> sObjectList, String fieldName, String aggFunction,String groupBy) {
        if (sObjectList == null || sObjectList.isEmpty()) {
            return null;
        }
        if (String.isBlank(fieldName)) {
            return null;
        }
        if (String.isBlank(aggFunction)) {
            return null;
        }
        Set<String> validFunctions = new Set<String>{'COUNT', 'SUM', 'MIN', 'MAX', 'AVG'};
        if (!validFunctions.contains(aggFunction.toUpperCase())) {
            return null;
        }
        String sObjectType = sObjectList[0].getSObjectType().getDescribe().getName();
        String query = 'SELECT ' +groupBy+', ' + aggFunction + '(' + fieldName + ') result FROM ' + sObjectType + ' WHERE Id IN :sObjectList GROUP BY '+groupBy;
        List<AggregateResult> aggResults = Database.query(query);
        Map<String,Decimal> agMap = new Map<String,Decimal>();
        for(AggregateResult ag : aggResults) {
            String agStr = String.valueOf(ag.get(groupBy));
            Decimal resultField = (Decimal)ag.get('result');
            agMap.put(agStr,resultField);
        }

        if (aggResults != null && !aggResults.isEmpty()) {
            return agMap;
        } else {
            return null;
        }
    }

    public static String joinedString(List<Object> objs) {
        List<String> strings = new List<String>();
        for (Object obj : objs) {
            strings.add((String) obj);
        }
        return '\'' + String.join(strings, '\',\'') + '\'';
    }
    public static String joinedSetString(Set<String> objs) {
        List<String> strings = new List<String>();
        for (String obj : objs) {
            strings.add(obj);
        }
        return '\'' + String.join(strings, '\',\'') + '\'';
    }

    public static String trimSearchParam(Map<String,Object> mapSearchParam,String key) {
        String trimStr = '';
        if(mapSearchParam.containsKey(key) && mapSearchParam.get(key) != ''){
            trimStr = String.valueOf(mapSearchParam.get(key));
        }
        return trimStr.trim();
    }

    public static Map<String,String> getPickListMap(String sObjKey,String fieldKey,String keyType) {
        DescribeSObjectResult describeSObjectResult = Schema.getGlobalDescribe().get(sObjKey).getDescribe();
        Schema.DescribeFieldResult describeFieldResult = describeSObjectResult.fields.getMap().get(fieldKey).getDescribe();
        Map<String,String> result = new Map<String,String>();
        for(Schema.PicklistEntry entry : describeFieldResult.getPicklistValues()) {
            if('value'.equals(keyType)){
                result.put(entry.getValue(),entry.getLabel());
            } else {
                result.put(entry.getLabel(),entry.getValue());
            }
        }
        return result;
    }

    public static Map<String,Object> convertMap(Object obj) {
        String jsonString = JSON.serialize(obj);
        return (Map<String,Object>) JSON.deserializeUntyped(jsonString);
    }

    public static List<Map<String, Object>> convertListMap(List<Object> objs) {
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        for(Object obj : objs) {
            String jsonString = JSON.serialize(obj);
            Map<String, Object> jsonParse = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
            result.add(jsonParse);
        }
        return result;
    }

    public static SObject getOrDefault(SObject input, String relationshipField) {
        if (input == null) {
            return Schema.getGlobalDescribe().get(input.getSObjectType().getDescribe().getName()).newSObject();
        }
        try {
            if (input.getSObject(relationshipField) != null) {
                return input.getSObject(relationshipField);
            } else {
                return input;
            }
        } catch (System.QueryException e) {
            return Schema.getGlobalDescribe().get(input.getSObjectType().getDescribe().getName()).newSObject();
        }
    }

    public static Map<String,List<AggregateResult>> aggregateSObjectListMap(String strQuery,String key,String joinKey,String key2) {
        Map<String, List<AggregateResult>> mapLists = new Map<String, List<AggregateResult>>();
        List<AggregateResult> sObjs = Database.query(strQuery);
        for (AggregateResult sObj : sObjs) {
            String keyValue =  getSObjStr(sObj,key) +joinKey;
            if(!''.equals(key2)){
                keyValue+=getSObjStr(sObj,key2);
            }
            if (!mapLists.containsKey(keyValue)) {
                mapLists.put(keyValue, new List<AggregateResult>());
            }
            mapLists.get(keyValue).add(sObj);
        }
        return mapLists;
    }


}
