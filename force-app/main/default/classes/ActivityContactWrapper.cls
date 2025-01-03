/**
 * Wrapper class for Task and Contact objects used for criteria evaluation
 */
public class ActivityContactWrapper {
    public Task t { get; set; }
    public Event e { get; set;}
    public Contact c { get; set; }

    public ActivityContactWrapper(Task t, Contact c) {
        this.t = t;
        this.c = c;
    }

    public ActivityContactWrapper(Event e, Contact c){
        this.e = e;
        this.c = c;
    }
}