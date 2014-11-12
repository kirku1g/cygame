cimport system


cdef class Scheduler:
    cdef:
        system.Clock clock
        list _scheduled_callbacks, _scheduled_interval_callbacks, _scheduled_once_callbacks
        public double last_update_time
        public bint running
        readonly bint empty
    
    cpdef _schedule_time(Scheduler self, double delay)
    cpdef schedule(Scheduler self, object callback)
    cpdef schedule_once(Scheduler self, object callback, double delay)
    cpdef schedule_interval(Scheduler self, object callback, double interval)
    cpdef unschedule(Scheduler self, object callback)
    cpdef clear(Scheduler self)
    cpdef start(Scheduler self)
    cpdef stop(Scheduler self)
    cpdef _shift_scheduled_times(Scheduler self, double duration)
    cpdef update(Scheduler self)
