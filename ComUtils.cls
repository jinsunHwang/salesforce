/**
 * Created by User on 2023-10-16.
 */

public with sharing class ComUtils {

    private ComUtils(){}

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

    public static Map<String, SObject> getSObjKeyMap(List<SObject>sObjs, String keyStr) {
        Map<String, SObject> sObjMap = new Map<String, SObject>();
        for(SObject sObj : sObjs) {
            sObjMap.put(getSObjStr(sObj,keyStr),sObj);
        }
        return sObjMap.isEmpty() ? null :sObjMap;
    }

    public static Map<String, SObject> getSObjKeyMapJoin(List<SObject>sObjs, String keyStr, String joinKey, String keyStr2) {
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

    public static Map<String,List<SObject>> getStringListSObjectQueryJoin(String strQuery,String key,String joinKey,String key2) {
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

    public static Map<String,List<SObject>> getStringListSObjectJoin(List<SObject> sObjs,String key,String joinKey,String key2) {
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

    public static Map<String,AggregateResult> aggregateSObjectQueryMap(String strQuery,String keyStr) {
        Map<String, AggregateResult> sObjMap = new Map<String, AggregateResult>();
        List<AggregateResult> sObjs = Database.query(strQuery);
        for (AggregateResult sObj : sObjs) {
            sObjMap.put(String.valueOf(sObj.get(keyStr)),sObj);
        }
        return sObjMap.isEmpty() ? null :sObjMap;
    }

    public static Map<String,AggregateResult> aggregateSObjectQueryMapJoin(String strQuery,String keyStr,String joinKey,String keyStr2) {
        Map<String, AggregateResult> sObjMap = new Map<String, AggregateResult>();
        List<AggregateResult> sObjs = Database.query(strQuery);
        String joinStr = '';
        for(AggregateResult sObj : sObjs) {
            if (!''.equals(keyStr2)) {
                joinStr = String.valueOf(sObj.get(keyStr2)) ;
            }
            sObjMap.put(String.valueOf(sObj.get(keyStr)) + joinKey + joinStr, sObj);
        }
        return sObjMap.isEmpty() ? null :sObjMap;
    }

    public static Map<String,AggregateResult> aggregateSObjectMap(List<AggregateResult> sObjs,String keyStr) {
        Map<String, AggregateResult> sObjMap = new Map<String, AggregateResult>();
        for (AggregateResult sObj : sObjs) {
            sObjMap.put(String.valueOf(sObj.get(keyStr)),sObj);
        }
        return sObjMap.isEmpty() ? null :sObjMap;
    }

    public static Map<String,AggregateResult> aggregateSObjectMapJoin(List<AggregateResult> sObjs,String keyStr,String joinKey,String keyStr2) {
        Map<String, AggregateResult> sObjMap = new Map<String, AggregateResult>();
        String joinStr = '';
        for(AggregateResult sObj : sObjs) {
            if (!''.equals(keyStr2)) {
                joinStr = String.valueOf(sObj.get(keyStr2)) ;
            }
            sObjMap.put(String.valueOf(sObj.get(keyStr)) + joinKey + joinStr, sObj);
        }
        return sObjMap.isEmpty() ? null :sObjMap;
    }

    public static Map<String,List<AggregateResult>> aggregateSObjectQueryListMap(String strQuery,String key) {
        Map<String, List<AggregateResult>> mapLists = new Map<String, List<AggregateResult>>();
        List<AggregateResult> sObjs = Database.query(strQuery);
        for (AggregateResult sObj : sObjs) {
            String keyValue =  String.valueOf(sObj.get(key)) ;
            if (!mapLists.containsKey(keyValue)) {
                mapLists.put(keyValue, new List<SObject>());
            }
            mapLists.get(keyValue).add(sObj);
        }
        return mapLists;
    }

    public static Map<String,List<AggregateResult>> aggregateSObjectQueryListMapJoin(String strQuery,String key,String joinKey,String key2) {
        Map<String, List<AggregateResult>> mapLists = new Map<String, List<AggregateResult>>();
        List<AggregateResult> sObjs = Database.query(strQuery);
        for (AggregateResult sObj : sObjs) {
            String keyValue =  String.valueOf(sObj.get(key)) +joinKey;
            if(!''.equals(key2)){
                keyValue+=String.valueOf(sObj.get(key2));
            }
            if (!mapLists.containsKey(keyValue)) {
                mapLists.put(keyValue, new List<AggregateResult>());
            }
            mapLists.get(keyValue).add(sObj);
        }
        return mapLists;
    }

    public static Map<String,List<AggregateResult>> aggregateSObjectListMap(List<AggregateResult> sObjs,String key) {
        Map<String, List<AggregateResult>> mapLists = new Map<String, List<AggregateResult>>();
        for (AggregateResult sObj : sObjs) {
            String keyValue =  String.valueOf(sObj.get(key)) ;
            if (!mapLists.containsKey(keyValue)) {
                mapLists.put(keyValue, new List<SObject>());
            }
            mapLists.get(keyValue).add(sObj);
        }
        return mapLists;
    }

    public static Map<String,List<AggregateResult>> aggregateSObjectListMapJoin(List<AggregateResult> sObjs,String key,String joinKey,String key2) {
        Map<String, List<AggregateResult>> mapLists = new Map<String, List<AggregateResult>>();
        for (AggregateResult sObj : sObjs) {
            String keyValue =  String.valueOf(sObj.get(key)) +joinKey;
            if(!''.equals(key2)){
                keyValue+=String.valueOf(sObj.get(key2));
            }
            if (!mapLists.containsKey(keyValue)) {
                mapLists.put(keyValue, new List<AggregateResult>());
            }
            mapLists.get(keyValue).add(sObj);
        }
        return mapLists;
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

    public static Object nvl(Object value, Object defaultValue) {
        if(value == null) {
            return defaultValue;
        }
        return value;
    }



}
