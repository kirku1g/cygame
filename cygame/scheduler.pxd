from cysfml cimport system

from cygame.sortedlist import SortedList

cdef class ScheduledItem:
    cdef public float call_time
    cdef public object callback


cdef class ScheduledIntervalItem(ScheduledItem):
    cdef public float interval


cdef class Scheduler:
    cdef public float last_update_time
    cdef public bint running, empty
    cdef system.Clock clock
    cdef list _scheduled_callbacks
    cdef object _scheduled_once_callbacks, _scheduled_interval_callbacks
    
    cpdef _schedule_time(Scheduler self, float delay)
    cpdef bint is_scheduled(Scheduler self, object callback)
    cpdef schedule(Scheduler self, object callback)
    cpdef schedule_once(Scheduler self, object callback, float delay)
    cpdef schedule_interval(Scheduler self, object callback, float interval)
    cpdef _unschedule_from_list(Scheduler self, sorted_list, callback)
    cpdef unschedule(Scheduler self, callback)
    cpdef clear(Scheduler self)
    cpdef start(Scheduler self)
    cpdef stop(Scheduler self)
    cpdef _reset_scheduled_times(Scheduler self)
    cpdef update(Scheduler self)


cdef public Scheduler cscheduler

