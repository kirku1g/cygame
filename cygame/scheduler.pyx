cimport system

from time import time


cdef insort_time(list scheduled_items, tuple item):

    cdef:
        double insert_time = item[0]
        double current_time
        unsigned int length = len(scheduled_items)
        unsigned int lo = 0
        unsigned int hi = length
        unsigned int mid
    
    while lo < hi:
        mid = (lo + hi) / 2
        current_time = scheduled_items[mid][0]
        if insert_time >= current_time:
            hi = mid
        else:
            lo = mid + 1
    
    if lo == length:
        scheduled_items.append(item)
    else:
        scheduled_items.insert(lo, item)


cdef remove_callback(list scheduled_items, object callback):
    for index, item in enumerate(scheduled_items):
        if item[1] == callback:
            del scheduled_items[index]


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
    
    cpdef _schedule_time(Scheduler self, double delay):
        '''
        Time complexity: O(1)
        '''
        if self.running:
            delay += time()
        
        return delay

    cpdef schedule(Scheduler self, object callback):
        '''
        Schedule a callback to run every time update is called.
        
        Time complexity: O(1)
        
        :param callback: Callable.
        '''
        self._scheduled_callbacks.append(callback)
        self.empty = False
    
    cpdef schedule_once(Scheduler self, object callback, double delay):
        '''
        Schedule a callback to run after a delay.        
        
        Time complexity: ~O(n)        
        
        :param callback: Callable.
        :param interval: Interval to call callback in seconds.
        '''
        insort_time(
            self._scheduled_once_callbacks,
            (self._schedule_time(delay), callback),
        )
        self.empty = False
    
    cpdef schedule_interval(Scheduler self, object callback, double interval):
        '''
        Schedule a callback to run at an interval defined in seconds.
        
        Time complexity: ~O(n)        
        
        :param callback: Callable.
        :param interval: Interval to call callback in seconds.
        '''
        insort_time(
            self._scheduled_interval_callbacks,
            (self._schedule_time(interval), callback, interval),
        )
        self.empty = False
    
    cpdef unschedule(Scheduler self, object callback):
        '''
        Updates self.empty if scheduler becomes empty.
        
        Time complexity: O(n)
        '''
        if self.empty:
            return
        self._scheduled_callbacks = [s for s in self._scheduled_callbacks if s != callback]
        self._scheduled_once_callbacks = [s for s in self._scheduled_once_callbacks if s[1] != callback]
        self._scheduled_interval_callbacks = [s for s in self._scheduled_interval_callbacks if s[1] != callback]
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
        self._scheduled_once_callbacks = []
        self._scheduled_interval_callbacks = []
        self.empty = False
    
    cpdef start(Scheduler self):
        if self.running:
            return
        self.running = True
        if self.empty:
            return
        cdef double current_time = time()
        self._shift_scheduled_times(current_time)
        self.last_update_time = current_time
    
    cpdef stop(Scheduler self):
        if not self.running:
            return
        if self.empty:
            return
        self.running = False
        self._shift_scheduled_times(self.clock.get_elapsed_time())
    
    cpdef _shift_scheduled_times(Scheduler self, double duration):
        '''
        Check if self.empty before calling to avoid unnecessary list comprehensions.
        
        Time complexity: O(n)
        '''
        self._scheduled_once_callbacks = [
            (call_time + duration, callback)
            for call_time, callback
            in self._scheduled_once_callbacks
        ]
        self._scheduled_interval_callbacks = [
            (call_time + duration, callback, interval)
            for call_time, callback, interval
            in self._scheduled_interval_callbacks
        ]
    
    cpdef update(Scheduler self):
        '''
        Check empty attribute before calling to avoid overhead.
        
        Time complexity: O(1) < O(n)
        '''
        if not self.running:
            return
        
        cdef double current_time = time()
        cdef double elapsed_time = current_time - self.last_update_time
        self.last_update_time = current_time
            
        cdef object callback
        for callback in self._scheduled_callbacks:
            callback(elapsed_time)
        
        cdef double call_time
        for call_time, callback in reversed(self._scheduled_once_callbacks):
            if call_time > current_time:
                break
            callback()
            self._scheduled_once_callbacks.pop()
        
        cdef double interval
        for call_time, callback, interval in reversed(self._scheduled_interval_callbacks):
            if call_time > current_time:
                break
            callback()
            self._scheduled_interval_callbacks.pop()
            self.schedule_interval(callback, interval)

