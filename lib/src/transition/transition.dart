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

class Transition {
  UnmodifiableListView<UnmodifiableListView<Element>> get groups =>
      _selected.groups;

  UnmodifiableListView<Element> get parents => _selected.parents;

  UnmodifiableListView<Element> get allElements => _selected.allElements;

  final Selected _selected;

  final String name;

  Transition(this._selected, this.name);

  void _addAnimation(Animation ani, Element el) {
    if (_animations[el] == null) _animations[el] = {};
    _animations[el][name] = ani;
    _aniEls[ani] = el;
    ani.on['finish'].listen((_) {
      _deleteAnimationForEl(ani, el);
    });
    ani.on['cancel'].listen((_) {
      _deleteAnimationForEl(ani, el);
    });
  }

  void _deleteAnimationForEl(Animation ani, Element el) {
    if (_animations[el] != null && _animations[el][name] == ani) {
      _animations[el].remove(name);
      if (_animations[el].length == 0) _animations.remove(el);
    }
    _aniEls.remove(ani);
    ani.cancel();
  }

  Transition animate(Iterable<Map<String, dynamic>> keyframes,
      [Map<String, dynamic> timing]) {
    final Map<String, dynamic> timingTemp = new Map.from(timing);
    timingTemp['id'] = name;
    allElements.forEach((Element el) {
      // check that transitions with same name exists
      if (_animations[el] is Map && _animations[el][name] != null) {
        _deleteAnimationForEl(_animations[el][name], el);
      }
      final Animation animation = el.animate(keyframes, timing);
      _addAnimation(animation, el);
    });
    return this;
  }

  Transition animateWithBuilder(AnimationBuilder builder) {
    final Map<String, dynamic> timing = builder.options.make();
    timing['id'] = name;
    final List<Map<String, dynamic>> kfs = builder.keyframes.make();
    allElements.forEach((Element el) {
      // check that transitions with same name exists
      if (_animations[el] is Map && _animations[el][name] != null) {
        _deleteAnimationForEl(_animations[el][name], el);
      }
      final Animation animation = el.animate(kfs, timing);
      _addAnimation(animation, el);
    });
    return this;
  }

  Transition cancel() {
    allElements.forEach((Element el) {
      if (_animations[el] == null) return;
      if (!_animations[el].containsKey(name)) return;
      _deleteAnimationForEl(_animations[el][name], el);
      /* TODO: until element.getAnimations() is implemented
      el
          .getAnimations()
          .where((Animation ani) => ani.id == name)
          .forEach((Animation ani) => ani.cancel());
          */
    });
    return this;
  }

  Transition pause() {
    allElements.forEach((Element el) {
      if (_animations[el] == null) return;
      if (!_animations[el].containsKey(name)) return;
      _animations[el][name].pause();
      /* TODO: until element.getAnimations() is implemented
      el
          .getAnimations()
          .where((Animation ani) => ani.id == name)
          .forEach((Animation ani) => ani.pause());
          */
    });
    return this;
  }

  Transition play() {
    allElements.forEach((Element el) {
      if (_animations[el] == null) return;
      if (!_animations[el].containsKey(name)) return;
      _animations[el][name].play();
      /* TODO: until element.getAnimations() is implemented
      el
          .getAnimations()
          .where((Animation ani) => ani.id == name)
          .forEach((Animation ani) => ani.play());
          */
    });
    return this;
  }

  Transition finish() {
    allElements.forEach((Element el) {
      if (_animations[el] == null) return;
      if (!_animations[el].containsKey(name)) return;
      _animations[el][name].finish();
      /* TODO: until element.getAnimations() is implemented
      el
          .getAnimations()
          .where((Animation ani) => ani.id == name)
          .forEach((Animation ani) => ani.finish());
          */
    });
    return this;
  }

  Transition reverse() {
    allElements.forEach((Element el) {
      if (_animations[el] == null) return;
      if (!_animations[el].containsKey(name)) return;
      _animations[el][name].reverse();
      /* TODO: until element.getAnimations() is implemented
      el
          .getAnimations()
          .where((Animation ani) => ani.id == name)
          .forEach((Animation ani) => ani.reverse());
          */
    });
    return this;
  }

  Transition removeOnFinish() {
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

  Transition onFinish() {
    /* TODO
    allElements.forEach((Element el) {
      final Animation ani = el
          .getAnimations()
          .firstWhere((Animation ani) => ani.id == name, orElse: () => null);
      if (ani != null) {
        ani.on['finish'].listen((_) {
          el.remove();
        });
        ani.on['cancel'].listen((_) {
          el.remove();
        });
      }
    });
    */
    return this;
  }

  static final Map<Element, Map<String, Animation>> _animations = {};

  static final Map<Animation, Element> _aniEls = {};
}
