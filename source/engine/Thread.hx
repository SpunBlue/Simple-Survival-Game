#if (target.threaded)
package engine;

import sys.thread.Lock;

class Thread
{
    private var thread:sys.thread.Thread;
    public var lock:Lock;

    public function new(func:Void->Void)
    {
        lock = new Lock();
        thread = sys.thread.Thread.create(func);
    }
}
#end