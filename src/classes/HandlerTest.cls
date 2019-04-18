/**
 * Created by derekwiers on 2019-04-12.
 */

@IsTest
public class HandlerTest {

    private static testMethod void handlerTest() {
        Handler tHandler = new TestHandler();
        Handler tHandler2 = new TrigTestObjectHandler();
        System.assertEquals(0, tHandler.beforeInsert().size());
        System.assertEquals(0, tHandler.afterInsert().size());
        System.assertEquals(0, tHandler.beforeUpdate().size());
        System.assertEquals(0, tHandler.afterUpdate().size());
        System.assertEquals(0, tHandler.beforeDelete().size());
        System.assertEquals(0, tHandler.afterDelete().size());
        System.assertEquals(0, tHandler.afterUndelete().size());
        System.assertEquals(0, tHandler.prefetchData(null).size());
        System.assertEquals(Trig_Test_Object__c.SObjectType, tHandler.handledSObjectType());
        System.assertEquals(1, tHandler2.beforeInsert().size());
        System.assertEquals(1, tHandler2.afterInsert().size());
        System.assertEquals(1, tHandler2.beforeUpdate().size());
        System.assertEquals(1, tHandler2.afterUpdate().size());
        System.assertEquals(1, tHandler2.beforeDelete().size());
        System.assertEquals(1, tHandler2.afterDelete().size());
        System.assertEquals(1, tHandler2.afterUndelete().size());
        System.assertEquals(2, tHandler2.prefetchData(null).size());
        System.assertEquals(Trig_Test_Object__c.SObjectType, tHandler2.handledSObjectType());
    }

    public class TestHandler extends Handler {

        public override SObjectType handledSObjectType() {
            return Trig_Test_Object__c.SObjectType;
        }

        public override List<Action> beforeInsert() {
            return super.beforeInsert();
        }

        public override List<Action> beforeUpdate() {
            return super.beforeUpdate();
        }

        public override List<Action> beforeDelete() {
            return super.beforeDelete();
        }

        public override List<Action> afterInsert() {
            return super.afterInsert();
        }

        public override List<Action> afterUpdate() {
            return super.afterUpdate();
        }

        public override List<Action> afterDelete() {
            return super.afterDelete();
        }

        public override List<Action> afterUndelete() {
            return super.afterUndelete();
        }

        public override Map<String, Object> prefetchData(Context context) {
            return super.prefetchData(context);
        }

    }
}