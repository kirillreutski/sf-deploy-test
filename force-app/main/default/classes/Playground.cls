/**
 * Created by kirillreutski on 31.10.24.
 */

public without sharing class Playground {

    public static void insertAction(){
        AssetAction action = new AssetAction(Category = 'test');
        insert action;
    }
    public static void apiVersionCheck() {
        List<AssetAction> actions = [SELECT Id, Category FROM AssetAction];

    }

    public static void testInvokeMethod(){
        pp_LogPooler logFactory = pp_LogPooler.getInstance();
        logFactory.log('call from testInvokeMethod');
        testInvokeMethod2();
    }

    public static void testInvokeMethod2(){
        pp_LogPooler logFactory = pp_LogPooler.getInstance('overrideClass', 'overrideMethod');
        logFactory.log('call from testInvokeMethod2');
        testInvokeMethod3();
    }

    public static void testInvokeMethod3(){
        pp_LogPooler.getInstance().log('call from testInvokeMethod3');
    }


    public static void mapping(){
        pp_Mapper mapper = new pp_Mapper();
        mapper.mapFields(new Map<String, Object>{
                'name' => 'Name',
                'description' => 'Description'
        });
    }
}