/// Transition on an element shall be remembered so they can cancelled later.
///
/// Transition must be [Selected]
///
/// An element should be able to have more than one transition on them identified
/// by (TBD: name/id?)
///
/// Whats the difference between name and id?
///
/// Remove when transition is complete
///
/// EventStreams for transtition end, TODO
library grizzly.vizdom.transition;

import 'dart:collection';
import 'dart:html' hide Selection;
import 'package:animation_builder/animation_builder.dart';

import '../selection/selection.dart';

part 'schedule.dart';

abstract class TransitionBase {
  Selected get selection;

  String get name;

  UnmodifiableListView<UnmodifiableListView<Element>> get groups;

  UnmodifiableListView<Element> get parents;

  UnmodifiableListView<Element> get allElements;

  TransitionBase animate(
      Iterable<Map<String, dynamic>> keyframes, Map<String, dynamic> timing);

  TransitionBase animateWithBuilder(AnimationBuilder builder);

  TransitionBase cancel();

  TransitionBase pause();

  TransitionBase play();

  TransitionBase finish();

  TransitionBase reverse();

  TransitionBase removeOnFinish();

  TransitionBase onFinish(callback(SelectionItem item));

  TransitionBase transition(String name);
}

abstract class TransitionMixin implements TransitionBase {
  Selected get selection;

  String get name;

  UnmodifiableListView<UnmodifiableListView<Element>> get groups =>
      selection.groups;

  UnmodifiableListView<Element> get parents => selection.parents;

  UnmodifiableListView<Element> get allElements => selection.allElements;

  TransitionBase animate(
      Iterable<Map<String, dynamic>> keyframes, Map<String, dynamic> timing) {
    final Map<String, dynamic> timingTemp = new Map.from(timing);
    timingTemp['id'] = name;
    allElements.forEach((Element el) {
      // check that transitions with same name exists
      if (_animations[el] is Map && _animations[el][name] != null) {
        _deleteAnimationForEl(name, _animations[el][name], el);
      }
      final Animation animation = el.animate(keyframes, timing);
      _addAnimation(name, animation, el);
    });
    return this;
  }

  TransitionBase animateWithBuilder(AnimationBuilder builder) {
    final Map<String, dynamic> timing = builder.options.make();
    timing['id'] = name;
    final List<Map<String, dynamic>> kfs = builder.keyframes.make();
    allElements.forEach((Element el) {
      // check that transitions with same name exists
      if (_animations[el] is Map && _animations[el][name] != null) {
        _deleteAnimationForEl(name, _animations[el][name], el);
      }
      final Animation animation = el.animate(kfs, timing);
      _addAnimation(name, animation, el);
    });
    return this;
  }

  TransitionBase chain(Iterable<Map<String, dynamic>> keyframes,
      Map<String, dynamic> timing, String previous) {
    final Map<String, dynamic> timingTemp = new Map.from(timing);
    timingTemp['id'] = name;
    allElements.forEach((Element el) {
      if (_animations[el] is Map && _animations[el][previous] == null) {
        return;
      }
      final Animation animation = _animations[el][previous];
      animation.on['finish'].listen((_) {
        if (_animations[el] is Map && _animations[el][name] != null) {
          _deleteAnimationForEl(name, _animations[el][name], el);
        }
        final Animation animation = el.animate(keyframes, timing);
        _addAnimation(name, animation, el);
      });
    });
    return this;
  }

  TransitionBase chainWithBuilder(AnimationBuilder builder, String previous) {
    final Map<String, dynamic> timing = builder.options.make();
    timing['id'] = name;
    final List<Map<String, dynamic>> kfs = builder.keyframes.make();
    allElements.forEach((Element el) {
      if (_animations[el] is Map && _animations[el][previous] == null) {
        return;
      }
      final Animation animation = _animations[el][previous];
      animation.on['finish'].listen((_) {
        if (_animations[el] is Map && _animations[el][name] != null) {
          _deleteAnimationForEl(name, _animations[el][name], el);
        }
        final Animation animation = el.animate(kfs, timing);
        _addAnimation(name, animation, el);
      });
    });
    return this;
  }

