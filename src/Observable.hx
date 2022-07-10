package;

typedef Observer<T> = T -> Void;

@:generic
class Observable<T>
{
    @:isVar public var value(get, set): T;
    private var observers: Array<Observer<T>> = [];

    public inline function get_value()
    {
        return value;
    }

    public function set_value(value: T)
    {
        this.value = value;
        for (o in observers)
            o(value);
        return value;
    }

    public inline function addObserver(observer: Observer<T>)
    {
        this.observers.push(observer);
    }

    public inline function new(v: T)
    {
        value = v;
    }
}
