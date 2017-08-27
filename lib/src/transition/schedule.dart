part of grizzly.vizdom.transition;

/* TODO
class Schedule {
  final Element element;

  final String name;

  final int id;

  final int index;

  final String label;

  final UnmodifiableListView<Element> group;

  final timing; //TODO

  int _state = stateCreated;

  int get state => _state;

  Schedule(this.element, this.name);

  static const int stateCreated = 0;

  static const int stateScheduled = 1;

  static const int stateStarting = 2;

  static const int stateStarted = 3;

  static const int stateRunning = 4;

  static const int stateEnding = 5;

  static const int stateEnded = 6;

  //TODO find a way to
  static final Map<Element, Map<int, Schedule>> _scheduleMap = {};

  static Schedule getByElement(Element el, int id) {
    final Map<int, Schedule> elMap = _scheduleMap[el];
    if(elMap == null) throw new Exception("Not found!");  //TODO err string
    final Schedule sch = elMap[id];
    if(sch == null) throw new Exception("Not found!");  //TODO err string
    return sch;
  }

  static Schedule modifyByElement(Element el, int id) {
    final Schedule schedule = getByElement(el, id);
    if (schedule == null) return null;

    if (schedule.state > stateStarting)
      throw new Exception('Cannot modify after transition has started!');
    return schedule;
  }
}
*/