  TransitionBase cancel() {
    allElements.forEach((Element el) {
      if (_animations[el] == null) return;
      if (!_animations[el].containsKey(name)) return;
      _deleteAnimationForEl(name, _animations[el][name], el);
    });
    return this;
  }

  TransitionBase pause() {
    allElements.forEach((Element el) {
      if (_animations[el] == null) return;
      if (!_animations[el].containsKey(name)) return;
      _animations[el][name].pause();
    });
    return this;
  }

  TransitionBase play() {
    allElements.forEach((Element el) {
      if (_animations[el] == null) return;
      if (!_animations[el].containsKey(name)) return;
      _animations[el][name].play();
    });
    return this;
  }

  TransitionBase finish() {
    allElements.forEach((Element el) {
      if (_animations[el] == null) return;
      if (!_animations[el].containsKey(name)) return;
      _animations[el][name].finish();
    });
    return this;
  }

  TransitionBase reverse() {
    allElements.forEach((Element el) {
      if (_animations[el] == null) return;
      if (!_animations[el].containsKey(name)) return;
      _animations[el][name].reverse();
    });
    return this;
  }

  TransitionBase removeOnFinish() {
    allElements.forEach((Element el) {
      if (_animations[el] == null) return;
      if (!_animations[el].containsKey(name)) return;
      final Animation ani = _animations[el][name];
      ani.on['finish'].listen((_) {
        el.remove();
      });
      ani.on['cancel'].listen((_) {
        el.remove();
      });
    });
    return this;
  }

  TransitionBase onFinally(callback(SelectionItem item)) {
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        if (_animations[el] == null) continue;
        if (!_animations[el].containsKey(name)) continue;
        final Animation ani = _animations[el][name];
        ani.on['finish'].listen((_) {
          callback(new SelectionItem(j, i, parents[i], el));
        });
        ani.on['cancel'].listen((_) {
          callback(new SelectionItem(j, i, parents[i], el));
        });
      }
    }
    return this;
  }

  TransitionBase onFinish(callback(SelectionItem item)) {
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        if (_animations[el] == null) continue;
        if (!_animations[el].containsKey(name)) continue;
        final Animation ani = _animations[el][name];
        ani.on['finish'].listen((_) {
          callback(new SelectionItem(j, i, parents[i], el));
        });
      }
    }
    return this;
  }

  TransitionBase onCancel(callback(SelectionItem item)) {
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        if (_animations[el] == null) continue;
        if (!_animations[el].containsKey(name)) continue;
        final Animation ani = _animations[el][name];
        ani.on['cancel'].listen((_) {
          callback(new SelectionItem(j, i, parents[i], el));
        });
      }
    }
    return this;
  }
}

class Transition extends Object with TransitionMixin implements TransitionBase {
  final Selection selection;

  final String name;

  Transition(this.selection, this.name);

  Transition animate(Iterable<Map<String, dynamic>> keyframes,
          Map<String, dynamic> timing) =>
      super.animate(keyframes, timing);

  Transition animateWithBuilder(AnimationBuilder builder) =>
      super.animateWithBuilder(builder);

  Transition chain(Iterable<Map<String, dynamic>> keyframes,
          Map<String, dynamic> timing, String previous) =>
      super.chain(keyframes, timing, previous);

  Transition chainWithBuilder(AnimationBuilder builder, String previous) =>
      super.chainWithBuilder(builder, previous);

  Transition cancel() => super.cancel();

  Transition pause() => super.pause();

  Transition play() => super.play();

  Transition finish() => super.finish();

  Transition reverse() => super.reverse();

  Transition removeOnFinish() => super.removeOnFinish();

  Transition onFinish(callback(SelectionItem item)) => super.onFinish(callback);

  Transition onFinally(callback(SelectionItem item)) =>
      super.onFinally(callback);

  Transition onCancel(callback(SelectionItem item)) => super.onCancel(callback);

