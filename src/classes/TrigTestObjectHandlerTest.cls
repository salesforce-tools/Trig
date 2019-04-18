/**
 * Created by derekwiers on 2019-04-15.
 */

@IsTest
private class TrigTestObjectHandlerTest {

    private static testMethod void triggerOperationTest() {
        TrigTestObjectHandler h = new TrigTestObjectHandler();

        System.assertEquals(1, h.beforeDelete().size());
        System.assertEquals(1, h.afterDelete().size());
        System.assertEquals(1, h.beforeInsert().size());
        System.assertEquals(1, h.afterInsert().size());
        System.assertEquals(1, h.beforeUpdate().size());
        System.assertEquals(1, h.afterUpdate().size());
        System.assertEquals(1, h.afterUndelete().size());
    }
}