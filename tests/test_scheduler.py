import mock
import unittest

from time import sleep

from cygame import scheduler

class TestScheduler(unittest.TestCase):
    
    def test_scheduled_item(self):
        callback = lambda delta: delta * 2
        call_time = 10
        item = scheduler.ScheduledItem(call_time, callback)
        self.assertEqual(item.call_time, call_time)
        self.assertEqual(item.callback, callback)
    
    def test_scheduled_interval_item(self):
        callback = lambda delta: delta * 2
        call_time = 10
        interval = 5
        item = scheduler.ScheduledIntervalItem(call_time, callback, interval)
        self.assertEqual(item.call_time, call_time)
        self.assertEqual(item.callback, callback)
        self.assertEqual(item.interval, interval)
    
    def test_schedule_callback(self):
        sched = scheduler.Scheduler()
        callback = mock.Mock()
        sched.schedule(callback)
        sched.update()
        self.assertTrue(callback.called)
    
    def test_schedule_once_callback(self):
        sched = scheduler.Scheduler()
        callback = mock.Mock()
        sched.schedule_once(callback, 0.05)
        sched.update()
        self.assertFalse(callback.called)
        sleep(0.06)
        sched.update()
        self.assertTrue(callback.called)
        sleep(0.06)
        sched.update()
        self.assertEqual(len(callback.call_args_list), 1)
    
    def test_schedule_interval_callback(self):
        sched = scheduler.Scheduler()
        callback = mock.Mock()
        sched.schedule_interval(callback, 0.05)
        sched.update()
        self.assertFalse(callback.called)
        sleep(0.06)
        sched.update()
        self.assertEqual(len(callback.call_args_list), 1)
        self.assertTrue(callback.called)
        sleep(0.06)
        sched.update()
        self.assertEqual(len(callback.call_args_list), 2)
    
    def test_is_scheduled(self):
        sched = scheduler.Scheduler()
        callback = lambda delta: delta * 2
        self.assertFalse(sched.is_scheduled(callback))
        sched.schedule(callback)
        self.assertTrue(sched.is_scheduled(callback))
        sched.unschedule(callback)
        self.assertFalse(sched.is_scheduled(callback))
        sched.schedule_once(callback, 0.1)
        self.assertTrue(sched.is_scheduled(callback))
        sched.unschedule(callback)
        self.assertFalse(sched.is_scheduled(callback))
        sched.schedule_interval(callback, 0.1)
        self.assertTrue(sched.is_scheduled(callback))
        sched.unschedule(callback)
        self.assertFalse(sched.is_scheduled(callback))


if __name__ == '__main__':
    unittest.main()