  Transition transition(String name) => new Transition(selection, name);
}

class BoundTransition<VT> extends Object
    with TransitionMixin
    implements TransitionBase {
  final BoundSelection<VT> selection;

  final String name;

  /// Labels of data bound to the selection
  UnmodifiableListView<String> get labels => selection.labels;

  /// The data bound to the selection
  UnmodifiableListView<VT> get data => selection.data;

  BoundTransition(this.selection, this.name);

  BoundTransition<VT> animate(Iterable<Map<String, dynamic>> keyframes,
          [Map<String, dynamic> timing]) =>
      super.animate(keyframes, timing);

  BoundTransition<VT> animateWithBuilder(AnimationBuilder builder) =>
      super.animateWithBuilder(builder);

  BoundTransition<VT> chain(Iterable<Map<String, dynamic>> keyframes,
          Map<String, dynamic> timing, String previous) =>
      super.chain(keyframes, timing, previous);

  BoundTransition<VT> chainWithBuilder(
          AnimationBuilder builder, String previous) =>
      super.chainWithBuilder(builder, previous);

  BoundTransition<VT> cancel() => super.cancel();

  BoundTransition<VT> pause() => super.pause();

  BoundTransition<VT> play() => super.play();

  BoundTransition<VT> finish() => super.finish();

  BoundTransition<VT> reverse() => super.reverse();

  BoundTransition<VT> removeOnFinish() => super.removeOnFinish();

  BoundTransition<VT> onFinish(callback(SelectionItem item)) =>
      super.onFinish(callback);

  BoundTransition<VT> onFinally(callback(SelectionItem item)) =>
      super.onFinally(callback);

  BoundTransition<VT> onCancel(callback(SelectionItem item)) =>
      super.onCancel(callback);

  BoundTransition<VT> onFinallyBound(callback(BoundItem<VT> bound)) {
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        if (_animations[el] == null) continue;
        if (!_animations[el].containsKey(name)) continue;
        final Animation ani = _animations[el][name];
        ani.on['finish'].listen((_) {
          callback(new BoundItem<VT>(el, data[j], labels[j], j));
        });
        ani.on['cancel'].listen((_) {
          callback(new BoundItem<VT>(el, data[j], labels[j], j));
        });
      }
    }
    return this;
  }

  BoundTransition<VT> onFinishBound(callback(BoundItem<VT> bound)) {
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        if (_animations[el] == null) continue;
        if (!_animations[el].containsKey(name)) continue;
        final Animation ani = _animations[el][name];
        ani.on['finish'].listen((_) {
          callback(new BoundItem<VT>(el, data[j], labels[j], j));
        });
      }
    }
    return this;
  }

  BoundTransition<VT> onCancelBound(callback(BoundItem<VT> bound)) {
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        if (_animations[el] == null) continue;
        if (!_animations[el].containsKey(name)) continue;
        final Animation ani = _animations[el][name];
        ani.on['cancel'].listen((_) {
          callback(new BoundItem<VT>(el, data[j], labels[j], j));
        });
      }
    }
    return this;
  }

  BoundTransition<VT> transition(String name) =>
      new BoundTransition<VT>(selection, name);
}

final Map<Element, Map<String, Animation>> _animations = {};

final Map<Animation, Element> _aniEls = {};

void _addAnimation(String name, Animation ani, Element el) {
  if (_animations[el] == null) _animations[el] = {};
  _animations[el][name] = ani;
  _aniEls[ani] = el;
  ani.on['finish'].listen((_) {
    _deleteAnimationForEl(name, ani, el);
  });
  ani.on['cancel'].listen((_) {
    _deleteAnimationForEl(name, ani, el);
  });
}

void _deleteAnimationForEl(String name, Animation ani, Element el) {
  if (_animations[el] != null && _animations[el][name] == ani) {
    _animations[el].remove(name);
    if (_animations[el].length == 0) _animations.remove(el);
  }
  _aniEls.remove(ani);
  ani.cancel();
}
