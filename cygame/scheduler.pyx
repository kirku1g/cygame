from cysfml cimport system
from cysfml.utils cimport richcmp_floats

from cygame.sortedlist import SortedList


cdef class ScheduledItem:
    def __cinit__(ScheduledItem self, float call_time, callback, *args):
        self.call_time = call_time
        self.callback = callback
    
    def __richcmp__(ScheduledItem self, ScheduledItem other, int op):
        return richcmp_floats(self.call_time, other.call_time, op)


cdef class ScheduledIntervalItem(ScheduledItem):
    def __cinit__(ScheduledIntervalItem self, float call_time, callback, float interval):
        self.interval = interval



cdef class Scheduler:
    '''
    '''
    def __cinit__(Scheduler self, bint running=True):
        # Initialise lists.
        self.clear()
        
        self.clock = system.Clock()
        self.last_update_time = 0
        self.running = running
        self.empty = True
    
    cpdef _schedule_time(Scheduler self, float delay):
        '''
        Time complexity: O(1)
        '''
        return delay + self.clock.get_elapsed_seconds()
    
    cpdef bint is_scheduled(Scheduler self, object callback):
        if self.empty:
            return False
        
        if callback in self._scheduled_callbacks:
            return True
        
        cdef ScheduledItem item
        for item in self._scheduled_once_callbacks:
            if item.callback == callback:
                return True
        
        cdef ScheduledIntervalItem interval_item
        for interval_item in self._scheduled_interval_callbacks:
            if interval_item.callback == callback:
                return True

    cpdef schedule(Scheduler self, object callback):
        '''
        Schedule a callback to run every time update is called.
        
        Time complexity: O(1)
        
        :param callback: Callable.
        '''
        self._scheduled_callbacks.append(callback)
        self.empty = False
    
    cpdef schedule_once(Scheduler self, object callback, float delay):
        '''
        Schedule a callback to run after a delay.
        
        Time complexity: ~O(n)
        
        :param callback: Callable.
        :param interval: Interval to call callback in seconds.
        '''
        self._scheduled_once_callbacks.add(
            ScheduledItem(self._schedule_time(delay), callback),
        )
        self.empty = False
    
    cpdef schedule_interval(Scheduler self, object callback, float interval):
        '''
        Schedule a callback to run at an interval defined in seconds.
        
        Time complexity: ~O(n)        
        
        :param callback: Callable.
        :param interval: Interval to call callback in seconds.
        '''
        self._scheduled_interval_callbacks.add(
            ScheduledIntervalItem(
                self._schedule_time(interval),
                callback,
                interval,
            ),
        )
        self.empty = False
    
    cpdef _unschedule_from_list(Scheduler self, sorted_list, callback):
        cdef unsigned int idx, deleted = 0
        for idx, s in enumerate(sorted_list.as_list()):
            if callback == s.callback:
                del sorted_list[idx - deleted]
                deleted += 1
    
    cpdef unschedule(Scheduler self, callback):
        '''
        Updates self.empty if scheduler becomes empty.
        
        Time complexity: O(n)
        '''
        if self.empty:
            return
        
        self._scheduled_callbacks = [c for c in self._scheduled_callbacks if c != callback]
        self._unschedule_from_list(self._scheduled_once_callbacks, callback)
        self._unschedule_from_list(self._scheduled_interval_callbacks, callback)
        
        self.empty = (
            not self._scheduled_callbacks and
            not self._scheduled_once_callbacks and
            not self._scheduled_interval_callbacks
        )
    
    cpdef clear(Scheduler self):
        '''
        Clear all scheduled callbacks. Sets self.empty to False.
        
        Time complexity: O(1)
        '''
        self._scheduled_callbacks = []
        self._scheduled_once_callbacks = SortedList()
        self._scheduled_interval_callbacks = SortedList()
        self.empty = False
    
    cpdef start(Scheduler self):
        if self.running:
            return
        self.running = True
        if self.empty:
            return
        self.last_update_time = 0
        self.clock.restart()
        self.update()
    
    cpdef stop(Scheduler self):
        if not self.running:
            return
        self.running = False
        if self.empty:
            return
        self._reset_scheduled_times()
    
    cpdef _reset_scheduled_times(Scheduler self):
        '''
        Check if self.empty before calling to avoid unnecessary list comprehensions.
        
        Time complexity: O(n)
        '''
        cdef float current_time = self.clock.get_elapsed_seconds()
        
        for s in self._scheduled_once_callbacks:
            s.call_time -= current_time
        
        for s in self._scheduled_interval_callbacks:
            s.call_time -= current_time
    
    cpdef update(Scheduler self):
        '''
        Check empty attribute before calling to avoid overhead.
        
        Time complexity: O(1) < O(n)
        '''
        if self.empty or not self.running:
            return
        
        cdef float current_time = self.clock.get_elapsed_seconds()
        cdef float elapsed_time = current_time - self.last_update_time
        
        cdef object callback
        for callback in self._scheduled_callbacks:
            callback(elapsed_time)
        
        cdef ScheduledItem item
        for item in self._scheduled_once_callbacks.as_list():
            if item.call_time > current_time:
                break
            item.callback()
            del self._scheduled_once_callbacks[0]
        
        cdef ScheduledIntervalItem interval_item
        for interval_item in self._scheduled_interval_callbacks.as_list():
            if interval_item.call_time > current_time:
                break
            interval_item.callback()
            del self._scheduled_interval_callbacks[0]
            self.schedule_interval(interval_item.callback, interval_item.interval)
        
        self.last_update_time = self.clock.get_elapsed_seconds()


scheduler = Scheduler()
cdef Scheduler cscheduler = scheduler

