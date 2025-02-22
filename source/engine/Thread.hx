#if (target.threaded)
package engine;

import sys.thread.Lock;

class Thread
{
    public var thread:sys.thread.Thread;

    public function new(func:Void->Void)
    {
        thread = sys.thread.Thread.create(func);
    }
}
#end